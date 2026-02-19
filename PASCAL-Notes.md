# PASCAL
One component of the CUDA suit dropped support for Pascal architecture earlier, which also prompted PyTorch to drop support. This is CuDNN. Therefore, we must restrict the version of cuDNN if we are on Pascal. 

see version 9.11.1 is the last that supports cc 5.0 to 6.1 but dropped support for Pascal
https://docs.nvidia.com/deeplearning/cudnn/backend/v9.11.1/reference/support-matrix.html
see version 9.10.2 is the last that supports Pascal
https://docs.nvidia.com/deeplearning/cudnn/backend/v9.11.1/reference/support-matrix.html
the next version 9.12.0 dropped support
https://docs.nvidia.com/deeplearning/cudnn/backend/v9.12.0/reference/support-matrix.html


cuDNN nix is defined in
https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/nixpkgs-unstable/pkgs/development/cuda-modules/packages/cudnn.nix
cuTENSOR nix is defined in
https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/nixpkgs-unstable/pkgs/development/cuda-modules/packages/libcutensor.nix

for us we need to get the hashes and download paths
https://developer.download.nvidia.com/compute/cudnn/redist/redistrib_9.10.2.json

#not this one https://developer.download.nvidia.com/compute/cudnn/redist/redistrib_9.11.1.json
https://developer.download.nvidia.com/compute/cutensor/redist/redistrib_2.1.0.json


cude 12.6 only supports older versions of GCC namely up to v13