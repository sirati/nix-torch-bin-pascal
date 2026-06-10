"""
apache-tvm-ffi generate-hashes configuration module.

Imported by the shared entry point ``generate-hashes/main.py``.
Do NOT add a main() here.

apache-tvm-ffi wheels are distributed via PyPI (originType "pypi").
cp312-abi3 wheels cover Python 3.12+; cp310/cp311 have dedicated wheels.
The abi3 wheels are expanded to explicit per-pyVer entries at generation
time so overlay-bin.nix can do a direct pyVer lookup.

Invocation (from project root):
  nix run .#default.apache-tvm-ffi.gen-hashes
  nix run .#default.apache-tvm-ffi.gen-hashes -- --tag 0.1.12

Options:
  --tag VERSION   Process only this version (always overwrites its file).
"""

import argparse
import os
import re
import sys

_GENERATE_HASHES_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "../..", "generate-hashes"
)
if _GENERATE_HASHES_DIR not in sys.path:
    sys.path.insert(0, _GENERATE_HASHES_DIR)

from common import sort_pyver_key_ft
from nix_writer import DimSpec
from nix_writer.write_nix import write_binary_hashes_nix
from source_pypi import collect_pyver_wheels, fetch_pypi_versions

# ORIGIN_TYPE ("pypi") is injected by makeGenHashesApp from the HLD.

_HERE = os.path.dirname(os.path.abspath(__file__))
OUTPUT_DIR = os.path.join(_HERE, "binary-hashes")

PROJECT = "apache-tvm-ffi"

# quack-kernels requires >=0.1.6; older releases are irrelevant.
MIN_VERSION = "0.1.6"

# CPython 3.x minors that abi3 wheels are expanded to.  Extend when the repo
# gains newer Python versions.
ABI3_EXPAND_MINORS = [10, 11, 12, 13, 14]

SCHEMA = [
    DimSpec("pyVer", sort_key=sort_pyver_key_ft),
    DimSpec("os"),
    DimSpec("arch"),
]

HEADER_TEMPLATE = """\
# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://pypi.org/project/apache-tvm-ffi/
# To regenerate: nix run .#default.apache-tvm-ffi.gen-hashes [-- --tag {version}]
#
# apache-tvm-ffi {version} binary-wheel hashes.
# Wheels are CUDA- and torch-agnostic (pure CPU library).
# cp312-abi3 wheels are expanded to explicit py312/py313/… entries.
#
# Structure: pythonVersion -> os -> arch"""


def run() -> None:
    p = argparse.ArgumentParser(
        description="Generate binary-hashes for apache-tvm-ffi (PyPI wheels)."
    )
    p.add_argument("--tag", default=None, metavar="VERSION",
                   help="Process only this version (always overwrites).")
    args = p.parse_args()

    os.makedirs(OUTPUT_DIR, exist_ok=True)

    if args.tag:
        versions = [args.tag.lstrip("v")]
    else:
        versions = fetch_pypi_versions(PROJECT, min_version=MIN_VERSION)
        print(f"{len(versions)} {PROJECT} version(s) >= {MIN_VERSION}: "
              + ", ".join(versions))

    for version in versions:
        path = os.path.join(OUTPUT_DIR, f"v{version}.nix")
        if not args.tag and os.path.isfile(path):
            print(f"  binary-hashes/v{version}.nix already exists — skipping.",
                  file=sys.stderr)
            continue
        if not re.match(r"^\d+\.\d+\.\d+$", version):
            print(f"  {version}: not a plain x.y.z version — skipping.",
                  file=sys.stderr)
            continue

        print(f"{PROJECT} {version}: fetching wheel metadata …")
        organized = collect_pyver_wheels(
            PROJECT, version, expand_abi3_to=ABI3_EXPAND_MINORS
        )
        if not organized:
            print(f"  no Linux wheels for {version} — skipping.", file=sys.stderr)
            continue
        write_binary_hashes_nix(
            path,
            organized,
            SCHEMA,
            HEADER_TEMPLATE.format(version=version),
            wrap_in_func=False,
            prefix_attrs={"_version": version},
        )
