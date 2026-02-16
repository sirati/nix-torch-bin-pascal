{ pkgs, cudaPackages }:

let
  # Get the Python version without dots (e.g., "3.13" -> "313")
  pythonVersion = pkgs.python3.pythonVersion;
  pyVerNoDot = builtins.replaceStrings [ "." ] [ "" ] pythonVersion;

  # Import binary hashes for torch 2.9.1
  srcs = import ./binary-hashes.nix "2.9.1";

  # Construct the key for looking up the correct wheel
  # Format: x86_64-linux-313-cuda12_6
  key = "${pkgs.stdenv.system}-${pyVerNoDot}-cuda12_6";

  unsupported = throw "Unsupported system or Python version for torch CUDA 12.6: ${key} (available: ${builtins.toString (builtins.attrNames srcs)})";

in
# First, override the function arguments to use our CUDA 12.6 packages
(pkgs.python3Packages.torch-bin.override {
  cudaPackages = cudaPackages;
}).overrideAttrs (old: {
  # Then override the source to use the CUDA 12.6 wheel
  # Note: The same binary wheel works for both regular and Pascal variants
  # The difference is only in the CUDA runtime libraries (cuDNN, cuTENSOR versions)
  src = pkgs.fetchurl (srcs."${key}" or unsupported);
})
