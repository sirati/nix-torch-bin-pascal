# flash-attn source build derivation — thin wrapper around buildSourcePackage.
#
# Compiles flash-attention from source against the supplied torch derivation and
# CUDA package set.  Used by high-level.nix buildSource when no pre-built wheel
# is ABI-compatible with the resolved torch version.
#
# Arguments:
#   pkgs              - nixpkgs package set; pkgs.python3 must be the target
#                       Python interpreter (set by concretise via pkgsForBuild)
#   torch             - the concrete torch derivation from resolvedDeps."torch"
#   cudaPackages      - CUDA package set (already configured for Pascal or
#                       vanilla by concretise)
#   flashAttnVersion  - version string to build, e.g. "2.8.3"

{ pkgs
, torch
, cudaPackages
, flashAttnVersion
}:

let
  inherit (pkgs) lib;
  inherit (cudaPackages) backendStdenv;

  buildSourcePackage =
    (import ../../concretise/source-build-helpers.nix { inherit pkgs; }).buildSourcePackage;

  srcInfo  = import (./source-hashes + "/v${flashAttnVersion}.nix");
  srcOwner = srcInfo.owner or "Dao-AILab";
  srcRepo  = srcInfo.repo  or "flash-attention";

  # TORCH_CUDA_ARCH_LIST: semicolon-separated CUDA compute capabilities.
  # Read from cudaPackages.flags.cudaCapabilities (nixpkgs CUDA infrastructure).
  cudaCapabilities = cudaPackages.flags.cudaCapabilities;

in
buildSourcePackage {
  pname   = "flash-attention";
  version = flashAttnVersion;

  inherit srcInfo srcOwner srcRepo torch cudaPackages;

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

  pythonImportsCheck = [ "flash_attn" ];

  meta = {
    description      = "Official implementation of FlashAttention and FlashAttention-2 (built from source)";
    homepage         = "https://github.com/Dao-AILab/flash-attention/";
    changelog        = "https://github.com/Dao-AILab/flash-attention/releases/tag/${srcInfo.rev}";
    license          = lib.licenses.bsd3;
    platforms        = [ "x86_64-linux" "aarch64-linux" ];
    broken           = false;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
