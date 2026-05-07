r"""
Shared wheel-filename parser for GitHub-release torch-compat packages.

All packages that distribute pre-built wheels via GitHub Releases using the
standard ``<pkg>-<version>+cu<N>torch<M.m>cxx11abi<ABI>-cp<PY>-cp<PY>-<platform>.whl``
naming convention can use the helpers here instead of writing their own.

Named capture groups
--------------------
The default regex and any custom override passed to :func:`build_parse_wheel`
must define the following named groups:

    version      – package version string, e.g. ``"2.8.3"`` or ``"1.6.0.post1"``
    cuda_digits  – raw CUDA digits without the ``cu`` prefix, e.g. ``"12"`` or ``"126"``
    torch_compat – raw torch compat string, e.g. ``"2.7"``
    cxx11abi     – ABI flag, ``"TRUE"`` or ``"FALSE"``; the group is **optional** —
                   when absent (wheel has no ``cxx11abi…`` tag) it defaults to
                   ``"TRUE"`` (new-ABI) in the shared factory.
    cpver        – CPython ABI tag, e.g. ``"cp312"``
    platform     – wheel platform tag, e.g. ``"linux_x86_64"``

Using named groups means package-specific overrides of :data:`WHEEL_RE` are
safe even if the group count or order differs, as long as the group *names*
are preserved.

Typical usage (per-package ``generate-hashes.py``)
--------------------------------------------------
Most packages need nothing beyond ``GITHUB_REPO``; the shared main derives the
default regex from the package directory name::

    # pkgs/my-pkg/generate-hashes.py
    ORIGIN_TYPE = "github-releases"
    GITHUB_REPO = "MyOrg/my-pkg"

To override the regex while keeping the shared ``parse_wheel`` logic::

    import re
    WHEEL_RE = re.compile(
        r"^my_pkg_alt_name-"
        r"(?P<version>\d+\.\d+\.\d+)"
        r"\+cu(?P<cuda_digits>\d+)torch"
        r"(?P<torch_compat>\d+\.\d+)"
        r"cxx11abi(?P<cxx11abi>TRUE|FALSE)"
        r"-(?P<cpver>cp\d+)-cp\d+-"
        r"(?P<platform>linux_x86_64|linux_aarch64)"
        r"\.whl$"
    )
"""
from __future__ import annotations

import re

from common.platform import parse_wheel_platform
from common.sort_keys import (
    normalize_torch_compat,
    sort_pyver_key,
    sort_torch_compat_key,
    sort_version_key,
)
from nix_writer.schema import DimSpec


# ---------------------------------------------------------------------------
# Default schema for all github-releases torch-compat packages
# ---------------------------------------------------------------------------

#: DimSpec list for the nesting levels *below* the version level.
#: Matches the cudaVersion → torchCompat → pyVer → os → arch hierarchy used by
#: flash-attn, causal-conv1d, and mamba-ssm.  Override in the package module
#: only when the structure genuinely differs.
DEFAULT_SCHEMA: list[DimSpec] = [
    DimSpec("cudaVersion"),
    DimSpec(
        "torchCompat",
        quoted=True,
        sort_key=sort_torch_compat_key,
        comment_fn=lambda k: f"── torch {k} {'─' * max(1, 60 - len(k))}",
    ),
    DimSpec("pyVer", sort_key=sort_pyver_key),
    DimSpec("os"),
    DimSpec("arch"),
]

#: Ordered dimension names including the leading ``"version"`` level.
DEFAULT_DIMENSIONS: list[str] = [
    "version", "cudaVersion", "torchCompat", "pyVer", "os", "arch",
]

#: DimSpec for the top-level version grouping (used for sort order only).
DEFAULT_VERSION_SPEC: DimSpec = DimSpec(
    "version", quoted=True, sort_key=sort_version_key,
)


# ---------------------------------------------------------------------------
# Default wheel regex factory
# ---------------------------------------------------------------------------

def make_default_wheel_re(pkg_dir_name: str) -> re.Pattern[str]:
    """
    Build the standard torch-compat wheel regex for *pkg_dir_name*.

    The package-name prefix in the regex is derived by replacing hyphens in
    *pkg_dir_name* with underscores (e.g. ``"flash-attn"`` → ``"flash_attn"``),
    matching the standard wheel normalisation rule.

    All six capture groups use names so that :func:`build_parse_wheel` can
    extract them regardless of how a custom override reorders them.

    Parameters
    ----------
    pkg_dir_name:
        The bare package *directory* name under ``pkgs/``, e.g.
        ``"flash-attn"`` or ``"causal-conv1d"``.

    Returns
    -------
    re.Pattern
        Compiled regex ready for use with :func:`build_parse_wheel`.
    """
    prefix = re.escape(pkg_dir_name.replace("-", "_"))
    return re.compile(
        rf"^{prefix}-"
        r"(?P<version>\d+\.\d+\.\d+(?:\.post\d+)?)"
        r"\+cu(?P<cuda_digits>\d+)torch"
        r"(?P<torch_compat>\d+\.\d+)"
        r"(?:cxx11abi(?P<cxx11abi>TRUE|FALSE))?"   # optional — some wheels omit the ABI tag
        r"-(?P<cpver>cp\d+)-cp\d+-"
        r"(?P<platform>linux_x86_64|linux_aarch64)"
        r"\.whl$",
    )


# ---------------------------------------------------------------------------
# Generic parse_wheel factory
# ---------------------------------------------------------------------------

def build_parse_wheel(wheel_re: re.Pattern[str]):
    """
    Return a ``parse_wheel(entry)`` function driven by *wheel_re*.

    The returned callable matches *entry.name* against *wheel_re* and
    extracts fields by **named** group, so any custom regex that preserves
    the six required group names (``version``, ``cuda_digits``,
    ``torch_compat``, ``cxx11abi``, ``cpver``, ``platform``) will work
    transparently.

    Return value of the inner function
    ------------------------------------
    ``(key, cxx11abi, path_dict, leaf)`` on success, or ``None`` when the
    filename does not match the regex or the platform tag is unrecognised.

    ``key``
        Tuple used internally for deduplication; order mirrors *path_dict*.
    ``cxx11abi``
        ``"TRUE"`` or ``"FALSE"`` — the caller uses this to separate the
        TRUE-ABI wheel (primary) from the FALSE-ABI wheel (embedded as
        ``precx11abi``).
    ``path_dict``
        Dict of ``{cudaVersion, version, torchCompat, pyVer, os, arch}``
        used by the nix writer to build the nested attrset.
    ``leaf``
        ``{name, url, hash}`` dict from :meth:`~common.WheelEntry.to_leaf`.

    Parameters
    ----------
    wheel_re:
        Compiled regex with the six required named capture groups.
    """
    def parse_wheel(entry):
        m = wheel_re.match(entry.name)
        if m is None:
            return None

        gd           = m.groupdict()
        version      = gd["version"]
        cuda_digits  = gd["cuda_digits"]
        raw_compat   = gd["torch_compat"]
        # cxx11abi is optional in the regex; treat absent tag as new-ABI ("TRUE")
        cxx11abi     = gd.get("cxx11abi") or "TRUE"
        cpver        = gd["cpver"]
        platform     = gd["platform"]

        os_arch = parse_wheel_platform(platform)
        if os_arch is None:
            return None
        os_name, arch = os_arch

        pyver        = "py" + cpver[2:]           # "cp312" → "py312"
        cuda_version = "cu" + cuda_digits          # "12" → "cu12"
        torch_compat = normalize_torch_compat(raw_compat)

        key = (cuda_version, version, torch_compat, pyver, os_name, arch)
        path_dict = {
            "cudaVersion": cuda_version,
            "version":     version,
            "torchCompat": torch_compat,
            "pyVer":       pyver,
            "os":          os_name,
            "arch":        arch,
        }
        return key, cxx11abi, path_dict, entry.to_leaf()

    return parse_wheel
