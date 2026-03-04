#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 nix

"""
Generate torch/binary-hashes/cu{variant}.nix from the PyTorch wheel index.

Run from the project root:
  nix-shell torch/generate-hashes.py                  # generate all variants
  nix-shell torch/generate-hashes.py -- --cuda cu126  # only CUDA 12.6
  nix-shell torch/generate-hashes.py -- --cuda cu128  # only CUDA 12.8
"""

import argparse
import os
import re
import sys

# Make the shared generate-hashes modules importable.
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "../..", "generate-hashes"))

from common import (
    deduplicate_post_versions,
    parse_wheel_platform,
    sort_version_key,
    sort_pyver_key_ft,
)
from nix_writer import DimSpec, organize_wheels, write_binary_hashes_nix
from source_torch import TorchWheelSource

# ---------------------------------------------------------------------------
# Per-variant configuration
# ---------------------------------------------------------------------------

VARIANTS = {
    "cu126": {
        "source_url": "https://download.pytorch.org/whl/cu126/torch/",
    },
    "cu128": {
        "source_url": "https://download.pytorch.org/whl/cu128/torch/",
    },
    "cu130": {
        "source_url": "https://download.pytorch.org/whl/cu130/torch/",
    },
}

# No pre-filter: fetch all versions from the index.  We filter for torch >= 2
# in Python and let TorchWheelSource use its default pattern (which now also
# matches .postN suffixes).  Post-release deduplication is handled below.
VERSION_FILTER = None

OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "binary-hashes")


def make_header(cuda_variant: str, source_url: str) -> str:
    return f"""\
# WARNING: Auto-generated file. Do not edit manually!
# Source:  {source_url}
# To regenerate: nix-shell torch/generate-hashes.py [-- --cuda {cuda_variant}]
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

def _torch_major_version(version: str) -> int:
    """Return the major version integer for a torch version string."""
    try:
        return int(version.split(".")[0])
    except (ValueError, IndexError):
        return 0


def parse_wheel(entry) -> dict | None:
    """
    Map a TorchWheelSource entry to the path dict used for nesting.

    The entry.name has the form:
        torch-{version}-{abitag}-{abitag}-{platform}.whl
    e.g.
        torch-2.10.0-cp312-cp312-manylinux_2_28_x86_64.whl
        torch-2.10.0-cp313t-cp313t-manylinux_2_28_x86_64.whl   (free-threaded)
        torch-2.9.1.post1-cp312-cp312-manylinux_2_28_x86_64.whl (post-release)
    """
    m = re.match(
        r"^torch-"
        r"(\d+\.\d+\.\d+(?:\.post\d+)?)"  # group 1: version (optional .postN)
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
# Per-variant generation
# ---------------------------------------------------------------------------

def generate_variant(cuda_variant: str) -> None:
    cfg = VARIANTS[cuda_variant]
    output_path = os.path.join(OUTPUT_DIR, f"{cuda_variant}.nix")

    print(f"Fetching PyTorch {cuda_variant} wheel index …")
    source = TorchWheelSource(cuda_variant, version_filter=VERSION_FILTER)

    entries = []
    skipped = 0
    for entry in source.fetch_wheels():
        path = parse_wheel(entry)
        if path is None:
            print(f"  SKIP  {entry.name}", file=sys.stderr)
            skipped += 1
            continue
        entries.append((path, entry.to_leaf()))

    if skipped:
        print(f"  ({skipped} wheel(s) skipped due to unrecognised format)")

    # Keep only torch >= 2 (drop any ancient 1.x wheels that may appear in
    # the index).
    before_filter = len(entries)
    entries = [
        (p, e) for p, e in entries
        if _torch_major_version(p["version"]) >= 2
    ]
    dropped = before_filter - len(entries)
    if dropped:
        print(f"  ({dropped} wheel(s) dropped for torch < 2)")

    # Deduplicate .postN releases: for each (base_version, pyVer, os, arch)
    # tuple keep only the wheel with the highest post number and relabel its
    # version key to the bare base version.
    entries = deduplicate_post_versions(entries)

    if not entries:
        print(f"No wheels matched for {cuda_variant} — index may be empty or unreachable.", file=sys.stderr)
        sys.exit(1)

    organized = organize_wheels(entries, DIMENSIONS)
    write_binary_hashes_nix(
        output_path,
        organized,
        SCHEMA,
        make_header(cuda_variant, cfg["source_url"]),
        wrap_in_func=False,
        prefix_attrs={"_cudaLabel": cuda_variant},
    )


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate torch binary-hashes .nix files from the PyTorch wheel index."
    )
    parser.add_argument(
        "--cuda",
        choices=list(VARIANTS.keys()),
        action="append",
        dest="cuda_variants",
        metavar="VARIANT",
        help=(
            "CUDA variant to generate (e.g. cu126, cu128). "
            "May be repeated. Defaults to all variants."
        ),
    )
    args = parser.parse_args()

    variants = args.cuda_variants or list(VARIANTS.keys())

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    for variant in variants:
        generate_variant(variant)


if __name__ == "__main__":
    main()
