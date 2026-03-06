"""
triton generate-hashes configuration module.

Imported by the shared entry point ``generate-hashes/main.py``.
Do NOT add a main() here.

Invocation (from project root):
  nix run .#default.triton.gen-hashes

Options: none — all triton variants are always regenerated together.
"""

import os
import re
import sys

# When loaded as a module by main.py, generate-hashes/ is already on sys.path.
# When run directly for debugging, add it manually.
_GENERATE_HASHES_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../..", "generate-hashes")
if _GENERATE_HASHES_DIR not in sys.path:
    sys.path.insert(0, _GENERATE_HASHES_DIR)

from common import (
    deduplicate_post_versions,
    parse_wheel_platform,
    sort_version_key,
    sort_pyver_key_ft,
)
from nix_writer import DimSpec, organize_wheels
from nix_writer.per_version import write_binary_hashes_per_version
from source_triton import TritonWheelSource

# ORIGIN_TYPE ("torch-website") is injected by makeGenHashesApp from the HLD.

# ---------------------------------------------------------------------------
# Output configuration
# ---------------------------------------------------------------------------

OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "binary-hashes")

# Header template for each per-version file.  {version} is substituted by
# write_binary_hashes_per_version when writing each file.
HEADER_TEMPLATE = """\
# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://download.pytorch.org/whl/triton/
# To regenerate: nix run .#default.triton.gen-hashes
#
# Triton {version} binary-wheel hashes.
# Triton wheels are CUDA-agnostic (same wheel for all CUDA versions).
# _version records the triton version this file was generated for.
#
# Structure: pythonVersion -> os -> arch
#   pythonVersion: py310, py311, py312, py313, py313-freethreaded
#   os: linux
#   arch: x86_64"""

# Schema for the content *inside* each per-version file (no version level).
SCHEMA = [
    DimSpec("pyVer", sort_key=sort_pyver_key_ft),
    DimSpec("os"),
    DimSpec("arch"),
]

# Full dimension list used by organize_wheels; version is the outermost split key.
DIMENSIONS = ["version", "pyVer", "os", "arch"]

# DimSpec for the version level — used only for sort ordering of output files.
VERSION_SPEC = DimSpec("version", quoted=True, sort_key=sort_version_key)


# ---------------------------------------------------------------------------
# Wheel filename parser
# ---------------------------------------------------------------------------

def _triton_major_version(version: str) -> int:
    try:
        return int(version.split(".")[0])
    except (ValueError, IndexError):
        return 0


def _parse_wheel(entry) -> dict | None:
    """
    Map a TritonWheelSource entry to the path dict used for nesting.

    The entry.name has the form:
        triton-{version}-{abitag}-{abitag}-{platform}.whl
    e.g.
        triton-3.6.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl
        triton-3.6.0-cp313t-cp313t-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl
    """
    m = re.match(
        r"^triton-"
        r"(\d+\.\d+\.\d+(?:\.post\d+)?)"  # group 1: version
        r"-(cp\d+t?)"                      # group 2: abi tag
        r"-cp\d+t?"                        # abi tag repeated (ignored)
        r"-([\w]+(?:\.[\w]+)*)"            # group 3: platform tag (may contain dots)
        r"\.whl$",
        entry.name,
    )
    if m is None:
        return None

    version, abitag, platform = m.groups()

    # Platform tag may be compound like "manylinux_2_27_x86_64.manylinux_2_28_x86_64".
    # Take the first parseable segment.
    os_arch = None
    for p in platform.split("."):
        result = parse_wheel_platform(p)
        if result is not None:
            os_arch = result
            break
    if os_arch is None:
        return None
    os_name, arch = os_arch

    is_ft  = abitag.endswith("t")
    pynum  = abitag[2:].rstrip("t")
    py_key = f"py{pynum}-freethreaded" if is_ft else f"py{pynum}"

    return {"version": version, "pyVer": py_key, "os": os_name, "arch": arch}


# ---------------------------------------------------------------------------
# Generation
# ---------------------------------------------------------------------------

def _generate() -> None:
    print("Fetching triton wheel index …")
    source = TritonWheelSource(min_major=3)

    entries = []
    skipped = 0
    for entry in source.fetch_wheels():
        path = _parse_wheel(entry)
        if path is None:
            print(f"  SKIP  {entry.name}", file=sys.stderr)
            skipped += 1
            continue
        entries.append((path, entry.to_leaf()))

    if skipped:
        print(f"  ({skipped} wheel(s) skipped due to unrecognised format)")

    before_filter = len(entries)
    entries = [
        (p, e) for p, e in entries
        if _triton_major_version(p["version"]) >= 3
    ]
    dropped = before_filter - len(entries)
    if dropped:
        print(f"  ({dropped} wheel(s) dropped for triton < 3)")

    entries = deduplicate_post_versions(entries)

    if not entries:
        print("No wheels matched — index may be empty or unreachable.", file=sys.stderr)
        sys.exit(1)

    organized = organize_wheels(entries, DIMENSIONS)

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    write_binary_hashes_per_version(
        OUTPUT_DIR,
        organized,
        SCHEMA,
        HEADER_TEMPLATE,
        VERSION_SPEC,
        prefix_attrs_fn=lambda version: {"_version": version},
        skip_existing=True,
    )


# ---------------------------------------------------------------------------
# run() — called by the shared main for torch-website packages
# ---------------------------------------------------------------------------

def run() -> None:
    """Entry point called by ``generate-hashes/main.py`` for torch-website packages."""
    _generate()
