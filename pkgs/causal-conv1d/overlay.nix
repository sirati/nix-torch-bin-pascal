# causal-conv1d binary wheel derivation — thin wrapper around buildBinWheel.
#
# Installs a pre-built causal-conv1d wheel from the official GitHub releases,
# avoiding the CUDA compilation step.  Used by high-level.nix buildBin when
# a pre-built wheel is ABI-compatible with the resolved torch version.
#
# Arguments:
#   overlayInfo  - common package context attrset from high-level.nix
#                  (pkgs, cudaPackages, version, pname, srcOwner, srcRepo,
#                   basePkg, changelog, torch)
#   cudaVersion  - top-level key in binary-hashes/v{version}.nix (default: "cu12")
#   cxx11abi     - "TRUE" or "FALSE" (default: "TRUE", matching standard
#                  PyTorch pip wheels on Linux)

{ overlayInfo
, cudaVersion ? "cu12"
, cxx11abi    ? "TRUE"
}:

let
  wheelHelpers = import ../../wheel-helpers.nix;
in
wheelHelpers.buildBinWheel {
  inherit overlayInfo cudaVersion cxx11abi;
  binaryHashesDir = ./binary-hashes;
  # pythonImportsCheck: default derives "causal_conv1d" from pname — correct.
}
