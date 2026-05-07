# High-level derivation for causal-conv1d.
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# causal-conv1d depends on torch at the high level.  When concretised, the
# resolved concrete torch derivation is available via resolvedDeps."torch".
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.
# No manual import of hld-helpers.nix is needed here.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     mlPackages = with pp; [ causal-conv1d ];  # torch is implied automatically
#     python   = "3.13";
#     cuda     = "12.8";
#   };

{ torch, hldHelpers, packageName }:

# Fail early if the caller passed something other than a high-level derivation.
assert hldHelpers.isHLD torch;

{
  # ── Origin type ────────────────────────────────────────────────────────────
  originType = "github-releases";

  # ── Identity fields ────────────────────────────────────────────────────────
  # pname and nixpkgsAttr both equal packageName ("causal-conv1d") and are
  # filled in automatically by hld-type.nix validate.
  # mkChangelog and mkOverlayInfo are auto-derived for "github-releases" origin.
  srcOwner = "Dao-AILab";
  srcRepo  = "causal-conv1d";

  # ── Binary availability ────────────────────────────────────────────────────
  # causal-conv1d uses per-version files: binary-hashes/v{version}.nix
  # Each file is a plain attrset keyed by cudaVersion label.
  # The generic "cu12" key covers all CUDA 12.x variants.
  getVersions = hldHelpers.getVersionsFromVersionFiles ./binary-hashes;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = { inherit torch; };

  # ── ABI compatibility check ────────────────────────────────────────────────
  #
  # Returns false when the pre-built wheel for `version` cannot be used with the
  # resolved torch.  causal-conv1d wheels are compiled against a specific torch
  # major.minor ABI; wheels built against torch <= 2.8 are broken at runtime
  # against torch >= 2.9 (missing symbol c10::cuda::c10_cuda_check_implementation).
  #
  # When this returns false, concretise falls back to buildSource (if
  # allowBuildingFromSource = true) or throws with a clear message.
  canBuildBin = hldHelpers.canBuildBinFromVersionFiles ./binary-hashes;

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  #
  # mkOverlayInfo is injected by concretise from the validated HLD.
  # causal-conv1d wheels are generic across CUDA 12.x, so we always use "cu12".
  buildBin = { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    import ./overlay-bin.nix {
      overlayInfo = mkOverlayInfo { inherit pkgs cudaPackages version resolvedDeps; };
      cudaVersion = "cu12";
    };

  # ── Build from source ──────────────────────────────────────────────────────
  #
  # Called by concretise when canBuildBin returns false (pre-built wheel is
  # ABI-incompatible with the resolved torch) and allowBuildingFromSource = true.
  buildSource = { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      v = hldHelpers.requireSourceHash
            "causal-conv1d" "pkgs/causal-conv1d" ./source-hashes
            { inherit version cudaLabel; };
    in
    import ./overlay-source.nix {
      overlayInfo = mkOverlayInfo { inherit pkgs cudaPackages resolvedDeps; version = v; };
    };
}
