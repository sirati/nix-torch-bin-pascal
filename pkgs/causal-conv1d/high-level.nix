# High-level derivation for causal-conv1d.
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# causal-conv1d depends on torch at the high level.  When concretised, the
# resolved concrete torch derivation is available via resolvedDeps."torch".
#
# hldHelpers and mkHLD are injected automatically by pkgs/default.nix.
# No manual import of hld-helpers.nix is needed here.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     packages = with pp; [ "causal-conv1d" ];  # torch is implied automatically
#     python   = "3.13";
#     cuda     = "12.6";
#   };

{ torch, hldHelpers }:

# Fail early if the caller passed something other than a high-level derivation.
assert hldHelpers.isHLD torch;

{
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
  #
  # We always use cu12 here because causal-conv1d binary wheels only ship a
  # single cu12 variant regardless of the specific CUDA 12.x sub-version.
  canBuildBin = { resolvedDeps, version, cudaLabel, ... }:
    let
      torchVersion = resolvedDeps."torch".version;

      # Extract "major.minor" from a full version string like "2.10.0" or "2.9.1".
      # builtins.match returns a list of capture groups or null on no match.
      mm = builtins.match "([0-9]+[.][0-9]+).*" torchVersion;
      torchMajorMinor = builtins.elemAt mm 0;

      # Load the compat keys that have pre-built wheels for this version.
      versionData    = (import (./binary-hashes + "/v${version}.nix")).cu12;
      availableCompat = builtins.attrNames versionData;

      # Determine the highest compat key using Nix's built-in numeric version
      # comparison (compareVersions handles "2.10" > "2.9" correctly).
      sortedCompat = builtins.sort
        (a: b: builtins.compareVersions a b < 0)
        availableCompat;
      maxCompat = builtins.elemAt sortedCompat (builtins.length sortedCompat - 1);
    in
    # The binary is compatible iff the resolved torch major.minor does not
    # exceed the highest compat key in the hash file.
    builtins.compareVersions torchMajorMinor maxCompat <= 0;

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
  #
  # Called by concretise when canBuildBin returns false (pre-built wheel is
  # ABI-incompatible with the resolved torch) and allowBuildingFromSource = true.
  # Also called when no binary version exists at all (version may be non-null
  # when the binary is ABI-incompatible, or null if no hash file exists).
  buildSource = { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version }:
    let
      v = if version != null then version else throw (
        "causal-conv1d buildSource: version is null — no binary-hashes entry "
        + "exists for cudaLabel '${cudaLabel}'.  Add a source-hashes.nix entry "
        + "and a binary-hashes file for this version."
      );
      sourceHashPath = ./source-hashes + "/v${v}.nix";
    in
    if !builtins.pathExists sourceHashPath
    then throw (
      "causal-conv1d buildSource: source-hashes/v${v}.nix does not exist. "
      + "Run: nix-shell pkgs/causal-conv1d/generate-hashes.py -- "
      + "--source-only --tag v${v}"
    )
    else
    import ./override-source.nix {
      inherit pkgs cudaPackages wrappers;
      torch               = resolvedDeps."torch";
      causalConv1dVersion = v;
    };
}
