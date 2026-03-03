#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 nix

"""
Generate torch-cu128/binary-hashes.nix from the PyTorch CUDA 12.8 wheel index.

Run from the project root:
  nix-shell torch-cu128/generate-hashes.py
"""

import os
import re
import sys

# Make the shared generate-binary-hashes modules importable.
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "generate-binary-hashes"))

from common import parse_wheel_platform, sort_version_key, sort_pyver_key_ft
from nix_writer import DimSpec, organize_wheels, write_binary_hashes_nix
from source_torch import TorchWheelSource

# ---------------------------------------------------------------------------
# Package-specific configuration
# ---------------------------------------------------------------------------

CUDA_VARIANT    = "cu128"
VERSION_FILTER  = r"2\.(?:9\.1|10\.0)"
OUTPUT_PATH     = os.path.join(os.path.dirname(os.path.abspath(__file__)), "binary-hashes.nix")

HEADER = """\
# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://download.pytorch.org/whl/cu128/torch/
# To regenerate: nix-shell torch-cu128/generate-hashes.py
#
# Structure: version -> pythonVersion -> os -> arch
#   pythonVersion: py310, py311, py312, py313, py313-freethreaded, py314, py314-freethreaded
#   os: linux, windows
#   arch: x86_64, aarch64"""

SCHEMA = [
    DimSpec("version", quoted=True, sort_key=sort_version_key),
    DimSpec("pyVer",   sort_key=sort_pyver_key_ft),
    DimSpec("os"),
    DimSpec("arch"),
]

DIMENSIONS = ["version", "pyVer", "os", "arch"]


# ---------------------------------------------------------------------------
# Wheel filename parser
# ---------------------------------------------------------------------------

def parse_wheel(entry) -> dict | None:
    """
    Map a TorchWheelSource entry to the path dict used for nesting.

    The entry.name has the form:
        torch-{version}-{abitag}-{abitag}-{platform}.whl
    e.g.
        torch-2.10.0-cp312-cp312-manylinux_2_28_x86_64.whl
        torch-2.10.0-cp313t-cp313t-manylinux_2_28_x86_64.whl   (free-threaded)
    """
    m = re.match(
        r"^torch-"
        r"(\d+\.\d+\.\d+)"         # group 1: version
        r"-(cp\d+t?)"              # group 2: abi tag, e.g. cp312 or cp313t
        r"-cp\d+t?"                # abi tag repeated (ignored)
        r"-([\w]+(?:_[\w]+)*)"     # group 3: platform tag
        r"\.whl$",
        entry.name,
    )
    if m is None:
        return None

    version, abitag, platform = m.groups()

    os_arch = parse_wheel_platform(platform)
    if os_arch is None:
        return None
    os_name, arch = os_arch

    is_ft  = abitag.endswith("t")
    pynum  = abitag[2:].rstrip("t")              # "cp312" → "312", "cp313t" → "313"
    py_key = f"py{pynum}-freethreaded" if is_ft else f"py{pynum}"

    return {"version": version, "pyVer": py_key, "os": os_name, "arch": arch}


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    print(f"Fetching PyTorch {CUDA_VARIANT} wheel index …")
    source = TorchWheelSource(CUDA_VARIANT, version_filter=VERSION_FILTER)

    entries = []
    skipped = 0
    for entry in source.fetch_wheels():
        path = parse_wheel(entry)
        if path is None:
            print(f"  SKIP  {entry.name}", file=sys.stderr)
            skipped += 1
            continue
        entries.append((path, entry.to_leaf()))

    if not entries:
        print("No wheels matched — check VERSION_FILTER.", file=sys.stderr)
        sys.exit(1)

    if skipped:
        print(f"  ({skipped} wheel(s) skipped due to unrecognised format)")

    organized = organize_wheels(entries, DIMENSIONS)
    write_binary_hashes_nix(OUTPUT_PATH, organized, SCHEMA, HEADER)


if __name__ == "__main__":
    main()
