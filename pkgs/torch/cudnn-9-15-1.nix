# cuDNN 9.15.1 derivation for torch cu126 / cu130.
#
# torch 2.10.0 wheels for cu126 and cu130 were compiled against cuDNN 9.15.1,
# while nixpkgs currently only provides 9.13.0.  For those two CUDA labels we
# substitute this derivation so that autoPatchelfHook resolves libcudnn.so.9
# against the correct version and torch's runtime version check passes.
#
# cudaVariant must be either "cuda12" (cu126) or "cuda13" (cu130).
#
# Source: https://developer.download.nvidia.com/compute/cudnn/redist/
#         redistrib_9.15.1.json

{ pkgs, cudaVariant }:

assert cudaVariant == "cuda12" || cudaVariant == "cuda13";

let
  version = "9.15.1.9";

  hashes = {
    cuda12 = "4bd08d37ef761af423714adfd1d8107bdd2581a55136f8d70d15560f7330b194";
    cuda13 = "cb3434657f66dd548ee71b5646a7451b3a4be197caecbebae8c18f8ffba22666";
  };

in
pkgs.stdenv.mkDerivation {
  pname   = "cudnn";
  inherit version;

  src = pkgs.fetchurl {
    url    = "https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-${version}_${cudaVariant}-archive.tar.xz";
    sha256 = hashes.${cudaVariant};
  };

  # Nothing to configure or compile — just repack the pre-built archive.
  dontConfigure = true;
  dontBuild     = true;

  # Do NOT let autoPatchelfHook or strip touch these CUDA libraries;
  # they are already in their final form.
  dontStrip    = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"

    # Copy libraries (preserving soname symlinks) and headers.
    cp -a lib     "$out/lib"
    cp -a include "$out/include"

    runHook postInstall
  '';

  meta = {
    description = "NVIDIA CUDA Deep Neural Network library (cuDNN) 9.15.1";
    homepage    = "https://developer.nvidia.com/cudnn";
    license     = pkgs.lib.licenses.unfreeRedistributable;
    platforms   = [ "x86_64-linux" ];
  };
}
