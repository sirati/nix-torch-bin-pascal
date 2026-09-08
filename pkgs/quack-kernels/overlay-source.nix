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

  # CuTeDSL 4.6 moved ThrMma / ThrCopy out of `cutlass.cute.core`; quack
  # < 0.5 still annotates with `cute.core.ThrMma` / `cute.core.ThrCopy`
  # (evaluated at import time) and so cannot import on newer DSLs.  Both
  # names have been exported at `cutlass.cute` level since 4.4, which is
  # what quack itself uses from 0.6 on — rewrite the annotations to that
  # spelling.  A no-op for versions that already use it.
  #
  # quack <= 0.4.x selects an old `nvvm.atomicrmw(res=..., ...)` spelling when
  # the DSL reports CUDA 12.9; CuTeDSL 4.8 dropped the `res` keyword (the
  # result type is inferred), so the 12.9 branch raises `TypeError` in every
  # kernel using `atomic_add_i32` / `atomic_inc_i32` (the sonic-moe backward).
  # Force the inferred-result spelling: the branch predicate becomes False.
  postPatch = ''
    sed -i -E 's/\bcute\.core\.(ThrMma|ThrCopy|TiledMma|TiledCopy)\b/cute.\1/g' quack/*.py
    sed -i 's/CUDA_VERSION\.major == 12 and CUDA_VERSION\.minor == 9/False/g' quack/utils.py
  '';

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
