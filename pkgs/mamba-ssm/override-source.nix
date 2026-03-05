# mamba-ssm source build derivation.
#
# Compiles mamba-ssm from source against the supplied torch derivation and
# CUDA package set.  Used by high-level.nix buildSource when no pre-built wheel
# is ABI-compatible with the resolved torch version (e.g. torch >= 2.7 with a
# mamba-ssm that only has wheels built against torch <= 2.6).
#
# The build mirrors the nixpkgs mamba-ssm derivation (CUDA path only) but
# substitutes our custom torch binary wheel in place of the nixpkgs torch.
#
# Arguments:
#   pkgs          - nixpkgs package set; pkgs.python3 must be the target
#                   Python interpreter (set by concretise via pkgsForBuild)
#   torch         - the concrete torch derivation from resolvedDeps."torch"
#   causal-conv1d - the concrete causal-conv1d derivation from resolvedDeps."causal-conv1d"
#   cudaPackages  - CUDA package set (already configured for Pascal or
#                   vanilla by concretise)
#   mambaVersion  - version string to build, e.g. "2.3.0"

{ pkgs
, torch
, causal-conv1d
, cudaPackages
, mambaVersion
}:

let
  inherit (pkgs) lib;

  srcInfo = import (./source-hashes + "/v${mambaVersion}.nix");

  srcOwner = srcInfo.owner or "state-spaces";
  srcRepo  = srcInfo.repo  or "mamba";

in
pkgs.python3Packages.buildPythonPackage {
  pname   = "mamba-ssm";
  version = mambaVersion;

  # PEP 517 / pyproject-based build (setup.py is invoked via setuptools backend)
  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = srcOwner;
    repo  = srcRepo;
    inherit (srcInfo) rev hash;
    # mamba has no git submodules
  };

  # The upstream pyproject.toml lists torch under [build-system] requires.
  # Our torch derivation is the real PyPI binary wheel whose dist-info carries
  # every nvidia-* sub-package as a pip dependency.  pypa/build (even with
  # --no-isolation) checks the declared build-system.requires transitively,
  # finds the nvidia-* packages are not pip-installed in the Nix sandbox, and
  # aborts with "ERROR Missing dependencies".
  #
  # Fix: strip torch out of [build-system] requires so pypa/build never tries
  # to verify its pip-level transitive deps.  Torch is still fully importable
  # at build time via the `dependencies` propagatedBuildInput + --no-isolation.
  #
  # We delete the whole line rather than replacing the string with "" because
  # pyproject.toml has "torch" as a standalone comma-terminated array element
  # (e.g. `    "torch",`).  Replacing just the quoted string leaves `    ,`
  # which is invalid TOML (empty array element).  sed removes the full line.
  # The pattern anchors on leading whitespace + `"torch"` + trailing comma so
  # it does not accidentally match `"pytorch"` in the keywords field.
  postPatch = ''
    sed -i '/^[[:space:]]*"torch",[[:space:]]*$/d' pyproject.toml
  '';

  # Build-time Python/tool dependencies — mirrors upstream nixpkgs:
  #   • python3Packages.ninja  – the Python ninja wheel that provides the
  #     `ninja` binary inside the PEP-517 build environment.
  #   • cuda_nvcc              – nvcc + CUDA toolkit headers; placed in
  #     build-system so it is on PATH during compilation (mirrors flash-attn).
  # torch is intentionally omitted here (see postPatch above); it is available
  # at build time via `dependencies` + --no-isolation.
  build-system = [
    pkgs.python3Packages.setuptools
    pkgs.python3Packages.ninja
    cudaPackages.cuda_nvcc
  ];

  nativeBuildInputs = [
    pkgs.which
  ];

  buildInputs = with cudaPackages; [
    cuda_cudart   # cuda_runtime.h, -lcudart
    cuda_cccl     # thrust / cub headers
    libcusparse   # cusparse.h
    libcusolver   # cusolverDn.h
    libcublas     # cublas_v2.h, -lcublas
  ];

  # Runtime Python dependencies: torch, causal-conv1d, einops, transformers.
  # triton is intentionally omitted: torch 2.10+ already propagates triton 3.6.x,
  # and adding pkgs.python3Packages.triton (nixpkgs 3.5.x) would cause a duplicate
  # package conflict in the closure.
  dependencies = [
    torch
    causal-conv1d
    pkgs.python3Packages.einops
    pkgs.python3Packages.transformers
  ];

  env = {
    # Force compilation even though upstream's setup.py checks for a pre-built
    # wheel in the dist/ directory first.
    MAMBA_FORCE_BUILD = "TRUE";

    # Tell the extension build system where the CUDA toolkit headers and nvcc
    # live.  lib.getDev extracts the "dev" output (headers + pkg-config).
    CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}";
  };

  # No upstream test suite that can run without a GPU.
  doCheck = false;

  pythonImportsCheck = [ "mamba_ssm" ];

  meta = {
    description = "Mamba state space model (built from source)";
    homepage    = "https://github.com/state-spaces/mamba";
    changelog   = "https://github.com/state-spaces/mamba/releases/tag/v${mambaVersion}";
    license     = lib.licenses.asl20;
    platforms   = [ "x86_64-linux" "aarch64-linux" ];
    # Requires CUDA; will not build on non-CUDA stdenv.
    broken      = false;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
