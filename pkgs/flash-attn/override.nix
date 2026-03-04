# flash-attn-bin: pre-built wheel derivation for flash-attention.
#
# This replaces the from-source nixpkgs flash-attn with a pre-built binary
# wheel from the official GitHub releases, avoiding the multi-hour CUDA build.
#
# The wheel selection is automatic:
#   - Torch major.minor version is extracted from the `torch` argument.
#   - The highest available compat key that is <= the torch version is chosen
#     (flash-attn wheels are generally ABI-compatible with later torch minor
#     releases of the same major version).
#   - Python version and platform are detected from pkgs.python3 / stdenv.
#
# cxx11abi handling:
#   The default is "TRUE" (new C++11 ABI), matching the standard PyTorch pip
#   wheels on Linux.  Pass cxx11abi = "FALSE" only if you are using a PyTorch
#   build compiled with -D_GLIBCXX_USE_CXX11_ABI=0 (old / pre-cxx11 ABI).
#   When cxx11abi = "FALSE" the wheel is taken from the `precx11abi` attribute
#   of the leaf node; if that attribute is absent no pre-built wheel exists for
#   the requested platform and an evaluation error is raised.
#
# Note: Python 3.14 (py314) is not available in flash-attn 2.8.3 pre-built
#       wheels; attempting to use it will raise an error at evaluation time.
#
# Arguments:
#   pkgs              - nixpkgs package set (pkgs.python3 must be the target Python)
#   torch             - the torch derivation to depend on
#   flashAttnVersion  - flash-attention version string (default: "2.8.3")
#   cudaVersion       - CUDA version the wheel was compiled against (default: "cu12")
#                       Used as the top-level key in binary-hashes/v{version}.nix.
#                       Typical values: "cu12", "cu126", "cu128".
#   cxx11abi          - "TRUE" or "FALSE" (default: "TRUE", matching standard
#                       PyTorch pip wheels on Linux)

{ pkgs
, torch
, flashAttnVersion ? "2.8.3"
, cudaVersion      ? "cu12"
, cxx11abi         ? "TRUE"
}:

let
  inherit (pkgs) lib;
  wheelHelpers = import ../../wheel-helpers.nix { inherit pkgs; };
in
wheelHelpers.buildBinWheel {
  pname            = "flash-attn";
  version          = flashAttnVersion;
  binaryHashesFile = ./binary-hashes + "/v${flashAttnVersion}.nix";
  inherit torch cudaVersion cxx11abi;

  extraDependencies  = [ pkgs.python3Packages.einops ];
  pythonImportsCheck = [ "flash_attn" ];

  meta = {
    description      = "Official implementation of FlashAttention and FlashAttention-2 (pre-built wheel)";
    homepage         = "https://github.com/Dao-AILab/flash-attention/";
    changelog        = "https://github.com/Dao-AILab/flash-attention/releases/tag/v${flashAttnVersion}";
    license          = lib.licenses.bsd3;
    platforms        = [ "x86_64-linux" "aarch64-linux" ];
    broken           = false;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
