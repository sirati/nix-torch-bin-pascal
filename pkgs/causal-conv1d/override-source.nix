# causal-conv1d source build derivation — thin wrapper around buildSourcePackage.
#
# Compiles causal-conv1d from source against the supplied torch derivation and
# CUDA package set.  Used by high-level.nix buildSource when no pre-built wheel
# is ABI-compatible with the resolved torch version.
#
# Arguments:
#   overrideInfo - common package context attrset from high-level.nix
#                  (pkgs, cudaPackages, version, pname, srcOwner, srcRepo,
#                   basePkg, changelog, torch)

{ overrideInfo }:

let
  buildSourcePackage =
    (import ../../concretise/source-build-helpers.nix).buildSourcePackage;
in
buildSourcePackage {
  inherit overrideInfo;
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
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "torch"' ""
  '';

  forceBuildEnvVar = "CAUSAL_CONV1D_FORCE_BUILD";

  # pythonImportsCheck: default derives "causal_conv1d" from pname — correct.
}
