"""
Triton wheel-index backend for binary-wheel hash generation.

Fetches wheel metadata from the PyTorch HTML wheel index at
https://download.pytorch.org/whl/triton/

The index page contains one <a> element per wheel, with the href encoding:
  - the wheel filename
  - the SHA-256 hash of the file as a URL fragment (#sha256=<hex>)

No files are downloaded; hashes come directly from the index page.

Usage
-----
    from source_triton import TritonWheelSource

    source = TritonWheelSource(min_major=3)
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


_INDEX_URL = "https://download.pytorch.org/whl/triton/"


class TritonWheelSource:
    """
    Yield :class:`~common.WheelEntry` objects parsed from the triton wheel index.

    Parameters
    ----------
    min_major:
        Minimum major version to include (default: 3, skips old 2.x wheels).
    verbose:
        Print a summary line to *stderr* after fetching (default: True).
    """

    def __init__(
        self,
        min_major: int = 3,
        verbose: bool = True,
    ) -> None:
        self.min_major = min_major
        self.verbose = verbose

        # Triton wheel href format examples:
        #   /whl/triton-3.6.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl#sha256=<64 hex>
        #   /whl/triton-3.0.0-1-cp310-cp310-manylinux2014_x86_64.manylinux_2_17_x86_64.whl#sha256=...
        # Some older versions have a build number: triton-3.0.0-1-cp310-...
        # Free-threaded: cp313t
        # Old CPython: cp37m (the 'm' ABI suffix)
        self._href_re = re.compile(
            r"/whl/"
            r"triton-"
            r"(\d+\.\d+\.\d+)"            # group 1: version
            r"(?:-\d+)?"                   # optional build number (e.g. -1)
            r"-(cp\d+[a-z]*)"             # group 2: ABI tag (cp310, cp313t, cp37m)
            r"-cp\d+[a-z]*"               # ABI tag repeated (ignored)
            r"-([\w]+(?:[._][\w]+)*)"       # group 3: platform tag (dots allowed)
            r"\.whl"
            r"#sha256=([a-f0-9]{64})"      # group 4: hex SHA-256
        )

    def fetch_wheels(self) -> Iterator[WheelEntry]:
        """
        Fetch the triton wheel index and yield one :class:`~common.WheelEntry`
        per matching wheel.
        """
        html = self._fetch_index()

        parser = _HrefParser(self._href_re, self.min_major)
        parser.feed(html)

        if self.verbose:
            print(
                f"  {len(parser.entries)} matching wheel(s) found in "
                f"{_INDEX_URL}",
                file=sys.stderr,
            )

        yield from parser.entries

    @staticmethod
    def _fetch_index() -> str:
        try:
            with urlopen(_INDEX_URL) as resp:
                return resp.read().decode("utf-8")
        except URLError as exc:
            print(f"Error fetching {_INDEX_URL}: {exc}", file=sys.stderr)
            sys.exit(1)


class _HrefParser(HTMLParser):
    """
    Minimal HTML parser that extracts :class:`~common.WheelEntry` objects
    from ``<a href="…">`` elements matching the triton wheel pattern.
    """

    def __init__(self, pattern: re.Pattern, min_major: int) -> None:
        super().__init__()
        self._re = pattern
        self._min_major = min_major
        self.entries: list[WheelEntry] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag != "a":
            return
        href = dict(attrs).get("href", "") or ""
        m = self._re.search(href)
        if m is None:
            return

        version, abitag, platform, hexhash = m.groups()

        # Filter by minimum major version.
        try:
            major = int(version.split(".")[0])
        except (ValueError, IndexError):
            return
        if major < self._min_major:
            return

        # Wheel name (used as the Nix store name).
        name = f"triton-{version}-{abitag}-{abitag}-{platform}.whl"

        # Full URL.
        url = f"https://download.pytorch.org{href}"

        self.entries.append(WheelEntry(name=name, url=url, hexhash=hexhash))
