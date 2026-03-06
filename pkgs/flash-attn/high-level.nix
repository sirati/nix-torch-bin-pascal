# High-level derivation for flash-attention.
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# flash-attn depends on torch at the high level.  When concretised, the
# resolved concrete torch derivation is available via resolvedDeps."torch".
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.
# No manual import of hld-helpers.nix is needed here.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     mlPackages = with pp; [ flash-attn ];  # torch is implied automatically
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
  # pname differs from the HLD directory name ("flash-attn") — the PyPI
  # package is named "flash-attention".  nixpkgsAttr equals packageName
  # and is filled in automatically by hld-type.nix validate.
  # mkChangelog and mkOverlayInfo are auto-derived for "github-releases" origin.
  pname    = "flash-attention";
  srcOwner = "Dao-AILab";
  srcRepo  = "flash-attention";

  # ── Binary availability ────────────────────────────────────────────────────
  getVersions = hldHelpers.getVersionsFromVersionFiles ./binary-hashes;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = { inherit torch; };

  # ── ABI compatibility check ────────────────────────────────────────────────
  canBuildBin = hldHelpers.canBuildBinFromVersionFiles ./binary-hashes;

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  #
  # mkOverlayInfo is injected by concretise from the validated HLD.
  # flash-attn wheels are generic across CUDA 12.x, so we always use "cu12".
  buildBin = { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    import ./overlay-bin.nix {
      overlayInfo = mkOverlayInfo { inherit pkgs cudaPackages version resolvedDeps; };
      cudaVersion = "cu12";
    };

  # ── Build from source ──────────────────────────────────────────────────────
  #
  # Called by concretise when canBuildBin returns false (torch is newer than
  # the highest compat key in the binary-hashes file) and
  # allowBuildingFromSource = true.
  buildSource = { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      v = hldHelpers.requireSourceHash
            "flash-attn" "pkgs/flash-attn" ./source-hashes
            { inherit version cudaLabel; };
    in
    import ./overlay-source.nix {
      overlayInfo = mkOverlayInfo { inherit pkgs cudaPackages resolvedDeps; version = v; };
    };
}
