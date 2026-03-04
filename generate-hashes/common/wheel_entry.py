from __future__ import annotations

import subprocess
import sys
from dataclasses import dataclass, field


def hex_to_nix_sri(hexhash: str) -> str:
    """
    Convert a lowercase hex SHA-256 string to Nix SRI format.

    Example:
        "dae63a47..." → "sha256-2uY6R1bJ..."

    Requires ``nix`` to be on PATH (satisfied by the nix-shell shebang in
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
