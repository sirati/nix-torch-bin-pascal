# sonic-moe source build derivation — thin wrapper around buildSourcePackage.
#
# Pure-Python build (cudaSupport = false): all GPU kernels come from
# quack-kernels/CuTeDSL and are JIT-compiled at runtime, so no nvcc / CUDA
# libs are needed at build time.
#
# Arguments:
#   overlayInfo         - common package context attrset from high-level.nix
#   quack-kernels       - resolved quack-kernels derivation
#   nvidia-cutlass-dsl  - resolved CuTeDSL derivation

{ overlayInfo, quack-kernels, nvidia-cutlass-dsl }:

let
  buildSourcePackage =
    (import ../../concretise/source-build-helpers.nix).buildSourcePackage;
in
buildSourcePackage {
  inherit overlayInfo;
  sourceHashesDir = ./source-hashes;

  cudaSupport = false;

  # Strip upstream's torch version ceiling (e.g. "torch>=2.7.1,<=2.9.1" →
  # "torch>=2.7.1") and turn its exact CuTeDSL pin ("nvidia-cutlass-dsl==4.4.2")
  # into a floor: sonic-moe never touches the torch C++ ABI, its kernels are
  # JIT-compiled by the DSL, and newer torch / DSL releases were verified
  # working (see high-level.nix).  Without this, pythonRuntimeDepsCheck
  # rejects the build against torch > 2.9.1 or any other DSL release.
  # Each sed is a no-op if a future version drops/renames the pin — the
  # runtime-deps check then fails loudly, flagging that this needs a revisit.
  postPatch = ''
    sed -i -E 's/"torch>=([0-9.]+),<=[0-9.]+"/"torch>=\1"/' pyproject.toml
    sed -i -E 's/"nvidia-cutlass-dsl==([0-9.]+)"/"nvidia-cutlass-dsl>=\1"/' pyproject.toml
  '';

  extraDependencies = [
    quack-kernels
    nvidia-cutlass-dsl
  ];

  # pname "sonic-moe" but the importable module is "sonicmoe".
  # site-aware: importing sonicmoe pulls in cutlass, whose .pth-redirect
  # layout is invisible to the plain-PYTHONPATH pythonImportsCheck hook.
  pythonImportsCheck = [ "sonicmoe" ];
  siteAwareImportsCheck = true;
}
