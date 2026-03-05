# flash-attn source build derivation — thin wrapper around buildSourcePackage.
#
# Compiles flash-attention from source against the supplied torch derivation and
# CUDA package set.  Used by high-level.nix buildSource when no pre-built wheel
# is ABI-compatible with the resolved torch version.
#
# Arguments:
#   pkgs        - nixpkgs package set; pkgs.python3 must be the target
#                 Python interpreter (set by concretise via pkgsForBuild)
#   torch       - the concrete torch derivation from resolvedDeps."torch"
#   cudaPackages - CUDA package set (already configured for Pascal or
#                  vanilla by concretise)
#   version     - version string to build, e.g. "2.8.3"
#   pname       - Python package name, passed from high-level.nix
#   srcOwner    - GitHub owner, passed from high-level.nix
#   srcRepo     - GitHub repo, passed from high-level.nix
#   basePkg     - upstream nixpkgs derivation for meta inheritance (may be null)
#   changelog   - changelog URL for this version (may be null)

{ pkgs
, torch
, cudaPackages
, version
, pname
, srcOwner
, srcRepo
, basePkg   ? null
, changelog ? null
}:

let
  inherit (pkgs) lib;
  inherit (cudaPackages) backendStdenv;

  buildSourcePackage =
    (import ../../concretise/source-build-helpers.nix { inherit pkgs; }).buildSourcePackage;

  srcInfo = import (./source-hashes + "/v${version}.nix");

  # TORCH_CUDA_ARCH_LIST: semicolon-separated CUDA compute capabilities.
  # Read from cudaPackages.flags.cudaCapabilities (nixpkgs CUDA infrastructure).
  cudaCapabilities = cudaPackages.flags.cudaCapabilities;

in
buildSourcePackage {
  inherit pname version torch cudaPackages basePkg changelog;

  srcOwner = srcInfo.owner or srcOwner;
  srcRepo  = srcInfo.repo  or srcRepo;
  inherit srcInfo;

  # flash-attn bundles cutlass and other dependencies as git submodules.
  fetchSubmodules = true;

  preConfigure = ''
    export MAX_JOBS="$NIX_BUILD_CORES"
    export NVCC_THREADS="$NIX_BUILD_CORES"
  '';

  # flash-attn does not list torch in [build-system] requires, so no postPatch
  # is needed to strip it.

  # psutil is used by flash-attn's setup.py to detect available CPU cores.
  extraBuildSystemPackages = [ pkgs.python3Packages.psutil ];

  # curand is required by flash-attn but not by causal-conv1d / mamba-ssm.
  extraBuildInputs = [ cudaPackages.libcurand ];

  extraDependencies = [ pkgs.python3Packages.einops ];

  # flash-attn uses CC/CXX/TORCH_CUDA_ARCH_LIST rather than CUDA_HOME +
  # FORCE_BUILD.  Disable the defaults and pass the flash-attn-specific vars.
  useCudaHome      = false;
  forceBuildEnvVar = null;
  extraEnv = {
    FLASH_ATTENTION_SKIP_CUDA_BUILD = "FALSE";
    CC  = "${backendStdenv.cc}/bin/cc";
    CXX = "${backendStdenv.cc}/bin/c++";
    TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" cudaCapabilities;
  };

  # pythonImportsCheck: pname is "flash-attention", which would derive
  # "flash_attention" — incorrect.  Override explicitly.
  pythonImportsCheck = [ "flash_attn" ];
}
