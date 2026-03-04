# Shared Pascal CUDA package set override.
#
# Pascal support constraints:
# - cuDNN: version 9.10.2 (last version supporting Pascal GPUs with SM 6.x)
# - cuTENSOR: max version 2.1.0 (support dropped after this)
#
# This override uses NVIDIA's redistrib JSON manifests directly,
# following the same pattern as nixpkgs CUDA modules.
#
# Arguments:
#   pkgs          - nixpkgs package set
#   cudaLabel     - CUDA variant label used to locate manifests, e.g. "cu126" or "cu128"
#   cudaPackages  - the base CUDA package set to extend (e.g. pkgs.cudaPackages_12_6)
#
# Usage (preferred – via the per-variant wrapper):
#   import ./cuda-packages-pascal-cu126.nix { inherit pkgs; }
#
# Usage (direct):
#   import ./cuda-packages-pascal.nix {
#     inherit pkgs;
#     cudaLabel    = "cu126";
#     cudaPackages = pkgs.cudaPackages_12_6;
#   }

{ pkgs, cudaLabel, cudaPackages }:

let
  manifestDir = ./manifests + "/${cudaLabel}";

  cudnnManifest    = builtins.fromJSON (builtins.readFile (manifestDir + "/cudnn/redistrib_9.10.2.json"));
  cutensorManifest = builtins.fromJSON (builtins.readFile (manifestDir + "/libcutensor/redistrib_2.1.0.json"));

in
cudaPackages.overrideScope (final: prev: {

  # Override cuDNN to use version 9.10.2 (last version supporting Pascal with SM 6.x)
  cudnn = prev.cudnn.overrideAttrs (_old:
    let
      cudnnPkg  = cudnnManifest.cudnn;
      cudnnInfo = cudnnPkg."linux-x86_64".cuda12;
    in
    {
      __intentionallyOverridingVersion = true;
      version = cudnnPkg.version;
      src = pkgs.fetchurl {
        url    = "https://developer.download.nvidia.com/compute/cudnn/redist/${cudnnInfo.relative_path}";
        sha256 = cudnnInfo.sha256;
      };
    }
  );

  # Override cuTENSOR to use version 2.1.0 (last version supporting Pascal)
  libcutensor = prev.libcutensor.overrideAttrs (_old:
    let
      cutensorPkg  = cutensorManifest.libcutensor;
      cutensorInfo = cutensorPkg."linux-x86_64";
    in
    {
      __intentionallyOverridingVersion = true;
      version = cutensorPkg.version;
      src = pkgs.fetchurl {
        url    = "https://developer.download.nvidia.com/compute/cutensor/redist/${cutensorInfo.relative_path}";
        sha256 = cutensorInfo.sha256;
      };
    }
  );
})
