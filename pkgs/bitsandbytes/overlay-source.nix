# bitsandbytes source build derivation.
#
# Compiles bitsandbytes from source against the supplied torch derivation and
# CUDA package set.  bitsandbytes uses CMake (via scikit-build-core/setuptools)
# to compile CUDA kernels, so the build is heavier than a simple setuptools
# package but lighter than flash-attn (no submodules needed).
#
# Arguments:
#   overlayInfo  - common package context attrset from high-level.nix
#                  (pkgs, cudaPackages, version, pname, srcOwner, srcRepo,
#                   basePkg, changelog, torch)

{ overlayInfo }:

let
  buildSourcePackage =
    (import ../../concretise/source-build-helpers.nix).buildSourcePackage;

  inherit (overlayInfo) pkgs cudaPackages;
  inherit (pkgs) lib;

  # cudaPackages.flags.cudaCapabilities provides the list of CUDA compute
  # capabilities (e.g. ["6.0" "7.0" "8.0" "9.0"]).  The flags attrset is
  # the standard nixpkgs CUDA infrastructure entry point.
  cudaCapabilities = cudaPackages.flags.cudaCapabilities;

  # Convert "8.0" → "80" for CMake's COMPUTE_CAPABILITY and nvcc gencode flags.
  cudaArchList = map (cap: lib.replaceStrings ["."] [""] cap) cudaCapabilities;
in
buildSourcePackage {
  inherit overlayInfo;
  sourceHashesDir = ./source-hashes;

  # bitsandbytes uses CMake as its build backend (via scikit-build-core).
  # The shared buildSourcePackage already provides setuptools + ninja +
  # cuda_nvcc; we add cmake here.
  extraBuildSystemPackages = [
    pkgs.cmake
    pkgs.python3Packages.scikit-build-core
    pkgs.python3Packages.trove-classifiers
  ];

  # bitsandbytes needs libcusolver in addition to the standard set provided
  # by buildSourcePackage (cuda_cudart, cuda_cccl, libcusparse, libcusolver,
  # libcublas).  libcusolver is already in the standard set, so no extra
  # buildInputs are needed.

  extraDependencies = [
    pkgs.python3Packages.scipy
    pkgs.python3Packages.nvidia-ml-py
    pkgs.python3Packages.packaging
  ];

  # bitsandbytes does not use FORCE_BUILD; it uses CMake flags instead.
  forceBuildEnvVar = null;

  # CUDA_HOME is needed for CMake to find the CUDA toolkit.
  useCudaHome = true;

  extraEnv = {
    # CMake needs the CUDA compiler and compute capabilities.
    NVCC_PREPEND_FLAGS = lib.concatStringsSep " " (
      lib.concatMap (arch: [
        "-gencode"
        "arch=compute_${arch},code=sm_${arch}"
      ]) cudaArchList
    );
  };

  # bitsandbytes uses dontUseCmakeBuildDir-style in-tree CMake build.
  # The shared buildSourcePackage sets pyproject = true, which works with
  # scikit-build-core's CMake integration.  We pass CMake flags via
  # preConfigure since buildSourcePackage does not have a cmakeFlags option.
  preConfigure = ''
    export CMAKE_ARGS="-DCOMPUTE_BACKEND=cuda \
      -DBUILD_CUDA=ON \
      -DHIP_PLATFORM=OFF \
      -DCUDA_TOOLKIT_ROOT_DIR=${lib.getLib cudaPackages.cuda_nvcc} \
      -DCMAKE_CUDA_COMPILER=${lib.getExe cudaPackages.cuda_nvcc} \
      -DCOMPUTE_CAPABILITY=${builtins.concatStringsSep ";" cudaArchList}"
    export dontUseCmakeBuildDir=1
  '';
}
