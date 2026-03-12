# High-level derivation for torchao.
#
# torchao wheels are distributed via download.pytorch.org per CUDA variant.
# Wheels use the Python Stable ABI (cp310-abi3): one wheel for all Python
# 3.10+, so there is no per-Python-version dimension.
#
# torchao does not encode torch version in its wheel filename, but it does
# depend on torch at runtime.  The CUDA kernels are compiled against CUDA
# directly, not against torch's C++ ABI, so the store path omits the torch
# series dimension (torchAgnostic = true).
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.

{ torch, hldHelpers, packageName }:

assert hldHelpers.isHLD torch;

let
  srcOwner    = "pytorch";
  srcRepo     = "ao";
  mkChangelog = hldHelpers."github-release-tag" srcOwner srcRepo;
  mkOverlayInfo = hldHelpers.mkOverlayInfo {
    pname       = packageName;
    nixpkgsAttr = packageName;
    inherit srcOwner srcRepo mkChangelog;
  };

in
{
  originType = "torch-website";

  inherit srcOwner srcRepo mkChangelog mkOverlayInfo;

  # torchao compiles CUDA kernels via setuptools/cmake against CUDA directly,
  # not against torch at the C++/ABI level.  Torch is only a Python-level
  # runtime dependency.
  torchAgnostic = true;

  # Per-CUDA-label hash files, stable ABI (no pyVer filtering needed).
  getVersions = hldHelpers.getVersionsFromCudaFilesStableAbi ./binary-hashes;

  highLevelDeps = { inherit torch; };

  canBuildBin = { cudaLabel, version, ... }:
    let
      f = ./binary-hashes + "/${cudaLabel}.nix";
    in
    builtins.pathExists f &&
    builtins.hasAttr version (import f);

  buildBin = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, mkOverlayInfo ? null, wrappers ? null }:
    let
      hashFile      = import (./binary-hashes + "/${cudaLabel}.nix");
      versionHashes = hashFile.${version};
    in
    import ./overlay-bin.nix {
      inherit pkgs cudaPackages versionHashes;
      torchaoVersion = version;
      torch          = resolvedDeps."torch";
    };

  buildSource = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, mkOverlayInfo ? null, wrappers ? null }:
    let
      v = hldHelpers.requireSourceHash
            "torchao" "pkgs/torchao" ./source-hashes
            { inherit version cudaLabel; };
    in
    import ./overlay-source.nix {
      overlayInfo = mkOverlayInfo { inherit pkgs cudaPackages resolvedDeps; version = v; };
    };
}
