# High-level derivation for mamba-ssm.
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# mamba-ssm depends on torch and causal-conv1d at the high level.  When
# concretised, the resolved concrete derivations are available via
# resolvedDeps."torch" and resolvedDeps."causal-conv1d".
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     mlPackages = with pp; [ mamba-ssm ];  # torch and causal-conv1d implied
#     python   = "3.13";
#     cuda     = "12.8";
#   };

{ torch, causal-conv1d, hldHelpers, packageName }:

# Fail early if the caller passed something other than high-level derivations.
assert hldHelpers.isHLD torch;
assert hldHelpers.isHLD causal-conv1d;

{
  # ── Origin type ────────────────────────────────────────────────────────────
  originType = "github-releases";

  # ── Identity fields ────────────────────────────────────────────────────────
  # pname and nixpkgsAttr both equal packageName ("mamba-ssm") and are
  # filled in automatically by hld-type.nix validate.
  # mkChangelog and mkOverlayInfo are auto-derived for "github-releases" origin.
  srcOwner = "state-spaces";
  srcRepo  = "mamba";

  # ── Binary availability ────────────────────────────────────────────────────
  getVersions = hldHelpers.getVersionsFromVersionFiles ./binary-hashes;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = {
    inherit torch causal-conv1d;
  };

  # ── ABI compatibility check ────────────────────────────────────────────────
  canBuildBin = hldHelpers.canBuildBinFromVersionFiles ./binary-hashes;

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  #
  # mkOverlayInfo is injected by concretise from the validated HLD.
  # mamba-ssm wheels are generic across CUDA 12.x, so we always use "cu12".
  buildBin = { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    import ./overlay-bin.nix {
      overlayInfo   = mkOverlayInfo { inherit pkgs cudaPackages version resolvedDeps; };
      causal-conv1d = resolvedDeps."causal-conv1d";
      cudaVersion   = "cu12";
    };

  # ── Build from source ──────────────────────────────────────────────────────
  buildSource = { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      v = hldHelpers.requireSourceHash
            "mamba-ssm" "pkgs/mamba-ssm" ./source-hashes
            { inherit version cudaLabel; };
    in
    import ./overlay-source.nix {
      overlayInfo   = mkOverlayInfo { inherit pkgs cudaPackages resolvedDeps; version = v; };
      causal-conv1d = resolvedDeps."causal-conv1d";
    };
}
