# Custom CUDA 12.8 package set for Pascal architecture
#
# Pascal support constraints:
# - cuDNN: version 9.10.2 (last version supporting Pascal GPUs with SM 6.x)
# - cuTENSOR: max version 2.1.0 (support dropped after this)
#
# This override uses NVIDIA's redistrib JSON manifests directly,
# following the same pattern as nixpkgs CUDA modules.
#
# Usage:
#   cudaPackages_12_8_pascal = import ./cuda-packages-pascal.nix { inherit pkgs; };

{ pkgs }:

let
  # Import the manifest files (same Pascal-compatible versions as cu126)
  cudnnManifest = builtins.fromJSON (builtins.readFile ./manifests/cudnn/redistrib_9.10.2.json);
  cutensorManifest = builtins.fromJSON (builtins.readFile ./manifests/libcutensor/redistrib_2.1.0.json);

in
pkgs.cudaPackages_12_8.overrideScope (final: prev: {
  # Override cuDNN to use version 9.10.2 (last version supporting Pascal with SM 6.x)
  cudnn = prev.cudnn.overrideAttrs (old:
    let
      cudnnPkg = cudnnManifest.cudnn;
      cudnnInfo = cudnnPkg."linux-x86_64".cuda12;
    in
    {
      __intentionallyOverridingVersion = true;

      version = cudnnPkg.version;

      src = pkgs.fetchurl {
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/${cudnnInfo.relative_path}";
        sha256 = cudnnInfo.sha256;
      };
    }
  );

  # Override cuTENSOR to use version 2.1.0.9 (last version supporting Pascal)
  libcutensor = prev.libcutensor.overrideAttrs (old:
    let
      cutensorPkg = cutensorManifest.libcutensor;
      cutensorInfo = cutensorPkg."linux-x86_64";
    in
    {
      __intentionallyOverridingVersion = true;

      version = cutensorPkg.version;

      src = pkgs.fetchurl {
        url = "https://developer.download.nvidia.com/compute/cutensor/redist/${cutensorInfo.relative_path}";
        sha256 = cutensorInfo.sha256;
      };
    }
  );
})
