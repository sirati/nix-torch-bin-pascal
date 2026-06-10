# quack-kernels source build derivation — thin wrapper around buildSourcePackage.
#
# Pure-Python build (cudaSupport = false): the CuTeDSL kernels are
# JIT-compiled at runtime, so no nvcc / CUDA libs are needed at build time.
#
# Arguments:
#   overlayInfo         - common package context attrset from high-level.nix
#   nvidia-cutlass-dsl  - resolved CuTeDSL derivation
#   apache-tvm-ffi      - resolved tvm-ffi derivation
#   torch-c-dlpack-ext  - resolved dlpack-ext derivation

{ overlayInfo, nvidia-cutlass-dsl, apache-tvm-ffi, torch-c-dlpack-ext }:

let
  buildSourcePackage =
    (import ../../concretise/source-build-helpers.nix).buildSourcePackage;
in
buildSourcePackage {
  inherit overlayInfo;
  sourceHashesDir = ./source-hashes;

  cudaSupport = false;

  extraDependencies = [
    nvidia-cutlass-dsl
    apache-tvm-ffi
    torch-c-dlpack-ext
    # einops is a plain nixpkgs Python package (required since quack 0.4.0;
    # harmless for older versions).
    overlayInfo.pkgs.python3Packages.einops
  ];

  # pname "quack-kernels" but the importable module is "quack".
  # site-aware: importing quack pulls in cutlass, whose .pth-redirect layout
  # is invisible to the plain-PYTHONPATH pythonImportsCheck hook.
  pythonImportsCheck = [ "quack" ];
  siteAwareImportsCheck = true;
}
