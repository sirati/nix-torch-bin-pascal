# High-level derivation for rwkv7-kernels (sirati/rwkv7-wrapper).
#
# Pre-built wheel only; no source-build path (build via the rwkv7-wrapper
# repo's build.sh, which drives podman + pytorch/manylinux2_28-builder).
# The wheel was compiled against torch 2.10.0+cu130 but is ABI-compatible
# with any torch 2.10.x build (C++ ABI doesn't depend on CUDA version;
# CUDA libs are auditwheel-excluded).

{ torch, hldHelpers, packageName }:

assert hldHelpers.isHLD torch;

{
  originType = "github-releases";

  srcOwner = "sirati";
  srcRepo  = "rwkv7-wrapper";

  highLevelDeps = { inherit torch; };

  # Wheel is locked to torch 2.10.x. ABI changes with torch major.minor.
  versionConstraints = {
    torch = { minVersion = "2.10"; maxVersion = "2.10.99"; };
  };

  getVersions = hldHelpers.getVersionsFromVersionFiles ./binary-hashes;
  canBuildBin = hldHelpers.canBuildBinFromVersionFiles ./binary-hashes;

  buildBin = { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    import ./overlay-bin.nix {
      overlayInfo = mkOverlayInfo { inherit pkgs cudaPackages version resolvedDeps; };
      cudaVersion = "cu12";
    };

  buildSource = _:
    throw "rwkv7-kernels: no source build in this flake; build via the rwkv7-wrapper repo (https://github.com/sirati/rwkv7-wrapper).";
}
