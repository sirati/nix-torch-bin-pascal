# mamba-ssm-bin: pre-built wheel derivation for mamba-ssm.
#
# This replaces the from-source nixpkgs mamba-ssm with a pre-built binary
# wheel from the official GitHub releases, avoiding the CUDA compilation step.
#
# The wheel selection is automatic:
#   - Torch major.minor version is extracted from the `torch` argument.
#   - The highest available compat key that is <= the torch version is chosen
#     (mamba-ssm wheels are generally ABI-compatible with later torch minor
#     releases of the same major version, up to the highest compat key).
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
# Arguments:
#   pkgs          - nixpkgs package set (pkgs.python3 must be the target Python)
#   torch         - the torch derivation to depend on
#   causal-conv1d - the causal-conv1d derivation to depend on
#   mambaVersion  - mamba-ssm version string (default: "2.3.0")
#   cudaVersion   - CUDA version the wheel was compiled against (default: "cu12")
#                   Used as the top-level key in binary-hashes/v{version}.nix.
#                   Typical values: "cu11", "cu12", "cu13".
#   cxx11abi      - "TRUE" or "FALSE" (default: "TRUE", matching standard
#                   PyTorch pip wheels on Linux)

{ pkgs
, torch
, causal-conv1d
, mambaVersion ? "2.3.0"
, cudaVersion  ? "cu12"
, cxx11abi     ? "TRUE"
}:

let
  inherit (pkgs) lib;
  wheelHelpers = import ../../wheel-helpers.nix { inherit pkgs; };
in
wheelHelpers.buildBinWheel {
  pname            = "mamba-ssm";
  version          = mambaVersion;
  binaryHashesFile = ./binary-hashes + "/v${mambaVersion}.nix";
  inherit torch cudaVersion cxx11abi;

  # mamba-ssm depends on causal-conv1d, einops, and transformers
  extraDependencies = with pkgs.python3Packages; [
    causal-conv1d
    einops
    transformers
  ];

  pythonImportsCheck = [ "mamba_ssm" ];

  meta = {
    description      = "Mamba state space model (pre-built wheel)";
    homepage         = "https://github.com/state-spaces/mamba";
    changelog        = "https://github.com/state-spaces/mamba/releases/tag/v${mambaVersion}";
    license          = lib.licenses.asl20;
    platforms        = [ "x86_64-linux" "aarch64-linux" ];
    broken           = false;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
