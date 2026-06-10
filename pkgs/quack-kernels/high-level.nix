# High-level derivation for quack-kernels (Dao-AILab/quack).
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# QuACK is a pure-Python package of CuTeDSL kernels: all GPU code is
# JIT-compiled at runtime by nvidia-cutlass-dsl, so there is nothing to
# pre-compile.  It is built from the GitHub source tags (SOURCE-ONLY in this
# flake — upstream's PyPI wheels are plain py3-none-any and add nothing over
# the source build).
#
# Note on version pairing: quack-kernels 0.5.0+ requires nvidia-cutlass-dsl
# >= 4.5.2 while 0.3.11–0.4.x require >= 4.4.2.  The static constraint below
# only encodes the lower bound; when sonic-moe is in the same environment its
# constraints pin both packages to a consistent pair (cutlass-dsl 4.4.x +
# quack <= 0.4.x).
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     mlPackages = with pp; [ quack-kernels ];  # deps implied automatically
#     python   = "3.13";
#     cuda     = "12.8";
#     allowBuildingFromSource = true;  # required — source-only package
#   };

{ torch, nvidia-cutlass-dsl, apache-tvm-ffi, torch-c-dlpack-ext, hldHelpers, packageName }:

assert hldHelpers.isHLD torch;
assert hldHelpers.isHLD nvidia-cutlass-dsl;
assert hldHelpers.isHLD apache-tvm-ffi;
assert hldHelpers.isHLD torch-c-dlpack-ext;

{
  # ── Origin type ────────────────────────────────────────────────────────────
  originType = "github-releases";

  # ── Identity fields ────────────────────────────────────────────────────────
  srcOwner = "Dao-AILab";
  srcRepo  = "quack";

  # ── Torch agnosticism ──────────────────────────────────────────────────────
  # Pure Python — torch is only a Python-level runtime dependency.
  torchAgnostic = true;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = {
    inherit torch nvidia-cutlass-dsl apache-tvm-ffi torch-c-dlpack-ext;
  };

  # ── Dependency version constraints ─────────────────────────────────────────
  versionConstraints = {
    nvidia-cutlass-dsl = { minVersion = "4.4.2"; };
    apache-tvm-ffi = { minVersion = "0.1.6"; maxVersion = "0.1.99"; };
  };

  # ── Version availability ───────────────────────────────────────────────────
  # Source-only: version resolution is driven entirely by source-hashes/.
  getVersions = hldHelpers.getVersionsFromSourceFiles ./source-hashes;

  # ── ABI compatibility check ────────────────────────────────────────────────
  # No binary wheels → always fall through to buildSource.
  canBuildBin = _: false;

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  buildBin = _:
    throw "quack-kernels: pure-Python source-only package in this flake; use allowBuildingFromSource = true";

  # ── Build from source ──────────────────────────────────────────────────────
  buildSource =
    { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      v = hldHelpers.requireSourceHash
            "quack-kernels" "pkgs/quack-kernels" ./source-hashes
            { inherit version cudaLabel; };
    in
    import ./overlay-source.nix {
      overlayInfo = mkOverlayInfo { inherit pkgs cudaPackages resolvedDeps; version = v; };
      nvidia-cutlass-dsl = resolvedDeps."nvidia-cutlass-dsl";
      apache-tvm-ffi = resolvedDeps."apache-tvm-ffi";
      torch-c-dlpack-ext = resolvedDeps."torch-c-dlpack-ext";
    };
}
