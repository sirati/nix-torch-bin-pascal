# mamba-ssm source build derivation — thin wrapper around buildSourcePackage.
#
# Compiles mamba-ssm from source against the supplied torch derivation and
# CUDA package set.  Used by high-level.nix buildSource when no pre-built wheel
# is ABI-compatible with the resolved torch version.
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

  buildSourcePackage =
    (import ../../concretise/source-build-helpers.nix { inherit pkgs; }).buildSourcePackage;

  srcInfo  = import (./source-hashes + "/v${mambaVersion}.nix");
  srcOwner = srcInfo.owner or "state-spaces";
  srcRepo  = srcInfo.repo  or "mamba";

in
buildSourcePackage {
  pname   = "mamba-ssm";
  version = mambaVersion;

  inherit srcInfo srcOwner srcRepo torch cudaPackages;

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

  pythonImportsCheck = [ "mamba_ssm" ];

  meta = {
    description      = "Mamba state space model (built from source)";
    homepage         = "https://github.com/state-spaces/mamba";
    changelog        = "https://github.com/state-spaces/mamba/releases/tag/v${mambaVersion}";
    license          = lib.licenses.asl20;
    platforms        = [ "x86_64-linux" "aarch64-linux" ];
    broken           = false;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
