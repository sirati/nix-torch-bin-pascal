#!/usr/bin/env python3
"""
Test runner for per-package manual_debug.py scripts.

Discovers and runs test scripts passed via --test-scripts or --pkg-module.
Each script must expose a main(cuda_available: bool) -> int function.

Usage (full suite via test.nix):
    python3 test-runner/main.py --test-scripts torch:/nix/store/.../manual_debug.py ...

Usage (single package via per-package app):
    python3 test-runner/main.py --pkg-module pkgs/flash-attn/manual_debug.py
"""

import argparse
import importlib.util
import os
import sys
import traceback


def print_section(title):
    print("\n" + "=" * 60)
    print(f"  {title}")
    print("=" * 60)


def load_test_module(path):
    """Load a manual_debug.py script as a Python module."""
    spec = importlib.util.spec_from_file_location("manual_debug", path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def detect_cuda():
    """Detect CUDA availability without hard-depending on torch."""
    try:
        import torch

        return torch.cuda.is_available()
    except ImportError:
        return False


def parse_script_arg(arg):
    """Parse a 'name:path' or plain 'path' argument into (name, path)."""
    if ":" in arg:
        # Find the first colon that's NOT part of a path (e.g. /nix/store/...)
        # Format is "package-name:/nix/store/..."
        name, _, path = arg.partition(":")
        return name, path
    else:
        # Bare path — derive name from filename's parent dir
        return os.path.basename(os.path.dirname(arg)), arg


def main():
    parser = argparse.ArgumentParser(
        description="Test runner for manual_debug.py scripts"
    )
    parser.add_argument(
        "--test-scripts",
        nargs="*",
        default=[],
        help="name:path pairs of manual_debug.py test scripts to run",
    )
    parser.add_argument(
        "--pkg-module",
        help="Path to a single manual_debug.py (for per-package testing)",
    )
    args = parser.parse_args()

    cuda_available = detect_cuda()

    # Collect test scripts as (name, path) tuples
    scripts = [parse_script_arg(s) for s in args.test_scripts]
    if args.pkg_module:
        scripts.append(parse_script_arg(args.pkg_module))

    if not scripts:
        print("No test scripts specified.")
        return 0

    # Run each test script
    failures = []
    for name, script_path in scripts:
        try:
            mod = load_test_module(script_path)
            result = mod.main(cuda_available)
            if result and result != 0:
                failures.append(name)
        except AssertionError as exc:
            print(f"\n\u2717 Assertion failed in {name}: {exc}", file=sys.stderr)
            failures.append(name)
        except Exception as exc:
            print(f"\n\u2717 Error in {name}: {exc}", file=sys.stderr)
            traceback.print_exc()
            failures.append(name)

    # Summary
    print_section("Summary")
    if failures:
        print(f"  \u2717 {len(failures)} test(s) failed:")
        for name in failures:
            print(f"      - {name}")
        return 1
    else:
        print(f"  \u2713 All {len(scripts)} test(s) passed!")
        return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as exc:
        print(f"\n\u2717 Fatal error: {exc}", file=sys.stderr)
        traceback.print_exc()
        sys.exit(1)
