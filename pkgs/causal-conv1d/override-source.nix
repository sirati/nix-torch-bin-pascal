# causal-conv1d source build derivation.
#
# Compiles causal-conv1d from source against the supplied torch derivation and
# CUDA package set.  Used by high-level.nix buildSource when no pre-built wheel
# is ABI-compatible with the resolved torch version (e.g. torch >= 2.9 with a
# causal-conv1d that only has wheels built against torch <= 2.8).
#
# The build mirrors the nixpkgs causal-conv1d derivation (CUDA path only) but
# substitutes our custom torch binary wheel in place of the nixpkgs torch.
#
# Arguments:
#   pkgs                 - nixpkgs package set; pkgs.python3 must be the target
#                          Python interpreter (set by concretise via pkgsForBuild)
#   torch                - the concrete torch derivation from resolvedDeps."torch"
#   cudaPackages         - CUDA package set (already configured for Pascal or
#                          vanilla by concretise)
#   wrappers             - retry-wrapper derivation (nvcc/gcc wrapped with retry
#                          logic); injected at the front of PATH during compilation
#   causalConv1dVersion  - version string to build, e.g. "1.6.0"

{ pkgs
, torch
, cudaPackages
, wrappers
, causalConv1dVersion
}:

let
  inherit (pkgs) lib;

  srcInfo = import (./source-hashes + "/v${causalConv1dVersion}.nix");

  srcOwner = srcInfo.owner or "Dao-AILab";
  srcRepo  = srcInfo.repo  or "causal-conv1d";

in
pkgs.python3Packages.buildPythonPackage {
  pname   = "causal-conv1d";
  version = causalConv1dVersion;

  # PEP 517 / pyproject-based build (setup.py is invoked via setuptools backend)
  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = srcOwner;
    repo  = srcRepo;
    inherit (srcInfo) rev hash;
  };

  # Build-time Python dependencies.  torch is included here because setup.py
  # imports it to locate the PyTorch extension headers and CUDA include paths.
  build-system = [
    pkgs.python3Packages.setuptools
    pkgs.ninja
    torch
  ];

  nativeBuildInputs = [
    pkgs.which
    # cuda_nvcc provides the nvcc compiler and its companion tools (cicc,
    # ptxas, fatbinary, cudafe++).  wrappers shadows these with retry-wrapped
    # versions; put wrappers first in PATH via preConfigure/preBuild below.
    cudaPackages.cuda_nvcc
    wrappers
  ];

  buildInputs = with cudaPackages; [
    cuda_cudart   # cuda_runtime.h, -lcudart
    cuda_cccl     # thrust / cub headers
    libcusparse   # cusparse.h
    libcusolver   # cusolverDn.h
    libcublas     # cublas_v2.h, -lcublas
  ];

  # Runtime Python dependency: only torch is needed at import time.
  dependencies = [ torch ];

  env = {
    # Force compilation even though upstream's setup.py checks for a pre-built
    # wheel in the dist/ directory first.
    CAUSAL_CONV1D_FORCE_BUILD = "TRUE";

    # Tell the extension build system where the CUDA toolkit headers and nvcc
    # live.  lib.getDev extracts the "dev" output (headers + pkg-config).
    CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}";
  };

  # Place retry wrappers at the very front of PATH so the wrapped nvcc/gcc are
  # picked up before the bare versions that come from nativeBuildInputs.
  preConfigure = ''
    export PATH="${wrappers}/bin:$PATH"
  '';

  preBuild = ''
    export PATH="${wrappers}/bin:$PATH"
  '';

  # No upstream test suite that can run without a GPU.
  doCheck = false;

  pythonImportsCheck = [ "causal_conv1d" ];

  meta = {
    description = "Efficient causal 1D convolution for autoregressive models (built from source)";
    homepage    = "https://github.com/Dao-AILab/causal-conv1d";
    changelog   = "https://github.com/Dao-AILab/causal-conv1d/releases/tag/v${causalConv1dVersion}";
    license     = lib.licenses.bsd3;
    platforms   = [ "x86_64-linux" "aarch64-linux" ];
    # Requires CUDA; will not build on non-CUDA stdenv.
    broken      = false;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
