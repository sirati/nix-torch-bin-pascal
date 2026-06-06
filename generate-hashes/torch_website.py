"""
Shared driver for per-Python torch-website wheel-hash generation.

torch, torchvision and torchaudio are all distributed from download.pytorch.org
as per-CUDA-variant, per-Python wheels with an identical binary-hashes layout
(``version -> pyVer -> os -> arch``).  This module implements the whole
gen-hashes flow once; each ``pkgs/<pkg>/generate-hashes.py`` only constructs a
:class:`TorchWebsiteHashGen` with the package name, output dir, CUDA variants
and a couple of knobs, then exposes ``run = gen.run``.

(torchao is intentionally NOT built on this: it ships a single Python Stable
ABI ``cp310-abi3`` wheel per platform and also generates source hashes.  triton
is CUDA-agnostic with a different filename shape — see ``source_triton``.)
"""
from __future__ import annotations

import argparse
import os
import re
import sys

from common import (
    deduplicate_post_versions,
    parse_wheel_platform,
    sort_version_key,
    sort_pyver_key_ft,
)
from nix_writer import DimSpec, organize_wheels, write_binary_hashes_nix
from source_pytorch_org import PyTorchOrgWheelSource


_BASE_URL = "https://download.pytorch.org/whl"

# Identical binary-hashes layout for every per-Python torch-website package.
_SCHEMA = [
    DimSpec("version", quoted=True, sort_key=sort_version_key),
    DimSpec("pyVer",   sort_key=sort_pyver_key_ft),
    DimSpec("os"),
    DimSpec("arch"),
]
_DIMENSIONS = ["version", "pyVer", "os", "arch"]


class TorchWebsiteHashGen:
    """
    Generate ``binary-hashes/<cuda_variant>.nix`` files for one per-Python
    torch-website package.

    Parameters
    ----------
    package:
        Package name as it appears in the wheel index path and filenames,
        e.g. ``"torch"``, ``"torchvision"``, ``"torchaudio"``.
    output_dir:
        Destination directory (the package's ``binary-hashes/`` dir).
    cuda_variants:
        CUDA labels to generate, e.g. ``["cu126", "cu128", "cu130", "cu132"]``.
    min_major:
        If set, drop wheels whose major version is below this (torch keeps only
        ``>= 2``).  None (default) keeps every version.
    allow_empty:
        When True a CUDA variant with no matching wheels writes a valid empty
        hash file (so a brand-new, not-yet-populated CUDA label still produces
        a parseable file); when False (torch) an empty result aborts the run.
    version_filter:
        Optional regex (raw string) passed through to the wheel source.
    """

    def __init__(
        self,
        package: str,
        output_dir: str,
        cuda_variants: list[str],
        *,
        min_major: int | None = None,
        allow_empty: bool = False,
        version_filter: str | None = None,
    ) -> None:
        self.package = package
        self.output_dir = output_dir
        self.cuda_variants = list(cuda_variants)
        self.min_major = min_major
        self.allow_empty = allow_empty
        self.version_filter = version_filter

        # Wheel name shape produced by PyTorchOrgWheelSource:
        #   <package>-<version>-<abitag>-<abitag>-<platform>.whl
        # e.g. torch-2.10.0-cp312-cp312-manylinux_2_28_x86_64.whl
        #      torchvision-0.27.0-cp313t-cp313t-...whl   (free-threaded)
        #      torch-2.9.1.post1-cp312-cp312-...whl       (post-release)
        self._wheel_re = re.compile(
            r"^" + re.escape(package) + r"-"
            r"(\d+\.\d+\.\d+(?:\.post\d+)?)"   # group 1: version (optional .postN)
            r"-(cp\d+t?)"                       # group 2: abi tag, e.g. cp312 / cp313t
            r"-cp\d+t?"                         # abi tag repeated (ignored)
            r"-([\w]+(?:_[\w]+)*)"              # group 3: platform tag
            r"\.whl$"
        )

    # ------------------------------------------------------------------
    # Helpers
    # ------------------------------------------------------------------

    def _source_url(self, cuda_variant: str) -> str:
        return f"{_BASE_URL}/{cuda_variant}/{self.package}/"

    def _make_header(self, cuda_variant: str) -> str:
        return f"""\
# WARNING: Auto-generated file. Do not edit manually!
# Source:  {self._source_url(cuda_variant)}
# To regenerate: nix run .#default.{self.package}.gen-hashes [-- --cuda {cuda_variant}]
#
# Structure: version -> pythonVersion -> os -> arch
#   pythonVersion: py310, py311, py312, py313, py313-freethreaded, py314, py314-freethreaded
#   os: linux, windows
#   arch: x86_64, aarch64"""

    def _parse_wheel(self, entry) -> dict | None:
        """Map a PyTorchOrgWheelSource entry to the path dict used for nesting."""
        m = self._wheel_re.match(entry.name)
        if m is None:
            return None

        version, abitag, platform = m.groups()

        os_arch = parse_wheel_platform(platform)
        if os_arch is None:
            return None
        os_name, arch = os_arch

        is_ft  = abitag.endswith("t")
        pynum  = abitag[2:].rstrip("t")
        py_key = f"py{pynum}-freethreaded" if is_ft else f"py{pynum}"

        return {"version": version, "pyVer": py_key, "os": os_name, "arch": arch}

    @staticmethod
    def _major(version: str) -> int:
        try:
            return int(version.split(".")[0])
        except (ValueError, IndexError):
            return 0

    # ------------------------------------------------------------------
    # Generation
    # ------------------------------------------------------------------

    def _generate_variant(self, cuda_variant: str) -> None:
        output_path = os.path.join(self.output_dir, f"{cuda_variant}.nix")

        print(f"Fetching {self.package} {cuda_variant} wheel index …")
        source = PyTorchOrgWheelSource(
            self.package, cuda_variant, version_filter=self.version_filter
        )

        entries = []
        skipped = 0
        for entry in source.fetch_wheels():
            path = self._parse_wheel(entry)
            if path is None:
                print(f"  SKIP  {entry.name}", file=sys.stderr)
                skipped += 1
                continue
            entries.append((path, entry.to_leaf()))

        if skipped:
            print(f"  ({skipped} wheel(s) skipped due to unrecognised format)")

        if self.min_major is not None:
            before_filter = len(entries)
            entries = [
                (p, e) for p, e in entries
                if self._major(p["version"]) >= self.min_major
            ]
            dropped = before_filter - len(entries)
            if dropped:
                print(f"  ({dropped} wheel(s) dropped for {self.package} < {self.min_major})")

        entries = deduplicate_post_versions(entries)

        if not entries:
            if not self.allow_empty:
                print(
                    f"No wheels matched for {cuda_variant} — index may be empty or unreachable.",
                    file=sys.stderr,
                )
                sys.exit(1)
            # No cuda-tagged wheels for this variant yet (e.g. a brand-new CUDA
            # label upstream has not populated).  Write a valid, empty hash file
            # so the per-CUDA file still exists and parses, rather than aborting.
            print(
                f"No wheels matched for {cuda_variant} — writing empty hash file.",
                file=sys.stderr,
            )
            organized = {}
        else:
            organized = organize_wheels(entries, _DIMENSIONS)

        write_binary_hashes_nix(
            output_path,
            organized,
            _SCHEMA,
            self._make_header(cuda_variant),
            wrap_in_func=False,
            prefix_attrs={"_cudaLabel": cuda_variant},
        )

    # ------------------------------------------------------------------
    # Entry point
    # ------------------------------------------------------------------

    def run(self) -> None:
        """Entry point invoked by ``generate-hashes/main.py`` for torch-website packages."""
        parser = argparse.ArgumentParser(
            description=(
                f"Generate {self.package} binary-hashes .nix files "
                f"from the PyTorch wheel index."
            )
        )
        parser.add_argument(
            "--cuda",
            choices=self.cuda_variants,
            action="append",
            dest="cuda_variants",
            metavar="VARIANT",
            help=(
                "CUDA variant to generate (e.g. cu126, cu128). "
                "May be repeated. Defaults to all variants."
            ),
        )
        args = parser.parse_args()

        variants = args.cuda_variants or self.cuda_variants

        os.makedirs(self.output_dir, exist_ok=True)
        for variant in variants:
            self._generate_variant(variant)
