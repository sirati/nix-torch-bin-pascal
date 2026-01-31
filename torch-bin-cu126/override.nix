{ pkgs, cudaPackages }:

let
  # Override the binary-hashes import to use our CUDA 12.6 hashes
  torchBinOverride = pkgs.python3Packages.torch-bin.overrideAttrs (old: {
    src = let
      pyVerNoDot = builtins.replaceStrings [ "." ] [ "" ] pkgs.python3.pythonVersion;
      srcs = import ./binary-hashes.nix "2.9.1";
      # Use the cuda12_6 suffix for the key lookup
      key = "${pkgs.stdenv.system}-${pyVerNoDot}-cuda12_6";
      unsupported = throw "Unsupported system or Python version for torch CUDA 12.6: ${key}";
    in
      pkgs.fetchurl (srcs."${key}" or unsupported);

    # Update buildInputs to use the provided cudaPackages (12.6)
    buildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux (
      with cudaPackages;
      [
        cuda_nvtx
        cuda_cudart
        cuda_cupti
        cuda_nvrtc
        cudnn
        libcublas
        libcufft
        libcufile
        libcurand
        libcusolver
        libcusparse
        libcusparse_lt
        libnvshmem
        nccl
      ]
    );

    # Update extraRunpaths to use the provided cudaPackages
    extraRunpaths = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      "${pkgs.lib.getLib cudaPackages.cuda_nvrtc}/lib"
    ];
  });
in
torchBinOverride
