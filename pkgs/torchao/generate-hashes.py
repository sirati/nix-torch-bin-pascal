"""
torchao generate-hashes configuration module.

Imported by the shared entry point ``generate-hashes/main.py``.
Do NOT add a main() here.

torchao wheels are distributed via download.pytorch.org per CUDA variant.
Uses Python Stable ABI (cp310-abi3) so there is no per-Python-version
dimension — a single wheel serves all Python 3.10+.

Invocation (from project root):
  nix run .#default.torchao.gen-hashes
  nix run .#default.torchao.gen-hashes -- --cuda cu126 --cuda cu128
  nix run .#default.torchao.gen-hashes -- --source-only --tag v0.16.0

Options (parsed by run()):
  --cuda VARIANT   CUDA variant(s) to process (repeatable; default: all).
  --source-only    Only generate source hashes (delegated to shared main).
  --tag TAG        Process only a specific release tag (source-only mode).
  --token TOKEN    GitHub API token (also read from $GITHUB_TOKEN).
"""

import argparse
import os
import sys

# When loaded as a module by main.py, generate-hashes/ is already on sys.path.
_GENERATE_HASHES_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "../..", "generate-hashes"
)
if _GENERATE_HASHES_DIR not in sys.path:
    sys.path.insert(0, _GENERATE_HASHES_DIR)

from common import (
    deduplicate_post_versions,
    parse_wheel_platform,
    sort_version_key,
)
from nix_writer import DimSpec, organize_wheels
from nix_writer.write_nix import write_binary_hashes_nix
from source_fetcher import (
    SourceEntry,
    fetch_github_source_hash_with_submodules,
    source_hash_exists,
    write_source_hash_file,
)
from source_torchao import TorchaoWheelSource

# Source hashes are available (GitHub releases with submodules).
WITH_SUBMODULES = True

_GITHUB_OWNER = "pytorch"
_GITHUB_REPO = "ao"
_SOURCE_HASHES_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "source-hashes"
)

# ---------------------------------------------------------------------------
# Output configuration
# ---------------------------------------------------------------------------

OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "binary-hashes")

# Schema for the content inside each per-CUDA-variant file.
# Structure: version -> os -> arch -> {name, url, hash}
SCHEMA = [
    DimSpec("version", quoted=True, sort_key=sort_version_key),
    DimSpec("os"),
    DimSpec("arch"),
]

DIMENSIONS = ["version", "os", "arch"]

VARIANTS = {
    "cu126": "cu126",
    "cu128": "cu128",
    "cu130": "cu130",
}

HEADER_TEMPLATE = """\
# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://download.pytorch.org/whl/{cuda_variant}/torchao/
# To regenerate: nix run .#default.torchao.gen-hashes [-- --cuda {cuda_variant}]
#
# torchao binary-wheel hashes for CUDA {cuda_variant}.
# Uses Stable ABI (cp310-abi3): one wheel for all Python 3.10+.
#
# Structure: version -> os -> arch"""


# ---------------------------------------------------------------------------
# Wheel filename parser
# ---------------------------------------------------------------------------


def _parse_wheel(entry) -> dict | None:
    """Map a TorchaoWheelSource entry to the path dict for nesting."""
    # entry.name has the form:
    #   torchao-0.16.0-cp310-abi3-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl
    import re

    m = re.match(
        r"^torchao-"
        r"(\d+\.\d+\.\d+(?:\.post\d+)?)"  # group 1: version
        r"-cp\d+t?"  # Python tag (ignored)
        r"-abi3"  # stable ABI
        r"-([\w]+(?:[._][\w]+)*)"  # group 2: platform tag
        r"\.whl$",
        entry.name,
    )
    if m is None:
        return None

    version, platform = m.groups()

    # Parse platform tag (may be compound like
    # "manylinux_2_24_x86_64.manylinux_2_28_x86_64").
    os_arch = None
    for p in platform.split("."):
        result = parse_wheel_platform(p)
        if result is not None:
            os_arch = result
            break
    if os_arch is None:
        return None
    os_name, arch = os_arch

    return {"version": version, "os": os_name, "arch": arch}


# ---------------------------------------------------------------------------
# Per-variant generation
# ---------------------------------------------------------------------------


def _generate_variant(cuda_variant: str) -> None:
    print(f"\n=== {cuda_variant} ===")
    source = TorchaoWheelSource(cuda_variant=cuda_variant, min_version="0.10.0")

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

    entries = deduplicate_post_versions(entries)

    if not entries:
        print(
            f"No wheels matched for {cuda_variant} — index may be empty.",
            file=sys.stderr,
        )
        return

    organized = organize_wheels(entries, DIMENSIONS)

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    out_path = os.path.join(OUTPUT_DIR, f"{cuda_variant}.nix")
    header = HEADER_TEMPLATE.format(cuda_variant=cuda_variant)
    write_binary_hashes_nix(
        out_path,
        organized,
        SCHEMA,
        header,
        wrap_in_func=False,
        prefix_attrs={"_cudaLabel": cuda_variant},
    )


# ---------------------------------------------------------------------------
# run() — called by the shared main for torch-website packages
# ---------------------------------------------------------------------------


def _generate_source_hash(tag: str, force: bool) -> None:
    """Generate a single source hash for the given tag."""
    # Strip leading 'v' for the version string.
    version = tag.lstrip("v")
    if not force and source_hash_exists(_SOURCE_HASHES_DIR, version):
        print(f"  source-hashes/v{version}.nix already exists — skipping.")
        return

    sri = fetch_github_source_hash_with_submodules(_GITHUB_OWNER, _GITHUB_REPO, tag)
    entry = SourceEntry(version=version, tag=tag, hash=sri)
    write_source_hash_file(_SOURCE_HASHES_DIR, entry)


def _generate_all_source_hashes(tag: str | None, regenerate: bool = False) -> None:
    """Generate source hashes: single tag or all tags from GitHub releases."""
    if tag is not None:
        # Single tag mode — always overwrite.
        _generate_source_hash(tag, force=True)
        return

    # Fetch all release tags from GitHub API.
    import json
    from urllib.request import Request, urlopen

    token = os.environ.get("GITHUB_TOKEN", "")
    headers = {"Accept": "application/vnd.github+json"}
    if token:
        headers["Authorization"] = f"Bearer {token}"

    tags = []
    page = 1
    while True:
        url = (
            f"https://api.github.com/repos/{_GITHUB_OWNER}/{_GITHUB_REPO}"
            f"/releases?per_page=100&page={page}"
        )
        req = Request(url, headers=headers)
        with urlopen(req) as resp:
            releases = json.loads(resp.read().decode("utf-8"))
        if not releases:
            break
        for r in releases:
            if not r.get("prerelease", False) and not r.get("draft", False):
                tags.append(r["tag_name"])
        page += 1

    print(f"Found {len(tags)} release(s) for source hashes.")
    for t in tags:
        _generate_source_hash(t, force=regenerate)


def run() -> None:
    """Entry point called by ``generate-hashes/main.py`` for torch-website packages."""
    parser = argparse.ArgumentParser(description="Generate torchao hashes")
    parser.add_argument(
        "--cuda",
        action="append",
        dest="cuda_variants",
        help="CUDA variant(s) to process (repeatable; default: all)",
    )
    parser.add_argument(
        "--source-only",
        action="store_true",
        help="Only generate source hashes; skip binary-wheel generation.",
    )
    parser.add_argument(
        "--tag",
        default=None,
        help="Process only this specific release tag (for source hashes).",
    )
    parser.add_argument(
        "--regenerate",
        action="store_true",
        help="Regenerate (overwrite) all existing hash files.",
    )
    args, _remaining = parser.parse_known_args()

    if not args.source_only:
        variants = args.cuda_variants or list(VARIANTS.keys())
        for v in variants:
            if v not in VARIANTS:
                print(f"Unknown CUDA variant: {v}", file=sys.stderr)
                sys.exit(1)
            _generate_variant(v)

    # Generate source hashes.
    if args.source_only or args.tag:
        _generate_all_source_hashes(args.tag, regenerate=args.regenerate)
