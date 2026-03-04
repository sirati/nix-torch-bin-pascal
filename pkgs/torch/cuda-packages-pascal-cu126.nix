# Thin wrapper around the shared Pascal CUDA override for CUDA 12.6.
# See cuda-packages-pascal.nix for the full implementation.
{ pkgs }:
import ./cuda-packages-pascal.nix {
  inherit pkgs;
  cudaLabel    = "cu126";
  cudaPackages = pkgs.cudaPackages_12_6;
}
