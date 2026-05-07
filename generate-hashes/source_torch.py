"""
PyTorch wheel-index backend for binary-wheel hash generation.

Fetches wheel metadata from the PyTorch HTML wheel index at
https://download.pytorch.org/whl/<cuda_variant>/torch/

The index page contains one <a> element per wheel, with the href encoding:
  - the wheel filename (including %2B-encoded + for the CUDA tag)
  - the SHA-256 hash of the file as a URL fragment (#sha256=<hex>)

No files are downloaded; hashes come directly from the index page.

Usage
-----
    from source_torch import TorchWheelSource

    source = TorchWheelSource(
        cuda_variant="cu126",
        version_filter=r"2\\.(?:9\\.1|10\\.0)",
    )
    for entry in source.fetch_wheels():
        print(entry.name, entry.hexhash)
"""
from __future__ import annotations

import re
import sys
from html.parser import HTMLParser
from typing import Iterator
from urllib.error import URLError
from urllib.request import urlopen

from common import WheelEntry


_BASE_URL = "https://download.pytorch.org/whl"


class TorchWheelSource:
    """
    Yield :class:`~common.WheelEntry` objects parsed from the PyTorch wheel index.

    Parameters
    ----------
    cuda_variant:
        CUDA build tag used in the index path and wheel filenames,
        e.g. ``"cu126"`` or ``"cu128"``.
    version_filter:
        Optional regex pattern (as a raw string) matched against the
        PyTorch version component of each wheel filename.  Only wheels
        whose version matches are yielded.  When ``None`` every version
        present in the index is included.

        Example: ``r"2\\.(?:9\\.1|10\\.0)"`` restricts to 2.9.1 and 2.10.0.
    verbose:
        Print a summary line to *stderr* after fetching (default: True).
    """

    def __init__(
        self,
        cuda_variant: str,
        version_filter: str | None = None,
        verbose: bool = True,
    ) -> None:
        self.cuda_variant = cuda_variant
        self.version_filter = version_filter
        self.verbose = verbose

        # Build the href-matching regex once.
        #
        # href format (from the PyTorch index HTML):
        #   /whl/cu126/torch-2.10.0%2Bcu126-cp312-cp312-manylinux_2_28_x86_64.whl#sha256=<64 hex chars>
        #
        # For free-threaded CPython the ABI tag ends in 't', e.g. cp313t.
        # The Python tag (first) may not carry the 't'; only the ABI tag
        # (second group) reliably identifies the free-threaded build.
        # We therefore capture the full ABI tag and reconstruct the name
        # using it for both positions (matching what PyPI and pip expect).
        #
        ver_pat = version_filter or r"\d+\.\d+\.\d+(?:\.post\d+)?"
        cv = re.escape(cuda_variant)
        self._href_re = re.compile(
            r"/whl/"
            + cv
            + r"/torch-"
            + r"(" + ver_pat + r")"    # group 1: torch version, e.g. "2.10.0"
            + r"%2B"
            + cv
            + r"-cp\d+t?-"             # Python tag (ignored; reconstructed below)
            + r"(cp\d+t?)"             # group 2: ABI tag, e.g. "cp312" or "cp313t"
            + r"-([\w]+(?:_[\w]+)*)"   # group 3: platform tag, e.g. "manylinux_2_28_x86_64"
            + r"\.whl"
            + r"#sha256=([a-f0-9]{64})"  # group 4: hex SHA-256
        )

    # ------------------------------------------------------------------
    # Public interface
    # ------------------------------------------------------------------

    def fetch_wheels(self) -> Iterator[WheelEntry]:
        """
        Fetch the PyTorch wheel index and yield one :class:`~common.WheelEntry`
        per matching wheel.

        The ``url`` on each entry is the full download URL with ``%2B``
        already present (taken verbatim from the index href) and includes
        the ``#sha256=…`` fragment.  Nix ignores the fragment when
        downloading but it is preserved for human reference.

        The ``name`` field is the plain wheel filename without the CUDA
        build tag, suitable for use as the Nix store path name:
        ``torch-{version}-{abitag}-{abitag}-{platform}.whl``
        """
        index_url = f"{_BASE_URL}/{self.cuda_variant}/torch/"
        html = self._fetch_index(index_url)

        parser = _HrefParser(self._href_re, self.cuda_variant)
        parser.feed(html)

        if self.verbose:
            print(
                f"  {len(parser.entries)} matching wheel(s) found in "
                f"{index_url}",
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
    Minimal HTML parser that extracts :class:`~common.WheelEntry` objects
    from ``<a href="…">`` elements matching the torch-wheel pattern.
    """

    def __init__(self, pattern: re.Pattern, cuda_variant: str) -> None:
        super().__init__()
        self._re = pattern
        self._cv = cuda_variant
        self.entries: list[WheelEntry] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag != "a":
            return
        href = dict(attrs).get("href", "") or ""
        m = self._re.search(href)
        if m is None:
            return

        version, abitag, platform, hexhash = m.groups()

        # Wheel name without the CUDA build tag (used as the Nix store name).
        name = f"torch-{version}-{abitag}-{abitag}-{platform}.whl"

        # Full URL taken directly from the href so %2B and the sha256
        # fragment are preserved exactly.
        url = f"https://download.pytorch.org{href}"

        self.entries.append(WheelEntry(name=name, url=url, hexhash=hexhash))
