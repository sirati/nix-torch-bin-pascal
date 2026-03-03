"""
Shared types and utilities for binary-wheel hash generation.

Imported by both source backends and package-specific entry points.
"""
from __future__ import annotations

import subprocess
import sys
from dataclasses import dataclass, field


# ---------------------------------------------------------------------------
# Core data type
# ---------------------------------------------------------------------------

@dataclass
class WheelEntry:
    """
    A pre-built Python wheel with its source URL and SHA-256 hash.

    Attributes:
        name:    Wheel filename as it should appear in the Nix store
                 (typically without the +cudaXY suffix, e.g.
                 "torch-2.10.0-cp312-cp312-manylinux_2_28_x86_64.whl").
        url:     Direct download URL already suitable for use in Nix fetchurl.
                 The '+' character must be percent-encoded as '%2B' because
                 Nix does not perform URL encoding itself.
        hexhash: Lowercase hex-encoded SHA-256 of the wheel file.
    """
    name: str
    url: str
    hexhash: str
    # Cached Nix SRI hash — populated lazily via to_leaf() / get_nixhash().
    _nixhash: str | None = field(default=None, repr=False, compare=False)

    def get_nixhash(self) -> str:
        """Return (and cache) the Nix SRI hash for this wheel."""
        if self._nixhash is None:
            self._nixhash = hex_to_nix_sri(self.hexhash)
        return self._nixhash

    def to_leaf(self) -> dict[str, str]:
        """
        Return the leaf attribute dict expected by the Nix writer.

        Computes (and caches) the Nix SRI hash on first call.
        Key order is preserved: name → url → hash.
        """
        return {
            "name": self.name,
            "url": self.url,
            "hash": self.get_nixhash(),
        }


# ---------------------------------------------------------------------------
# Hash utilities
# ---------------------------------------------------------------------------

def hex_to_nix_sri(hexhash: str) -> str:
    """
    Convert a lowercase hex SHA-256 string to Nix SRI format.

    Example:
        "dae63a47..." → "sha256-2uY6R1bJ..."

    Requires `nix` to be on PATH (satisfied by the nix-shell shebang in
    the package entry-point scripts).
    """
    try:
        result = subprocess.run(
            ["nix", "hash", "convert", "--hash-algo", "sha256", hexhash],
            capture_output=True,
            text=True,
            check=True,
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as exc:
        print(
            f"Error: `nix hash convert` failed for hash {hexhash!r}:\n{exc.stderr}",
            file=sys.stderr,
        )
        raise


# ---------------------------------------------------------------------------
# Platform helpers
# ---------------------------------------------------------------------------

def parse_wheel_platform(platform_tag: str) -> tuple[str, str] | None:
    """
    Map a wheel platform tag to a ``(os_name, arch)`` pair.

    Returns ``None`` for unrecognised tags so callers can skip or warn.

    Supported inputs
    ----------------
    manylinux_*_x86_64   → ("linux",   "x86_64")
    manylinux_*_aarch64  → ("linux",   "aarch64")
    win_amd64            → ("windows", "x86_64")
    linux_x86_64         → ("linux",   "x86_64")   # flash-attn bare style
    linux_aarch64        → ("linux",   "aarch64")
    """
    if platform_tag.startswith("manylinux"):
        if platform_tag.endswith("_x86_64"):
            return ("linux", "x86_64")
        if platform_tag.endswith("_aarch64"):
            return ("linux", "aarch64")
        # Generic fallback: take the last underscore-delimited component
        last = platform_tag.rsplit("_", 1)[-1]
        return ("linux", last) if last else None

    if platform_tag == "win_amd64":
        return ("windows", "x86_64")

    if platform_tag.startswith("linux_"):
        arch = platform_tag[len("linux_"):]
        return ("linux", arch) if arch else None

    return None


# ---------------------------------------------------------------------------
# Sort-key helpers (for use in DimSpec.sort_key)
# ---------------------------------------------------------------------------

def sort_version_key(v: str) -> tuple[int, ...]:
    """
    Numeric sort key for dotted version strings.

    Handles major.minor (e.g. "2.4", "2.10") and full triples
    (e.g. "2.9.1", "2.10.0") correctly — purely lexicographic comparison
    breaks for "2.10" vs "2.9".
    """
    try:
        return tuple(int(x) for x in v.split("."))
    except ValueError:
        return (0,)


def sort_pyver_key(pyver: str) -> int:
    """
    Numeric sort key for Python version attribute names.

    Examples:
        "py39"               → 39
        "py312"              → 312
        "py313-freethreaded" → 313   (free-threaded sorts after non-FT at same version
                                      because of the tuple used in the caller)
    """
    base = pyver[2:].replace("-freethreaded", "")
    try:
        return int(base)
    except ValueError:
        return 0


def sort_pyver_key_ft(pyver: str) -> tuple[int, int]:
    """
    Like sort_pyver_key but places free-threaded variants after the normal
    variant of the same Python version.

    Examples:
        "py313"              → (313, 0)
        "py313-freethreaded" → (313, 1)
    """
    is_ft = int(pyver.endswith("-freethreaded"))
    return (sort_pyver_key(pyver), is_ft)
