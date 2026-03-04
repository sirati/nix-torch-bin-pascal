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

Options:
  --tag TAG        Process only this specific release tag instead of all releases.
  --skip-source    Skip source-hash generation (binary hashes only).
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
    collect_all_wheels,
    resolve_tags,
    run_binary_hashes,
    strip_nix_shell_dashdash,
    winning_tag_for_base_versions,
    write_missing_digests,
)
from pkg_helpers import make_torch_binary_header_template, pkg_hash_dirs
from source_fetcher import (
    SourceEntry,
    fetch_github_source_hash,
    source_hash_exists,
    write_source_hash_file,
)

# ---------------------------------------------------------------------------
# Package-specific configuration
# ---------------------------------------------------------------------------

GITHUB_REPO = "Dao-AILab/causal-conv1d"
OWNER       = "Dao-AILab"
REPO        = "causal-conv1d"

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
    p.add_argument(
        "--skip-source",
        action="store_true",
        help="Skip source-hash generation (binary hashes only).",
    )
    args = p.parse_args()

    tags, too_old_tags = resolve_tags(GITHUB_REPO, args)

    all_raw, missing_tags = collect_all_wheels(GITHUB_REPO, tags, args.token, parse_wheel)
    write_missing_digests(_HERE, missing_tags, too_old_tags)

    organized = run_binary_hashes(
        all_raw, BINARY_HASHES_DIR, SCHEMA, DIMENSIONS, VERSION_SPEC, BINARY_HEADER_TEMPLATE,
    )

    # ── Source hashes ─────────────────────────────────────────────────────────
    if args.skip_source:
        print("\nSkipping source-hash generation (--skip-source).", file=sys.stderr)
        return

    # Map base_version → winning tag (highest post release for that base).
    winning_tags = winning_tag_for_base_versions(tags)

    print(file=sys.stderr)
    for base_version in sorted(organized.keys(), key=sort_version_key):
        if source_hash_exists(SOURCE_HASHES_DIR, base_version):
            print(
                f"  source-hashes/v{base_version}.nix already exists — skipping.",
                file=sys.stderr,
            )
            continue

        winning_tag = winning_tags.get(base_version)
        if winning_tag is None:
            # Shouldn't normally happen — fall back to plain v{version}.
            winning_tag = f"v{base_version}"
            print(
                f"  WARNING: no release tag found for {base_version}; "
                f"using {winning_tag}.",
                file=sys.stderr,
            )

        try:
            sri_hash = fetch_github_source_hash(OWNER, REPO, winning_tag)
            write_source_hash_file(
                SOURCE_HASHES_DIR,
                SourceEntry(
                    version=base_version,
                    tag=winning_tag,
                    hash=sri_hash,
                ),
            )
        except Exception as exc:  # noqa: BLE001
            print(
                f"  ERROR fetching source hash for {base_version} "
                f"({winning_tag}): {exc}",
                file=sys.stderr,
            )
            sys.exit(1)


if __name__ == "__main__":
    main()
