#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 nix

"""
Generate causal-conv1d/binary-hashes.nix from a GitHub release tag.

Run from the project root:
  nix-shell causal-conv1d/generate-hashes.py [-- --tag v1.6.0]

Options:
  --tag TAG      GitHub release tag to fetch (default: v1.6.0)
  --token TOKEN  GitHub API token; also read from $GITHUB_TOKEN
"""

import argparse
import os
import re
import sys

# Make the shared generate-binary-hashes modules importable.
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "generate-binary-hashes"))

from common import parse_wheel_platform, sort_version_key, sort_pyver_key
from nix_writer import DimSpec, organize_wheels, write_binary_hashes_nix
from source_github import GithubReleasesSource

# ---------------------------------------------------------------------------
# Package-specific configuration
# ---------------------------------------------------------------------------

REPO        = "Dao-AILab/causal-conv1d"
DEFAULT_TAG = "v1.6.0"
OUTPUT_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "binary-hashes.nix")

HEADER = """\
# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/Dao-AILab/causal-conv1d/releases
# To regenerate: nix-shell causal-conv1d/generate-hashes.py [-- --tag v1.6.0]
#
# Structure: cudaVersion -> version -> torchCompat -> pyVer -> os -> arch
#
#   cudaVersion: CUDA major[minor] the wheel was compiled against (e.g. cu11, cu12, cu13).
#   version:     causal-conv1d release version.
#   torchCompat: torch major.minor the wheel was compiled against.
#   pyVer:       py39, py310, …  (CPython only; no free-threaded variants).
#   os:          linux  (only Linux wheels provided as pre-built binaries)
#   arch:        x86_64, aarch64
#
# Each leaf node contains the TRUE cxx11abi (new ABI) wheel data:
#   { name, url, hash }
# When a FALSE cxx11abi (pre-cxx11 ABI) wheel also exists it is embedded as:
#   { name, url, hash, precx11abi = { name, url, hash }; }"""

SCHEMA = [
    DimSpec("cudaVersion"),
    DimSpec("version",     quoted=True, sort_key=sort_version_key),
    DimSpec("torchCompat", quoted=True, sort_key=sort_version_key,
            comment_fn=lambda k: f"── torch {k} {'─' * max(1, 60 - len(k))}"),
    DimSpec("pyVer",       sort_key=sort_pyver_key),
    DimSpec("os"),
    DimSpec("arch"),
]

DIMENSIONS = ["cudaVersion", "version", "torchCompat", "pyVer", "os", "arch"]

# Matches causal_conv1d wheel filenames released on GitHub, e.g.:
#   causal_conv1d-1.6.0+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl
#   causal_conv1d-1.6.0+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl
#   causal_conv1d-1.6.0+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl
_WHEEL_RE = re.compile(
    r"^causal_conv1d-"
    r"(\d+\.\d+\.\d+)"                       # group 1: package version
    r"\+cu(\d+)torch"                         # group 2: cuda version digits, e.g. "12" or "13"
    r"(\d+\.\d+)"                             # group 3: torch compat, e.g. "2.7" or "25.11"
    r"cxx11abi(TRUE|FALSE)"                   # group 4: CXX11 ABI flag
    r"-(cp\d+)-cp\d+-"                        # group 5: CPython tag, e.g. "cp312"
    r"(linux_x86_64|linux_aarch64)"           # group 6: platform tag
    r"\.whl$"
)


# ---------------------------------------------------------------------------
# Wheel filename parser
# ---------------------------------------------------------------------------

def parse_wheel(entry):
    """
    Parse a GithubReleasesSource entry into its classification fields.

    Returns (key, cxx11abi, path_dict, leaf_data) where:
      - key       is the (cudaVersion, version, torchCompat, pyVer, os, arch) tuple
      - cxx11abi  is "TRUE" or "FALSE"
      - path_dict maps DIMENSIONS to their values (cxx11abi excluded)
      - leaf_data is the {name, url, hash} dict

    Returns None for assets that don't match the expected naming convention.
    """
    m = _WHEEL_RE.match(entry.name)
    if m is None:
        return None

    version, cuda_digits, torch_compat, cxx11abi, cpver, platform = m.groups()

    os_arch = parse_wheel_platform(platform)
    if os_arch is None:
        return None
    os_name, arch = os_arch

    pyver        = "py" + cpver[2:]       # "cp312" → "py312"
    cuda_version = "cu" + cuda_digits     # "12" → "cu12", "13" → "cu13"

    key = (cuda_version, version, torch_compat, pyver, os_name, arch)

    path_dict = {
        "cudaVersion": cuda_version,
        "version":     version,
        "torchCompat": torch_compat,
        "pyVer":       pyver,
        "os":          os_name,
        "arch":        arch,
    }

    return key, cxx11abi, path_dict, entry.to_leaf()


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate causal-conv1d-bin binary-hashes.nix from a GitHub release tag."
    )
    parser.add_argument(
        "--tag",
        default=DEFAULT_TAG,
        help=f"GitHub release tag to fetch (default: {DEFAULT_TAG})",
    )
    parser.add_argument(
        "--token",
        default=os.environ.get("GITHUB_TOKEN"),
        help="GitHub personal access token (also read from $GITHUB_TOKEN). "
             "Optional but raises the API rate limit from 60 to 5000 req/h.",
    )
    args = parser.parse_args()

    print(f"Fetching release assets for {REPO} @ {args.tag} …")
    source = GithubReleasesSource(
        repo=REPO,
        tag=args.tag,
        token=args.token,
    )

    # Collect TRUE (new ABI) and FALSE (pre-cxx11 ABI) wheels separately.
    true_wheels  = {}   # key → (path_dict, leaf_data)
    false_wheels = {}   # key → leaf_data

    skipped = 0
    for entry in source.fetch_wheels():
        parsed = parse_wheel(entry)
        if parsed is None:
            print(f"  SKIP  {entry.name}", file=sys.stderr)
            skipped += 1
            continue

        key, cxx11abi, path_dict, leaf = parsed

        if cxx11abi == "TRUE":
            true_wheels[key] = (path_dict, leaf)
        else:
            false_wheels[key] = leaf

    if not true_wheels:
        print("No TRUE-ABI wheels matched — check the tag name.", file=sys.stderr)
        sys.exit(1)

    if skipped:
        print(f"  ({skipped} asset(s) skipped due to unrecognised pattern)")

    # Merge FALSE wheels into the corresponding TRUE wheel leaf as precx11abi.
    entries = []
    for key, (path_dict, leaf) in true_wheels.items():
        if key in false_wheels:
            leaf = dict(leaf)                        # shallow copy before mutating
            leaf["precx11abi"] = false_wheels[key]
        entries.append((path_dict, leaf))

    # Warn about orphan FALSE-only wheels (no matching TRUE wheel).
    for key in false_wheels:
        if key not in true_wheels:
            cuda_ver, ver, torch_compat, pyver, os_name, arch = key
            print(
                f"  WARNING: no TRUE-ABI wheel found for "
                f"{ver}+{cuda_ver} torch{torch_compat} {pyver} {os_name}/{arch}; "
                f"skipping FALSE-only wheel.",
                file=sys.stderr,
            )

    organized = organize_wheels(entries, DIMENSIONS)
    write_binary_hashes_nix(
        OUTPUT_PATH,
        organized,
        SCHEMA,
        HEADER,
        top_key_var="cudaVersion",
    )


if __name__ == "__main__":
    main()
