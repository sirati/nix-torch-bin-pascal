# causal-conv1d source build derivation — thin wrapper around buildSourcePackage.
#
# Compiles causal-conv1d from source against the supplied torch derivation and
# CUDA package set.  Used by high-level.nix buildSource when no pre-built wheel
# is ABI-compatible with the resolved torch version.
#
# Arguments:
#   pkgs                 - nixpkgs package set; pkgs.python3 must be the target
#                          Python interpreter (set by concretise via pkgsForBuild)
#   torch                - the concrete torch derivation from resolvedDeps."torch"
#   cudaPackages         - CUDA package set (already configured for Pascal or
#                          vanilla by concretise)
#   causalConv1dVersion  - version string to build, e.g. "1.6.0"

{ pkgs
, torch
, cudaPackages
, causalConv1dVersion
}:

let
  inherit (pkgs) lib;

  buildSourcePackage =
    (import ../../concretise/source-build-helpers.nix { inherit pkgs; }).buildSourcePackage;

  srcInfo  = import (./source-hashes + "/v${causalConv1dVersion}.nix");
  srcOwner = srcInfo.owner or "Dao-AILab";
  srcRepo  = srcInfo.repo  or "causal-conv1d";

in
buildSourcePackage {
  pname   = "causal-conv1d";
  version = causalConv1dVersion;

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
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "torch"' ""
  '';

  forceBuildEnvVar = "CAUSAL_CONV1D_FORCE_BUILD";

  pythonImportsCheck = [ "causal_conv1d" ];

  meta = {
    description = "Efficient causal 1D convolution for autoregressive models (built from source)";
    homepage    = "https://github.com/Dao-AILab/causal-conv1d";
    changelog   = "https://github.com/Dao-AILab/causal-conv1d/releases/tag/v${causalConv1dVersion}";
    license     = lib.licenses.bsd3;
    platforms   = [ "x86_64-linux" "aarch64-linux" ];
    broken      = false;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
