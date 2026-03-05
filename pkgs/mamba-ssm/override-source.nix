# mamba-ssm source build derivation — thin wrapper around buildSourcePackage.
#
# Compiles mamba-ssm from source against the supplied torch derivation and
# CUDA package set.  Used by high-level.nix buildSource when no pre-built wheel
# is ABI-compatible with the resolved torch version.
#
# Arguments:
#   pkgs        - nixpkgs package set; pkgs.python3 must be the target
#                 Python interpreter (set by concretise via pkgsForBuild)
#   torch       - the concrete torch derivation from resolvedDeps."torch"
#   causal-conv1d - the concrete causal-conv1d derivation from resolvedDeps."causal-conv1d"
#   cudaPackages - CUDA package set (already configured for Pascal or
#                  vanilla by concretise)
#   version     - version string to build, e.g. "2.3.0"
#   pname       - Python package name, passed from high-level.nix
#   srcOwner    - GitHub owner, passed from high-level.nix
#   srcRepo     - GitHub repo, passed from high-level.nix
#   basePkg     - upstream nixpkgs derivation for meta inheritance (may be null)
#   changelog   - changelog URL for this version (may be null)

{ pkgs
, torch
, causal-conv1d
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

  forceBuildEnvVar = "MAMBA_FORCE_BUILD";

  # Runtime Python dependencies beyond torch: causal-conv1d, einops, transformers.
  # triton is intentionally omitted: torch 2.10+ already propagates triton 3.6.x,
  # and adding pkgs.python3Packages.triton (nixpkgs 3.5.x) would cause a duplicate
  # package conflict in the closure.
  extraDependencies = [
    causal-conv1d
    pkgs.python3Packages.einops
    pkgs.python3Packages.transformers
  ];

  # pythonImportsCheck: default derives "mamba_ssm" from pname — correct.
}
