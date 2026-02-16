# Custom CUDA 12.6 package set for Pascal architecture
#
# Pascal support constraints:
# - cuDNN: max version 9.11.1 (support dropped after this)
# - cuTENSOR: max version 2.1.0 (support dropped after this)
#
# Usage:
#   let
#     cudaPackages_12_6_pascal = pkgs.cudaPackages_12_6.overrideScope (final: prev:
#       pkgs.lib.recursiveUpdate prev (import ./cuda-packages-pascal.nix)
#     );
#   in ...
#
# Or simpler:
#   cudaPackages_12_6_pascal = import ./cuda-packages-pascal.nix { inherit pkgs; };

{ pkgs }:

pkgs.cudaPackages_12_6.overrideScope (final: prev: {
  # Override cuDNN to use version 9.11.1 (last version supporting Pascal)
  cudnn = prev.cudnn.overrideAttrs (old: rec {
    version = "9.11.1";
    # The src will need to be updated to match this version
    # This assumes the manifest system will handle it automatically
    # If not, you may need to manually specify the src
  });

  # Override cuTENSOR to use version 2.1.0 (last version supporting Pascal)
  libcutensor = prev.libcutensor.overrideAttrs (old: rec {
    version = "2.1.0";
    # The src will need to be updated to match this version
    # This assumes the manifest system will handle it automatically
  });
})
