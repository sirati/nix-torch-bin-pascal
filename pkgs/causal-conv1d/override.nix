# causal-conv1d-bin: pre-built wheel derivation for causal-conv1d.
#
# This replaces the from-source nixpkgs causal-conv1d with a pre-built binary
# wheel from the official GitHub releases, avoiding the CUDA compilation step.
#
# The wheel selection is automatic:
#   - Torch major.minor version is extracted from the `torch` argument.
#   - The highest available compat key that is <= the torch version is chosen
#     (causal-conv1d wheels are generally ABI-compatible with later torch minor
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
# Note: causal-conv1d 1.6.0 pre-built wheels are only available up to torch
#       2.8.x.  For torch >= 2.9, concretise will route to buildSource instead
#       (when allowBuildingFromSource = true).  This file is only invoked when
#       canBuildBin returns true.
#
# Arguments:
#   pkgs        - nixpkgs package set (pkgs.python3 must be the target Python)
#   torch       - the torch derivation to depend on
#   pname       - Python package name, passed from high-level.nix
#   version     - causal-conv1d version string
#   basePkg     - upstream nixpkgs derivation for meta inheritance (may be null)
#   changelog   - changelog URL for this version (may be null)
#   cudaVersion - CUDA version the wheel was compiled against (default: "cu12")
#   cxx11abi    - "TRUE" or "FALSE" (default: "TRUE", matching standard
#                 PyTorch pip wheels on Linux)

{ pkgs
, torch
, pname
, version
, basePkg    ? null
, changelog  ? null
, cudaVersion ? "cu12"
, cxx11abi   ? "TRUE"
}:

let
  wheelHelpers = import ../../wheel-helpers.nix { inherit pkgs; };
in
wheelHelpers.buildBinWheel {
  inherit pname version torch cudaVersion cxx11abi basePkg changelog;
  binaryHashesFile = ./binary-hashes + "/v${version}.nix";
}
