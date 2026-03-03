# High-level derivation for causal-conv1d.
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# causal-conv1d depends on torch at the high level.  When concretised, the
# resolved concrete torch derivation is available via resolvedDeps."torch".
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     packages = with pp; [ "causal-conv1d" ];  # torch is implied automatically
#     python   = "3.13";
#     cuda     = "12.6";
#   };

{ torch }:

# Fail early if the caller passed something other than a high-level derivation.
assert torch._isHighLevelDerivation or false;

{
  # ── Type marker ────────────────────────────────────────────────────────────
  _isHighLevelDerivation = true;

  # ── Identity ───────────────────────────────────────────────────────────────
  packageName    = "causal-conv1d";
  defaultVersion = "1.6.0";

  # ── Binary availability ────────────────────────────────────────────────────
  # causal-conv1d pre-built wheels use a generic "cu12" label that covers all
  # CUDA 12.x variants (cu126, cu128, …).  concretise will fall back to "cu12"
  # automatically when the exact cudaLabel is not found here.
  binVersions = {
    cu12 = [ "1.6.0" ];
  };

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = { inherit torch; };

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  #
  # Received from concretise:
  #   { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version }
  #
  # causal-conv1d wheels are generic across CUDA 12.x, so we always use "cu12"
  # as the cudaVersion passed to override.nix regardless of cudaLabel.
  buildBin = { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version }:
    import ./override.nix {
      inherit pkgs;
      torch               = resolvedDeps."torch";
      causalConv1dVersion = version;
      cudaVersion         = "cu12";
      # cxx11abi defaults to "TRUE" in override.nix, matching standard pip wheels
    };

  # ── Build from source ──────────────────────────────────────────────────────
  buildSource = { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version }:
    throw "causal-conv1d/high-level.nix: buildSource is not yet implemented";
}
