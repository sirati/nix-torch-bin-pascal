# High-level derivation for mamba-ssm.
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# mamba-ssm depends on torch and causal-conv1d at the high level.  When
# concretised, the resolved concrete derivations are available via
# resolvedDeps."torch" and resolvedDeps."causal-conv1d".
#
# hldHelpers is injected automatically by pkgs/default.nix.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     packages = with pp; [ "mamba-ssm" ];  # torch and causal-conv1d implied
#     python   = "3.13";
#     cuda     = "12.6";
#   };

{ torch, causal-conv1d, hldHelpers }:

# Fail early if the caller passed something other than high-level derivations.
assert hldHelpers.isHLD torch;
assert hldHelpers.isHLD causal-conv1d;

{
  # ── Binary availability ────────────────────────────────────────────────────
  # mamba-ssm uses per-version files: binary-hashes/v{version}.nix
  # Each file is a plain attrset keyed by cudaVersion label.
  # The generic "cu12" key covers all CUDA 12.x variants.
  getVersions = hldHelpers.getVersionsFromVersionFiles ./binary-hashes;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = {
    inherit torch causal-conv1d;
  };

  # ── ABI compatibility check ────────────────────────────────────────────────
  #
  # Returns false when the pre-built wheel for `version` is unlikely to be
  # ABI-compatible with the resolved torch.  We determine this by comparing
  # the resolved torch major.minor against the highest torch-compat key present
  # in the binary-hashes file (across all Python versions).  When torch is
  # strictly newer than the highest compat key we have wheels for, we fall back
  # to a source build.
  canBuildBin = { resolvedDeps, version, cudaLabel, ... }:
    let
      torchVersion    = resolvedDeps."torch".version;
      mm              = builtins.match "([0-9]+[.][0-9]+).*" torchVersion;
      torchMajorMinor = builtins.elemAt mm 0;

      # Load the full binary-hashes file for this version.
      # Prefer the exact cudaLabel, fall back to the generic "cu12" key.
      versionFile = import (./binary-hashes + "/v${version}.nix");
      cudaSection =
        if      builtins.hasAttr cudaLabel versionFile then versionFile.${cudaLabel}
        else if builtins.hasAttr "cu12"    versionFile then versionFile."cu12"
        else {};

      availableCompat = builtins.attrNames cudaSection;

      sortedCompat = builtins.sort
        (a: b: builtins.compareVersions a b < 0)
        availableCompat;

      maxCompat = if sortedCompat == []
        then "0.0"
        else builtins.elemAt sortedCompat (builtins.length sortedCompat - 1);
    in
    # Binary is compatible iff the resolved torch major.minor does not exceed
    # the highest compat key we have a wheel for.
    builtins.compareVersions torchMajorMinor maxCompat <= 0;

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  #
  # Received from concretise:
  #   { pkgs, cudaPackages, cudaLabel, resolvedDeps, version }
  #
  # mamba-ssm wheels are generic across CUDA 12.x, so we always use "cu12"
  # as the cudaVersion passed to override.nix regardless of cudaLabel.
  buildBin = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      inherit (resolvedDeps) torch causal-conv1d;
    in
    import ./override.nix {
      inherit pkgs torch causal-conv1d;
      mambaVersion = version;
      cudaVersion  = "cu12";
      # cxx11abi defaults to "TRUE" in override.nix, matching standard pip wheels
    };

  # ── Build from source ──────────────────────────────────────────────────────
  #
  # Called by concretise when canBuildBin returns false (torch is newer than
  # the highest compat key in the binary-hashes file) and
  # allowBuildingFromSource = true.
  buildSource = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      v = if version != null then version else throw (
        "mamba-ssm buildSource: version is null — no binary-hashes entry "
        + "exists for cudaLabel '${cudaLabel}'.  Add a binary-hashes entry "
        + "for the desired version, or run generate-hashes.py to fetch it."
      );
      sourceHashPath = ./source-hashes + "/v${v}.nix";
    in
    if !builtins.pathExists sourceHashPath
    then throw (
      "mamba-ssm buildSource: source-hashes/v${v}.nix does not exist. "
      + "Run: nix-shell pkgs/mamba-ssm/generate-hashes.py -- "
      + "--source-only --tag v${v}"
    )
    else
    let
      inherit (resolvedDeps) torch causal-conv1d;
    in
    # (import ../../nix-retry-wrapper/inject-wrappers.nix wrappers)  # re-enable wrappers
    import ./override-source.nix {
      inherit pkgs cudaPackages torch causal-conv1d;
      mambaVersion = v;
    };
}
