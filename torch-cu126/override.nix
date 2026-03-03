# torch override for CUDA 12.6 pre-built wheels.
#
# Delegates to the shared ../torch/override-common.nix implementation,
# supplying the cu126-specific binary-hashes as the wheel source.
#
# Arguments:
#   pkgs         - nixpkgs package set (pkgs.python3 must be the target Python)
#   cudaPackages - the CUDA package set to link against at runtime
#                  (use cudaPackages_12_6 for regular, or the Pascal variant)
#   torchVersion - PyTorch version string, e.g. "2.10.0" (default: "2.10.0")

{ pkgs, cudaPackages, torchVersion ? "2.10.0" }:

import ../torch/override-common.nix {
  inherit pkgs cudaPackages torchVersion;
  binaryHashes = import ./binary-hashes.nix;
}
