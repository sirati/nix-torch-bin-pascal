"""
Shared download.pytorch.org wheel-index backend for binary-wheel hash
generation.

Every package distributed through the PyTorch wheel index
(https://download.pytorch.org/whl/<cuda_variant>/<package>/) has the same
index structure: one ``<a href="…">`` per wheel, the href encoding the wheel
filename (with ``%2B``-encoded ``+`` for the CUDA tag) and the SHA-256 as a
``#sha256=<hex>`` fragment.  No files are downloaded — hashes come straight
from the index page.

This module factors out everything common to those indexes.  Each package's
``pkgs/<pkg>/generate-hashes.py`` constructs :class:`PyTorchOrgWheelSource`
directly, passing the package name plus the handful of knobs that actually
differ:

  - ``stable_abi``     torchao ships a single ``cp310-abi3`` wheel per platform;
                       torch / torchvision / torchaudio ship per-Python wheels.
  - ``version_filter`` optional regex matched against the version component.
  - ``min_version``    optional post-parse semantic-version floor (torchao).

(triton is deliberately NOT built on this backend: its wheels are
CUDA-agnostic and served from a single ``/whl/triton/`` index with a different
filename shape — see ``source_triton``.)
"""
from __future__ import annotations

import re
import sys
from html.parser import HTMLParser
from typing import Callable, Iterator
from urllib.error import URLError
from urllib.request import urlopen

from common import WheelEntry


_BASE_URL = "https://download.pytorch.org/whl"
# Canonical host used to rebuild the download URL.  Upstream now serves
# absolute hrefs pointing at a different host (download-r2.pytorch.org); we
# always rebuild from the matched ``/whl/…#sha256=…`` substring so the stored
# URL stays stable on this host.
_CANONICAL_HOST = "https://download.pytorch.org"

# Platform tag: one or more word groups joined by ``_`` or ``.``, e.g.
#   manylinux_2_28_x86_64
#   manylinux_2_24_x86_64.manylinux_2_28_x86_64
_PLATFORM_PAT = r"[\w]+(?:[._][\w]+)*"


class PyTorchOrgWheelSource:
    """
    Yield :class:`~common.WheelEntry` objects parsed from a
    download.pytorch.org wheel index for one *package* + *cuda_variant*.

    Parameters
    ----------
    package_name:
        Index directory and wheel-name prefix, e.g. ``"torch"`` or
        ``"torchvision"``.
    cuda_variant:
        CUDA build tag used in the index path and wheel filenames,
        e.g. ``"cu126"`` or ``"cu128"``.
    stable_abi:
        When True the package ships a single Python Stable ABI wheel
        (``cp310-abi3``) per platform (torchao); the reconstructed name uses
        the fixed ``cp310-abi3`` tag and there is no per-Python dimension.
        When False (default) the package ships per-Python wheels and the ABI
        tag captured from the filename is reused for both the Python and ABI
        positions of the reconstructed name (so free-threaded ``cp313t``
        builds round-trip correctly).
    version_filter:
        Optional regex (raw string) matched against the version component of
        each wheel filename.  When None every version in the index is included.
    min_version:
        Optional ``"X.Y.Z"`` floor; wheels older than this are dropped after
        parsing.  Used by torchao to exclude legacy per-Python wheels.
    verbose:
        Print a summary line to *stderr* after fetching (default: True).
    """

    def __init__(
        self,
        package_name: str,
        cuda_variant: str,
        *,
        stable_abi: bool = False,
        version_filter: str | None = None,
        min_version: str | None = None,
        verbose: bool = True,
    ) -> None:
        self.package_name = package_name
        self.cuda_variant = cuda_variant
        self.stable_abi = stable_abi
        self.version_filter = version_filter
        self.min_version = (
            tuple(int(x) for x in min_version.split(".")) if min_version else None
        )
        self.verbose = verbose
        self._href_re = self._build_href_re()

    # ------------------------------------------------------------------
    # Package-shape-specific bits (regex + name construction)
    # ------------------------------------------------------------------

    def _build_href_re(self) -> re.Pattern:
        cv = re.escape(self.cuda_variant)
        ver_pat = self.version_filter or r"\d+\.\d+\.\d+(?:\.post\d+)?"
        # The literal "/<package>-" (full name + hyphen) anchors the match to
        # the exact package, so e.g. the torchaudio index's stray bare
        # "torch-" wheels are not matched.  The required "/whl/<cv>/…%2B<cv>"
        # anchor also excludes legacy non-CUDA CPU wheels served from a bare
        # "/whl/<package>-" path.
        if self.stable_abi:
            #   /whl/<cv>/<pkg>-<ver>%2B<cv>-cp310-abi3-<platform>.whl#sha256=<hex>
            abi_segment = r"-cp\d+t?-abi3-"
        else:
            #   /whl/<cv>/<pkg>-<ver>%2B<cv>-cp312-cp312-<platform>.whl#sha256=<hex>
            # Capture the ABI tag (group 2); the Python tag is ignored and
            # reconstructed from it.
            abi_segment = r"-cp\d+t?-(cp\d+t?)-"
        return re.compile(
            r"/whl/" + cv + r"/" + re.escape(self.package_name) + r"-"
            + r"(" + ver_pat + r")"          # group 1: version
            + r"%2B" + cv
            + abi_segment                    # (group 2: ABI tag — per-Python only)
            + r"(" + _PLATFORM_PAT + r")"    # platform group
            + r"\.whl"
            + r"#sha256=([a-f0-9]{64})"      # last group: hex SHA-256
        )

    def _make_entry(self, m: re.Match) -> WheelEntry | None:
        if self.stable_abi:
            version, platform, hexhash = m.groups()
            abitag = None
        else:
            version, abitag, platform, hexhash = m.groups()

        if self.min_version is not None:
            try:
                ver_tuple = tuple(int(x) for x in version.split(".")[:3])
            except (ValueError, IndexError):
                return None
            if ver_tuple < self.min_version:
                return None

        # Wheel name without the CUDA build tag (used as the Nix store name).
        if self.stable_abi:
            name = f"{self.package_name}-{version}-cp310-abi3-{platform}.whl"
        else:
            name = f"{self.package_name}-{version}-{abitag}-{abitag}-{platform}.whl"

        # Build the URL from the matched /whl/...#sha256=... substring rather
        # than the raw href, so the canonical host is used regardless of which
        # host upstream advertises (keeps %2B and the sha256 fragment intact).
        url = f"{_CANONICAL_HOST}{m.group(0)}"
        return WheelEntry(name=name, url=url, hexhash=hexhash)

    # ------------------------------------------------------------------
    # Public interface
    # ------------------------------------------------------------------

    def fetch_wheels(self) -> Iterator[WheelEntry]:
        """
        Fetch the wheel index and yield one :class:`~common.WheelEntry` per
        matching wheel.
        """
        index_url = f"{_BASE_URL}/{self.cuda_variant}/{self.package_name}/"
        html = self._fetch_index(index_url)

        parser = _HrefParser(self._href_re, self._make_entry)
        parser.feed(html)

        if self.verbose:
            print(
                f"  {len(parser.entries)} matching wheel(s) found in {index_url}",
                file=sys.stderr,
            )

        yield from parser.entries

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    @staticmethod
    def _fetch_index(url: str) -> str:
        try:
            with urlopen(url) as resp:
                return resp.read().decode("utf-8")
        except URLError as exc:
            print(f"Error fetching {url}: {exc}", file=sys.stderr)
            sys.exit(1)


class _HrefParser(HTMLParser):
    """
    Minimal HTML parser that extracts :class:`~common.WheelEntry` objects from
    ``<a href="…">`` elements matching *pattern*, building each entry via the
    supplied *make_entry* callback (which may return None to skip).
    """

    def __init__(
        self,
        pattern: re.Pattern,
        make_entry: Callable[[re.Match], WheelEntry | None],
    ) -> None:
        super().__init__()
        self._re = pattern
        self._make_entry = make_entry
        self.entries: list[WheelEntry] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag != "a":
            return
        href = dict(attrs).get("href", "") or ""
        m = self._re.search(href)
        if m is None:
            return
        entry = self._make_entry(m)
        if entry is not None:
            self.entries.append(entry)
