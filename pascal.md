# PASCAL
One component of the CUDA suit dropped support for Pascal architecture earlier, which also prompted PyTorch to drop support. This is CuDNN. Therefore, we must restrict the version of cuDNN if we are on Pascal. 

see version 9.11.1 is the last that supports Pascal
https://docs.nvidia.com/deeplearning/cudnn/backend/v9.11.1/reference/support-matrix.html
the next version 9.12.0 dropped support
https://docs.nvidia.com/deeplearning/cudnn/backend/v9.12.0/reference/support-matrix.html
