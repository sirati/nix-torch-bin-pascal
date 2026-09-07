# High-level derivation for nvidia-cutlass-dsl (CuTeDSL).
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# nvidia-cutlass-dsl is a BINARY-ONLY package: the PyPI wheels ship prebuilt
# proprietary MLIR/NVVM compiler binaries for which no source is published.
# The PyPI distribution is split into:
#   nvidia-cutlass-dsl            – empty metadata-only meta wheel (py3-none-any)
#   nvidia-cutlass-dsl-libs-base  – the compiled package (per-CPython manylinux)
#   nvidia-cutlass-dsl-libs-core  – the pure-Python frontend (4.6.0+)
#   nvidia-cutlass-dsl-libs-cu12  – CUDA 12 toolkit flavor + runtime (4.6.0+)
#   nvidia-cutlass-dsl-libs-cu13  – CUDA 13 toolkit flavor / extra runtime libs
# plus the cuda-python / cuda-bindings / cuda-pathfinder runtime dependency
# chain, which is not packaged in nixpkgs and is therefore installed from
# pinned PyPI wheels inside overlay-bin.nix (hashes live in
# binary-hashes/cuda-deps-cu1{2,3}.nix).
#
# CuTeDSL JIT-compiles kernels at runtime via its bundled compiler — it never
# links against torch, so the package is torch-agnostic.  It is NOT
# CUDA-agnostic: cu130 environments additionally pull the libs-cu13 wheel.
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.

{ hldHelpers, packageName }:

{
  # ── Origin type ────────────────────────────────────────────────────────────
  # Wheels come from PyPI; mkChangelog defaults to the PyPI release page.
  originType = "pypi";

  # ── Identity fields ────────────────────────────────────────────────────────
  # The DSL is developed in the CUTLASS repository (its Python DSL frontend).
  srcOwner = "NVIDIA";
  srcRepo  = "cutlass";

  # ── Torch agnosticism ──────────────────────────────────────────────────────
  # No torch dependency at any level; the store path omits -torch{series}.
  torchAgnostic = true;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = { };

  # ── Version availability ───────────────────────────────────────────────────
  # binary-hashes/v{version}.nix files have the structure:
  #   { _version; meta = leaf; base = pyVer -> os -> arch -> leaf;
  #     core = leaf; cu12 = …; cu13 = …; nvdisasm = os -> arch -> leaf; }
  # Up to 4.5.x libs-base carries the Python frontend and the cu12 runtime.
  # From 4.6.0 libs-base holds only the compiled MLIR libraries: the frontend
  # is the libs-core wheel (`core`) and the toolkit flavor + runtime is the
  # libs-cu12 / libs-cu13 wheel.  A version is usable when a libs-base wheel
  # exists for the requested Python, when the split layout's cu12 wheel
  # exists for it too, and — for cu130 — when the libs-cu13 section is
  # present.  Dev builds (v4.8.0.dev0.nix) are listed like releases.
  getVersions =
    cudaLabel: pyVer:
    let
      files = builtins.readDir ./binary-hashes;
      vNames = builtins.filter (
        n: builtins.match "v[0-9]+\\.[0-9]+\\.[0-9]+(\\.dev[0-9]+)?\\.nix" n != null
      ) (builtins.attrNames files);
      versions = map (n: builtins.substring 1 (builtins.stringLength n - 5) n) vNames;
    in
    builtins.filter (
      v:
      let
        h = import (./binary-hashes + "/v${v}.nix");
      in
      builtins.hasAttr pyVer h.base
      && (!(h ? core) || builtins.hasAttr pyVer h.cu12)
      && (cudaLabel != "cu130" || builtins.hasAttr "cu13" h)
    ) versions;

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  buildBin =
    { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    import ./overlay-bin.nix {
      overlayInfo = mkOverlayInfo { inherit pkgs cudaPackages version resolvedDeps; };
      inherit cudaLabel;
    };

  # ── Build from source ──────────────────────────────────────────────────────
  buildSource = _:
    throw "nvidia-cutlass-dsl: no source build exists — the wheels ship prebuilt proprietary MLIR/NVVM binaries (PyPI-only distribution).";
}
