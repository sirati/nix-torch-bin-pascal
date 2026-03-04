# High-level derivation for flash-attention.
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# flash-attn depends on torch at the high level.  When concretised, the
# resolved concrete torch derivation is available via resolvedDeps."torch".
#
# hldHelpers and mkHLD are injected automatically by pkgs/default.nix.
# No manual import of hld-helpers.nix is needed here.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     packages = with pp; [ "flash-attn" ];  # torch is implied automatically
#     python   = "3.13";
#     cuda     = "12.6";
#   };

{ torch, hldHelpers }:

# Fail early if the caller passed something other than a high-level derivation.
assert hldHelpers.isHLD torch;

{
  # ── Binary availability ────────────────────────────────────────────────────
  # flash-attn uses per-version files: binary-hashes/v{version}.nix
  # Each file is a plain attrset keyed by cudaVersion label.
  # The generic "cu12" key covers all CUDA 12.x variants.
  getVersions = hldHelpers.getVersionsFromVersionFiles ./binary-hashes;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = { inherit torch; };

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  #
  # Received from concretise:
  #   { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version }
  #
  # flash-attn wheels are generic across CUDA 12.x, so we always use "cu12"
  # as the cudaVersion passed to override.nix regardless of cudaLabel.
  buildBin = { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version }:
    import ./override.nix {
      inherit pkgs;
      torch            = resolvedDeps."torch";
      flashAttnVersion = version;
      cudaVersion      = "cu12";
      # cxx11abi defaults to "TRUE" in override.nix, matching standard pip wheels
    };

  # ── Build from source ──────────────────────────────────────────────────────
  buildSource = { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version }:
    throw "flash-attn/high-level.nix: buildSource is not yet implemented";
}
