#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 nix

"""
Generate causal-conv1d binary-hashes and source-hashes from GitHub releases.

By default fetches ALL releases and produces:
  - binary-hashes/v{version}.nix  (one per version, from wheel assets)
  - source-hashes/v{version}.nix  (one per version, from GitHub archive)

Source-hash files that already exist on disk are skipped (no re-download).

Run from the project root or from within pkgs/causal-conv1d/:
  nix-shell pkgs/causal-conv1d/generate-hashes.py
  nix-shell pkgs/causal-conv1d/generate-hashes.py -- --tag v1.6.0
  nix-shell pkgs/causal-conv1d/generate-hashes.py -- --skip-source
  nix-shell pkgs/causal-conv1d/generate-hashes.py -- --source-only

Options:
  --tag TAG        Process only this specific release tag instead of all releases.
  --skip-source    Skip source-hash generation (binary hashes only).
  --source-only    Only generate source hashes; skip binary-wheel hash generation.
  --prereleases    Include pre-releases when fetching all releases.
  --token TOKEN    GitHub API token (also read from $GITHUB_TOKEN).
"""

import argparse
import os
import re
import sys

# Make the shared generate-hashes modules importable.
_GENERATE_HASHES_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../..", "generate-hashes")
sys.path.insert(0, _GENERATE_HASHES_DIR)

from common import (
    normalize_torch_compat,
    parse_wheel_platform,
    sort_pyver_key,
    sort_torch_compat_key,
    sort_version_key,
)
from nix_writer import DimSpec
from github_release_runner import (
    add_common_args,
    run_all_hashes,
    strip_nix_shell_dashdash,
)
from pkg_helpers import make_torch_binary_header_template, pkg_hash_dirs

# ---------------------------------------------------------------------------
# Package-specific configuration
# ---------------------------------------------------------------------------

GITHUB_REPO = "Dao-AILab/causal-conv1d"

_HERE             = os.path.dirname(os.path.abspath(__file__))
BINARY_HASHES_DIR, SOURCE_HASHES_DIR = pkg_hash_dirs(_HERE)

BINARY_HEADER_TEMPLATE = make_torch_binary_header_template(
    github_repo=GITHUB_REPO,
    pkg_path="pkgs/causal-conv1d",
    has_source_hashes=True,
)

VERSION_SPEC = DimSpec("version", quoted=True, sort_key=sort_version_key)

SCHEMA = [
    DimSpec("cudaVersion"),
    DimSpec("torchCompat", quoted=True, sort_key=sort_torch_compat_key,
            comment_fn=lambda k: f"── torch {k} {'─' * max(1, 60 - len(k))}"),
    DimSpec("pyVer",       sort_key=sort_pyver_key),
    DimSpec("os"),
    DimSpec("arch"),
]

DIMENSIONS = ["version", "cudaVersion", "torchCompat", "pyVer", "os", "arch"]

# Matches causal_conv1d wheel filenames released on GitHub, e.g.:
#   causal_conv1d-1.6.0+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl
#   causal_conv1d-1.6.0+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl
#   causal_conv1d-1.6.0+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl
_WHEEL_RE = re.compile(
    r"^causal_conv1d-"
    r"(\d+\.\d+\.\d+(?:\.post\d+)?)"          # group 1: package version (incl. post)
    r"\+cu(\d+)torch"                           # group 2: cuda version digits
    r"(\d+\.\d+)"                               # group 3: torch compat
    r"cxx11abi(TRUE|FALSE)"                     # group 4: CXX11 ABI flag
    r"-(cp\d+)-cp\d+-"                          # group 5: CPython tag
    r"(linux_x86_64|linux_aarch64)"             # group 6: platform tag
    r"\.whl$"
)


# ---------------------------------------------------------------------------
# Wheel filename parser
# ---------------------------------------------------------------------------

def parse_wheel(entry):
    """
    Parse a WheelEntry into classification fields.

    Returns (key, cxx11abi, path_dict, leaf_data), or None for non-matching assets.
    """
    m = _WHEEL_RE.match(entry.name)
    if m is None:
        return None

    version, cuda_digits, torch_compat, cxx11abi, cpver, platform = m.groups()

    os_arch = parse_wheel_platform(platform)
    if os_arch is None:
        return None
    os_name, arch = os_arch

    pyver        = "py" + cpver[2:]
    cuda_version = "cu" + cuda_digits
    torch_compat = normalize_torch_compat(torch_compat)

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
    strip_nix_shell_dashdash()

    p = argparse.ArgumentParser(
        description="Generate causal-conv1d binary-hashes and source-hashes.",
    )
    add_common_args(p)
    args = p.parse_args()

    run_all_hashes(
        GITHUB_REPO, parse_wheel,
        BINARY_HASHES_DIR, SOURCE_HASHES_DIR,
        SCHEMA, DIMENSIONS, VERSION_SPEC, BINARY_HEADER_TEMPLATE,
        _HERE, args,
    )


if __name__ == "__main__":
    main()
