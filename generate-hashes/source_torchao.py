"""
torchao wheel-index backend for binary-wheel hash generation.

Fetches wheel metadata from the PyTorch HTML wheel index at
https://download.pytorch.org/whl/<cuda_variant>/torchao/

The index page contains one <a> element per wheel, with the href encoding:
  - the wheel filename (including %2B-encoded + for the CUDA tag)
  - the SHA-256 hash of the file as a URL fragment (#sha256=<hex>)

No files are downloaded; hashes come directly from the index page.

torchao uses the Python Stable ABI (cp310-abi3): a single wheel serves all
Python 3.10+ interpreters.  There is no per-Python-version dimension.

Usage
-----
    from source_torchao import TorchaoWheelSource

    source = TorchaoWheelSource(cuda_variant="cu126")
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


class TorchaoWheelSource:
    """
    Yield :class:`~common.WheelEntry` objects parsed from the torchao wheel
    index for a specific CUDA variant.

    Parameters
    ----------
    cuda_variant:
        CUDA build tag used in the index path and wheel filenames,
        e.g. ``"cu126"`` or ``"cu128"``.
    min_version:
        Minimum version to include (default: ``"0.10.0"``).
        Older versions used per-Python-version wheels with a different
        naming convention and are not supported.
    verbose:
        Print a summary line to *stderr* after fetching (default: True).
    """

    def __init__(
        self,
        cuda_variant: str,
        min_version: str = "0.10.0",
        verbose: bool = True,
    ) -> None:
        self.cuda_variant = cuda_variant
        self.min_version = tuple(int(x) for x in min_version.split("."))
        self.verbose = verbose

        cv = re.escape(cuda_variant)
        # href format:
        #   /whl/cu126/torchao-0.16.0%2Bcu126-cp310-abi3-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl#sha256=<64 hex>
        self._href_re = re.compile(
            r"/whl/"
            + cv
            + r"/torchao-"
            + r"(\d+\.\d+\.\d+(?:\.post\d+)?)"  # group 1: version
            + r"%2B"
            + cv
            + r"-cp\d+t?"  # Python tag (ignored)
            + r"-abi3"  # stable ABI tag
            + r"-([\w]+(?:[._][\w]+)*)"  # group 2: platform tag
            + r"\.whl"
            + r"#sha256=([a-f0-9]{64})"  # group 3: hex SHA-256
        )

    def fetch_wheels(self) -> Iterator[WheelEntry]:
        """
        Fetch the torchao wheel index and yield one :class:`~common.WheelEntry`
        per matching wheel.
        """
        index_url = f"{_BASE_URL}/{self.cuda_variant}/torchao/"
        html = self._fetch_index(index_url)

        parser = _HrefParser(self._href_re, self.cuda_variant, self.min_version)
        parser.feed(html)

        if self.verbose:
            print(
                f"  {len(parser.entries)} matching wheel(s) found in {index_url}",
                file=sys.stderr,
            )

        yield from parser.entries

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
    from ``<a href="…">`` elements matching the torchao wheel pattern.
    """

    def __init__(
        self,
        pattern: re.Pattern,
        cuda_variant: str,
        min_version: tuple[int, ...],
    ) -> None:
        super().__init__()
        self._re = pattern
        self._cv = cuda_variant
        self._min_version = min_version
        self.entries: list[WheelEntry] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag != "a":
            return
        href = dict(attrs).get("href", "") or ""
        m = self._re.search(href)
        if m is None:
            return

        version, platform, hexhash = m.groups()

        # Filter by minimum version.
        try:
            ver_tuple = tuple(int(x) for x in version.split(".")[:3])
        except (ValueError, IndexError):
            return
        if ver_tuple < self._min_version:
            return

        # Wheel name without the CUDA build tag (used as the Nix store name).
        name = f"torchao-{version}-cp310-abi3-{platform}.whl"

        # Full URL taken directly from the href.
        url = f"https://download.pytorch.org{href}"

        self.entries.append(WheelEntry(name=name, url=url, hexhash=hexhash))
