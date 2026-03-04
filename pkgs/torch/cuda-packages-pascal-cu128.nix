# Thin wrapper around the shared Pascal CUDA override for CUDA 12.8.
# See cuda-packages-pascal.nix for the full implementation.
{ pkgs }:
import ./cuda-packages-pascal.nix {
  inherit pkgs;
  cudaLabel    = "cu128";
  cudaPackages = pkgs.cudaPackages_12_8;
}
