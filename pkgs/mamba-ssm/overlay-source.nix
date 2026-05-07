# mamba-ssm source build derivation — thin wrapper around buildSourcePackage.
#
# Compiles mamba-ssm from source against the supplied torch derivation and
# CUDA package set.  Used by high-level.nix buildSource when no pre-built wheel
# is ABI-compatible with the resolved torch version.
#
# Arguments:
#   overlayInfo   - common package context attrset from high-level.nix
#                   (pkgs, cudaPackages, version, pname, srcOwner, srcRepo,
#                    basePkg, changelog, torch)
#   causal-conv1d - the concrete causal-conv1d derivation from resolvedDeps

{ overlayInfo, causal-conv1d }:

let
  buildSourcePackage =
    (import ../../concretise/source-build-helpers.nix).buildSourcePackage;

  inherit (overlayInfo) pkgs;

in
buildSourcePackage {
  inherit overlayInfo;
  sourceHashesDir = ./source-hashes;

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
