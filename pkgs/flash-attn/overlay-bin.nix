# flash-attn binary wheel derivation — thin wrapper around buildBinWheel.
#
# Installs a pre-built flash-attention wheel from the official GitHub releases,
# avoiding the multi-hour CUDA compilation step.  Used by high-level.nix buildBin
# when a pre-built wheel is ABI-compatible with the resolved torch version.
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
  inherit (overlayInfo) pkgs;
in
wheelHelpers.buildBinWheel {
  inherit overlayInfo cudaVersion cxx11abi;
  binaryHashesDir    = ./binary-hashes;
  extraDependencies  = [ pkgs.python3Packages.einops ];
  # pythonImportsCheck: pname is "flash-attention", which would derive
  # "flash_attention" — incorrect.  Override explicitly.
  pythonImportsCheck = [ "flash_attn" ];
}
