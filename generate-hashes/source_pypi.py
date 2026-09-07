"""
PyPI JSON-API backend for binary-wheel hash generation.

Used by packages with ``originType = "pypi"`` whose wheels are distributed
exclusively via PyPI (e.g. nvidia-cutlass-dsl, apache-tvm-ffi,
torch-c-dlpack-ext).  No files are downloaded; SHA-256 digests come directly
from the JSON API (``urls[].digests.sha256``).

Endpoints
---------
    https://pypi.org/pypi/{project}/json            – all release versions
    https://pypi.org/pypi/{project}/{version}/json  – files of one release

Usage
-----
    from source_pypi import fetch_pypi_versions, iter_linux_wheels

    for version in fetch_pypi_versions("apache-tvm-ffi", min_version="0.1.6"):
        for entry, parsed, os_name, arch in iter_linux_wheels("apache-tvm-ffi", version):
            ...
"""
from __future__ import annotations

import json
import re
import sys
from typing import Iterator
from urllib.error import HTTPError, URLError
from urllib.request import urlopen

from common import WheelEntry, parse_wheel_platform, sort_version_key

_PROJECT_URL = "https://pypi.org/pypi/{project}/json"
_RELEASE_URL = "https://pypi.org/pypi/{project}/{version}/json"

# Stable release: plain semver with 2+ components, optional .postN.
# Excludes dev / rc / a / b pre-releases.
_STABLE_RE = re.compile(r"^\d+(\.\d+)+(\.post\d+)?$")

# Wheel filename per PEP 427:
#   {distribution}-{version}(-{build})?-{python}-{abi}-{platform}.whl
_WHEEL_RE = re.compile(
    r"^(?P<dist>[\w.]+)"
    r"-(?P<version>[\w.!+]+)"
    r"(?:-\d[\w.]*)?"            # optional build number
    r"-(?P<py>[\w.]+)"
    r"-(?P<abi>[\w.]+)"
    r"-(?P<platform>[\w.]+)"
    r"\.whl$"
)


def _get_json(url: str) -> dict | None:
    """Fetch *url* and parse as JSON.  Returns ``None`` on HTTP 404."""
    try:
        with urlopen(url) as resp:
            return json.load(resp)
    except HTTPError as exc:
        if exc.code == 404:
            return None
        print(f"Error fetching {url}: {exc}", file=sys.stderr)
        sys.exit(1)
    except URLError as exc:
        print(f"Error fetching {url}: {exc}", file=sys.stderr)
        sys.exit(1)


def fetch_pypi_versions(
    project: str,
    min_version: str | None = None,
    stable_only: bool = True,
) -> list[str]:
    """
    Return the sorted list of release versions of *project* on PyPI.

    Parameters
    ----------
    project:
        PyPI project name, e.g. ``"apache-tvm-ffi"``.
    min_version:
        When given, drop versions older than this (compared with
        :func:`~common.sort_version_key`).
    stable_only:
        When ``True`` (default) drop dev / rc / alpha / beta pre-releases.
    """
    data = _get_json(_PROJECT_URL.format(project=project))
    if data is None:
        print(f"Error: PyPI project {project!r} not found.", file=sys.stderr)
        sys.exit(1)

    versions = [
        v for v, files in data.get("releases", {}).items()
        if files  # skip yanked/empty releases with no files
        and (not stable_only or _STABLE_RE.match(v))
    ]
    if min_version is not None:
        min_key = sort_version_key(min_version)
        versions = [v for v in versions if sort_version_key(v) >= min_key]
    return sorted(versions, key=sort_version_key)


def fetch_pypi_wheels(project: str, version: str) -> list[WheelEntry]:
    """
    Return one :class:`~common.WheelEntry` per wheel file of *project*
    *version*.  Sdists and files without a sha256 digest are skipped.
    Returns ``[]`` when the release does not exist (HTTP 404).
    """
    data = _get_json(_RELEASE_URL.format(project=project, version=version))
    if data is None:
        return []

    entries = []
    for f in data.get("urls", []):
        if f.get("packagetype") != "bdist_wheel":
            continue
        sha256 = f.get("digests", {}).get("sha256")
        if not sha256:
            continue
        entries.append(WheelEntry(name=f["filename"], url=f["url"], hexhash=sha256))
    return entries


def fetch_pypi_requires_dist(project: str, version: str) -> list[str]:
    """
    Return the ``Requires-Dist`` entries of *project* *version* as PyPI
    reports them (PEP 508 strings).  Returns ``[]`` when the release does
    not exist (HTTP 404).
    """
    data = _get_json(_RELEASE_URL.format(project=project, version=version))
    if data is None:
        return []
    return list(data.get("info", {}).get("requires_dist") or [])


def parse_pypi_wheel_filename(filename: str) -> dict | None:
    """
    Parse a wheel filename into its tag components.

    Returns ``None`` for unparseable names, otherwise a dict with:
        dist      distribution name as it appears in the filename
        version   version string
        py        python tag  (e.g. "cp312", "py3")
        abi       abi tag     (e.g. "cp312", "abi3", "none")
        platform  platform tag (may be compound, e.g.
                  "manylinux_2_24_x86_64.manylinux_2_28_x86_64")
    """
    m = _WHEEL_RE.match(filename)
    return m.groupdict() if m else None


def wheel_os_arch(platform_tag: str) -> tuple[str, str] | None:
    """
    Map a (possibly compound) wheel platform tag to ``(os, arch)``.
    ``"any"`` maps to ``("any", "any")``.
    """
    if platform_tag == "any":
        return ("any", "any")
    for p in platform_tag.split("."):
        result = parse_wheel_platform(p)
        if result is not None:
            return result
    return None


def manylinux_rank(platform_tag: str) -> int:
    """
    Preference rank for competing linux wheels of the same slot — higher is
    better.  Prefers newer-glibc manylinux variants (e.g. manylinux_2_28 over
    manylinux2014/manylinux_2_17) so the chosen wheel matches the toolchain
    used by the other pre-built wheels in this repo.
    """
    best = 0
    for p in platform_tag.split("."):
        m = re.match(r"manylinux_(\d+)_(\d+)_", p)
        if m:
            best = max(best, int(m.group(1)) * 100 + int(m.group(2)))
        elif p.startswith("manylinux2014"):
            best = max(best, 217)
        elif p.startswith("manylinux2010"):
            best = max(best, 212)
        elif p.startswith("manylinux1"):
            best = max(best, 205)
    return best


def cp_tag_to_pyver(py_tag: str, abi_tag: str) -> str | None:
    """
    Map CPython tags to the repo's pyVer keys.

    cp312/cp312    → "py312"
    cp314/cp314t   → "py314-freethreaded"
    py3/none (pure)→ "any"
    Other implementations (pp310, …) → None.
    """
    if py_tag in ("py3", "py2.py3") and abi_tag == "none":
        return "any"
    m = re.match(r"^cp(3\d+)$", py_tag)
    if m is None:
        return None
    if abi_tag.endswith("t"):
        return f"py{m.group(1)}-freethreaded"
    return f"py{m.group(1)}"


def collect_pyver_wheels(
    project: str,
    version: str,
    expand_abi3_to: list[int] | None = None,
) -> dict:
    """
    Fetch the Linux wheels of *project* *version* and organise them as
    ``pyVer -> os -> arch -> {name, url, hash}``.

    Per (pyVer, os, arch) slot the best wheel wins:
      1. an exact CPython tag (cp312-cp312) beats an abi3 wheel;
      2. among abi3 candidates the highest base CPython tag wins;
      3. ties are broken by :func:`manylinux_rank` (newest glibc wins).

    Parameters
    ----------
    expand_abi3_to:
        CPython 3.x minor versions (e.g. ``[12, 13, 14]``) to which
        ``cpXXX-abi3`` wheels are expanded: an abi3 wheel tagged cp312 fills
        every requested minor >= 12 that has no exact wheel.  ``None``
        (default) ignores abi3 wheels entirely.
    """
    # slot -> (is_exact, abi3_base_minor, manylinux_rank, entry)
    best: dict[tuple[str, str, str], tuple[int, int, int, WheelEntry]] = {}

    def consider(slot: tuple[str, str, str], key: tuple[int, int, int], entry: WheelEntry) -> None:
        if slot not in best or key > best[slot][:3]:
            best[slot] = (*key, entry)

    for entry, parsed, os_name, arch in iter_linux_wheels(project, version):
        rank = manylinux_rank(parsed["platform"])
        if parsed["abi"] == "abi3" and expand_abi3_to is not None:
            m = re.match(r"^cp3(\d+)$", parsed["py"])
            if m is None:
                continue
            base_minor = int(m.group(1))  # cp312 → 12
            for minor in expand_abi3_to:
                if minor >= base_minor:
                    consider((f"py3{minor:02d}", os_name, arch), (0, base_minor, rank), entry)
        else:
            py = cp_tag_to_pyver(parsed["py"], parsed["abi"])
            if py is None or py == "any":
                continue
            consider((py, os_name, arch), (1, 0, rank), entry)

    section: dict = {}
    for (py, os_name, arch), (_, _, _, entry) in sorted(best.items()):
        section.setdefault(py, {}).setdefault(os_name, {})[arch] = entry.to_leaf()
    return section


def iter_linux_wheels(project: str, version: str) -> Iterator[tuple[WheelEntry, dict, str, str]]:
    """
    Yield ``(entry, parsed, os, arch)`` for every parseable Linux wheel of
    *project* *version*.  ``parsed`` is the dict from
    :func:`parse_pypi_wheel_filename` (keys: dist, version, py, abi,
    platform) — callers map the python/abi tags with :func:`cp_tag_to_pyver`
    or handle ``abi3`` expansion themselves, and rank competing manylinux
    variants with :func:`manylinux_rank`.
    """
    for entry in fetch_pypi_wheels(project, version):
        parsed = parse_pypi_wheel_filename(entry.name)
        if parsed is None:
            continue
        os_arch = wheel_os_arch(parsed["platform"])
        if os_arch is None or os_arch[0] != "linux":
            continue
        yield entry, parsed, os_arch[0], os_arch[1]
