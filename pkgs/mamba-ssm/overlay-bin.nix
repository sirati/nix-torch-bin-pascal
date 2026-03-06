# mamba-ssm binary wheel derivation — thin wrapper around buildBinWheel.
#
# Installs a pre-built mamba-ssm wheel from the official GitHub releases,
# avoiding the CUDA compilation step.  Used by high-level.nix buildBin when
# a pre-built wheel is ABI-compatible with the resolved torch version.
#
# Arguments:
#   overlayInfo   - common package context attrset from high-level.nix
#                   (pkgs, cudaPackages, version, pname, srcOwner, srcRepo,
#                    basePkg, changelog, torch)
#   causal-conv1d - the concrete causal-conv1d derivation from resolvedDeps
#   cudaVersion   - top-level key in binary-hashes/v{version}.nix (default: "cu12")
#   cxx11abi      - "TRUE" or "FALSE" (default: "TRUE", matching standard
#                   PyTorch pip wheels on Linux)

{ overlayInfo
, causal-conv1d
, cudaVersion ? "cu12"
, cxx11abi    ? "TRUE"
}:

let
  wheelHelpers = import ../../wheel-helpers.nix;
  inherit (overlayInfo) pkgs;
in
wheelHelpers.buildBinWheel {
  inherit overlayInfo cudaVersion cxx11abi;
  binaryHashesDir = ./binary-hashes;

  # mamba-ssm depends on causal-conv1d (from resolvedDeps), einops, and transformers.
  # causal-conv1d must NOT come from pkgs.python3Packages — it must be the
  # concretised derivation passed as an argument to avoid store-path conflicts.
  extraDependencies = [
    causal-conv1d
    pkgs.python3Packages.einops
    pkgs.python3Packages.transformers
  ];
}
