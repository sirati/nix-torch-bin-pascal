# High-level derivation for sonic-moe (Dao-AILab/sonic-moe, SonicMoE).
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# SonicMoE is a pure-Python Mixture-of-Experts implementation built on
# QuACK/CuTeDSL grouped-GEMM kernels (Hopper SM90 / Blackwell SM100/SM120
# GPUs; all GPU code JIT-compiles at runtime).  It is built from the GitHub
# source tags (SOURCE-ONLY in this flake — upstream's PyPI wheels are plain
# py3-none-any and add nothing over the source build).
#
# Upstream pins (sonic-moe 0.1.2, encoded in versionConstraints below):
#   torch              >= 2.7.1, <= 2.9.x
#   nvidia-cutlass-dsl == 4.4.2
#   quack-kernels      >= 0.3.11 (and <= 0.4.x, because quack 0.5.0 requires
#                       nvidia-cutlass-dsl >= 4.5.2, conflicting with the
#                       == 4.4.2 pin)
#   Python             >= 3.12  (gated in getVersions)
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     mlPackages = with pp; [ sonic-moe ];  # deps implied automatically
#     python   = "3.13";
#     cuda     = "12.8";
#     torch    = "2.9";                # sonic-moe does not support 2.10+
#     allowBuildingFromSource = true;  # required — source-only package
#   };

{ torch, quack-kernels, nvidia-cutlass-dsl, hldHelpers, packageName }:

assert hldHelpers.isHLD torch;
assert hldHelpers.isHLD quack-kernels;
assert hldHelpers.isHLD nvidia-cutlass-dsl;

{
  # ── Origin type ────────────────────────────────────────────────────────────
  originType = "github-releases";

  # ── Identity fields ────────────────────────────────────────────────────────
  srcOwner = "Dao-AILab";
  srcRepo  = "sonic-moe";

  # sonic-moe uses bare version tags (e.g. "0.1.2") instead of v-prefixed
  # tags, so we override the default mkChangelog which would prepend "v".
  mkChangelog = v:
    "https://github.com/Dao-AILab/sonic-moe/releases/tag/${v}";

  # ── Torch agnosticism ──────────────────────────────────────────────────────
  # Pure Python — torch is only a Python-level runtime dependency.
  torchAgnostic = true;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = {
    inherit torch quack-kernels nvidia-cutlass-dsl;
  };

  # ── Dependency version constraints ─────────────────────────────────────────
  versionConstraints = {
    torch = { minVersion = "2.7.1"; maxVersion = "2.9.99"; };
    nvidia-cutlass-dsl = { minVersion = "4.4.2"; maxVersion = "4.4.99"; };
    quack-kernels = { minVersion = "0.3.11"; maxVersion = "0.4.99"; };
  };

  # ── Version availability ───────────────────────────────────────────────────
  # Source-only, with an upstream requires-python >= 3.12 gate: returning []
  # for older Pythons makes concretise fail early with a clear diagnostic
  # instead of building a package that cannot import.
  getVersions =
    cudaLabel: pyVer:
    if builtins.match "py3(1[2-9]|[2-9][0-9]).*" pyVer != null then
      hldHelpers.getVersionsFromSourceFiles ./source-hashes cudaLabel pyVer
    else
      [ ];

  # ── ABI compatibility check ────────────────────────────────────────────────
  # No binary wheels → always fall through to buildSource.
  canBuildBin = _: false;

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  buildBin = _:
    throw "sonic-moe: pure-Python source-only package in this flake; use allowBuildingFromSource = true";

  # ── Build from source ──────────────────────────────────────────────────────
  buildSource =
    { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      v =
        if version == null then
          throw ("sonic-moe buildSource: no buildable version resolved — "
            + "note that sonic-moe requires Python >= 3.12.")
        else
          hldHelpers.requireSourceHash
            "sonic-moe" "pkgs/sonic-moe" ./source-hashes
            { inherit version cudaLabel; };
    in
    import ./overlay-source.nix {
      overlayInfo = mkOverlayInfo { inherit pkgs cudaPackages resolvedDeps; version = v; };
      quack-kernels = resolvedDeps."quack-kernels";
      nvidia-cutlass-dsl = resolvedDeps."nvidia-cutlass-dsl";
    };
}
