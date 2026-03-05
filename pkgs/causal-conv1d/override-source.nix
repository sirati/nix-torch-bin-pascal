# causal-conv1d source build derivation — thin wrapper around buildSourcePackage.
#
# Compiles causal-conv1d from source against the supplied torch derivation and
# CUDA package set.  Used by high-level.nix buildSource when no pre-built wheel
# is ABI-compatible with the resolved torch version.
#
# Arguments:
#   pkgs        - nixpkgs package set; pkgs.python3 must be the target
#                 Python interpreter (set by concretise via pkgsForBuild)
#   torch       - the concrete torch derivation from resolvedDeps."torch"
#   cudaPackages - CUDA package set (already configured for Pascal or
#                  vanilla by concretise)
#   version     - version string to build, e.g. "1.6.0"
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
  buildSourcePackage =
    (import ../../concretise/source-build-helpers.nix { inherit pkgs; }).buildSourcePackage;

  srcInfo = import (./source-hashes + "/v${version}.nix");

in
buildSourcePackage {
  inherit pname version torch cudaPackages basePkg changelog;

  srcOwner = srcInfo.owner or srcOwner;
  srcRepo  = srcInfo.repo  or srcRepo;
  inherit srcInfo;

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
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "torch"' ""
  '';

  forceBuildEnvVar = "CAUSAL_CONV1D_FORCE_BUILD";

  # pythonImportsCheck: default derives "causal_conv1d" from pname — correct.
}
