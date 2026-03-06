# cudaPackages scope override: upgrade cuDNN to 9.15.1 for cu126 and cu130.
#
# torch 2.10.0 wheels for cu126 and cu130 were compiled against cuDNN 9.15.1,
# while nixpkgs currently only ships 9.13.0.  Providing 9.15.1 here ensures
# that autoPatchelfHook wires the correct version into every package built
# within the concretise call (torch, flash-attn, causal-conv1d, …).
#
# The manifest JSON is the redistrib file downloaded from NVIDIA's CDN:
#   https://developer.download.nvidia.com/compute/cudnn/redist/redistrib_9.15.1.json
#
# Arguments:
#   pkgs         - nixpkgs package set
#   cudaLabel    - "cu126" or "cu130"
#   cudaPackages - the base CUDA package set to extend
#
# Usage (from concretise/default.nix):
#   import ../pkgs/torch/cuda-packages-cudnn-fix.nix {
#     inherit pkgs cudaLabel;
#     cudaPackages = baseCudaPackages;
#   }

{ pkgs, cudaLabel, cudaPackages }:

let
  manifestDir = ./manifests + "/${cudaLabel}/cudnn";
  cudnnManifest = builtins.fromJSON (builtins.readFile (manifestDir + "/redistrib_9.15.1.json"));

  # cu126 → CUDA 12 toolkit variant; cu130 → CUDA 13 toolkit variant.
  cudaVariant = if cudaLabel == "cu130" then "cuda13" else "cuda12";

in
cudaPackages.overrideScope (final: prev: {

  cudnn = prev.cudnn.overrideAttrs (_old:
    let
      cudnnPkg  = cudnnManifest.cudnn;
      cudnnInfo = cudnnPkg."linux-x86_64".${cudaVariant};
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

})
