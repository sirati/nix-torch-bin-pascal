# Custom CUDA 12.6 package set for Pascal architecture
#
# Pascal support constraints:
# - cuDNN: version 9.10.2 (last version supporting Pascal GPUs with SM 6.x)
# - cuTENSOR: max version 2.1.0 (support dropped after this)
#
# This override uses NVIDIA's redistrib JSON manifests directly,
# following the same pattern as nixpkgs CUDA modules.
#
# Usage:
#   cudaPackages_12_6_pascal = import ./cuda-packages-pascal.nix { inherit pkgs; };

{ pkgs }:

let
  # Import the manifest files we downloaded from NVIDIA
  cudnnManifest = builtins.fromJSON (builtins.readFile ./manifests/cudnn/redistrib_9.10.2.json);
  cutensorManifest = builtins.fromJSON (builtins.readFile ./manifests/libcutensor/redistrib_2.1.0.json);

in
pkgs.cudaPackages_12_6.overrideScope (final: prev: {
  # Override cuDNN to use version 9.10.2 (last version supporting Pascal with SM 6.x)
  cudnn = prev.cudnn.overrideAttrs (old:
    let
      # Extract the cudnn package info from manifest
      cudnnPkg = cudnnManifest.cudnn;
      # Get the linux-x86_64 cuda12 variant
      cudnnInfo = cudnnPkg."linux-x86_64".cuda12;
    in
    {
      # Silence the warning by marking this as intentional
      __intentionallyOverridingVersion = true;

      # Override version from manifest
      version = cudnnPkg.version;

      # Override the source with info from manifest
      src = pkgs.fetchurl {
        url = "https://developer.download.nvidia.com/compute/cudnn/redist/${cudnnInfo.relative_path}";
        sha256 = cudnnInfo.sha256;
      };
    }
  );

  # Override cuTENSOR to use version 2.1.0.9 (last version supporting Pascal)
  libcutensor = prev.libcutensor.overrideAttrs (old:
    let
      # Extract the libcutensor package info from manifest
      cutensorPkg = cutensorManifest.libcutensor;
      # Get the linux-x86_64 variant
      cutensorInfo = cutensorPkg."linux-x86_64";
    in
    {
      # Silence the warning by marking this as intentional
      __intentionallyOverridingVersion = true;

      # Override version from manifest
      version = cutensorPkg.version;

      # Override the source with info from manifest
      src = pkgs.fetchurl {
        url = "https://developer.download.nvidia.com/compute/cutensor/redist/${cutensorInfo.relative_path}";
        sha256 = cutensorInfo.sha256;
      };
    }
  );
})
