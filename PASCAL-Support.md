# Pascal GPU Support - Technical Documentation

## Overview

NVIDIA's Pascal architecture (compute capability 6.x) support was dropped in cuDNN 9.11.1+. Since PyTorch depends on cuDNN, newer PyTorch versions don't work on Pascal GPUs out of the box. This flake provides special Pascal-compatible builds to address this issue.

## Technical Background

### The Problem

One component of the CUDA suite dropped support for Pascal architecture earlier than others, which prompted PyTorch to follow suit. This component is **cuDNN** (CUDA Deep Neural Network library).

- **cuDNN 9.11.1** was the last version supporting some compute capabilities but dropped Pascal
  - See: https://docs.nvidia.com/deeplearning/cudnn/backend/v9.11.1/reference/support-matrix.html
  
- **cuDNN 9.10.2** was the last version with full Pascal support
  - See: https://docs.nvidia.com/deeplearning/cudnn/backend/v9.11.1/reference/support-matrix.html

- **cuDNN 9.12.0** and later completely dropped Pascal support
  - See: https://docs.nvidia.com/deeplearning/cudnn/backend/v9.12.0/reference/support-matrix.html

## Supported Pascal GPUs
Pascal architecture includes GPUs with compute capability 6.0, 6.1
(this section is LLM generated and not verified)

### Consumer GPUs (Compute Capability 6.1)
- GeForce GTX 1050, 1050 Ti
- GeForce GTX 1060 (3GB, 6GB)
- GeForce GTX 1070, 1070 Ti
- GeForce GTX 1080, 1080 Ti
- GeForce GT 1030
- Titan X (Pascal)
- Titan Xp

### Datacenter GPUs (Compute Capability 6.0)
- Tesla P4
- Tesla P40
- Tesla P100

### Professional GPUs (Compute Capability 6.1)
- Quadro P400, P600, P620
- Quadro P1000, P2000, P2200
- Quadro P4000, P5000, P6000
- Quadro GP100

## Implementation Details

### Package Definitions in Nixpkgs

cuDNN is defined in nixpkgs at:
- https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/development/cuda-modules/packages/cudnn.nix

cuTENSOR is defined in nixpkgs at:
- https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/development/cuda-modules/packages/libcutensor.nix

### Redistribution Manifests

To override the package versions, we use NVIDIA's redistribution manifests:

- **cuDNN 9.10.2**: https://developer.download.nvidia.com/compute/cudnn/redist/redistrib_9.10.2.json
- **cuDNN 9.11.1**: https://developer.download.nvidia.com/compute/cudnn/redist/redistrib_9.11.1.json (not used for Pascal, or otherwise)
- **cuTENSOR 2.1.0**: https://developer.download.nvidia.com/compute/cutensor/redist/redistrib_2.1.0.json

These manifests are stored in `torch-bin-cu126/manifests/` and are used by our custom CUDA package override in `torch-bin-cu126/cuda-packages-pascal.nix`.

### Version Compatibility Matrix

| Component | Regular Build | Pascal Build | Notes |
|-----------|--------------|--------------|-------|
| CUDA Toolkit | 12.6 | 12.6 | Same for both |
| cuDNN | 9.13.0.50 | 9.10.2.21 | Pascal uses older version |
| cuTENSOR | 2.0.1 | 2.1.0 | Pascal uses compatible version |
| PyTorch | 2.9.1/2.10.0 | 2.9.1/2.10.0 | Same for both |
| Compute Capability | 7.0+ | 6.0-6.1 | Pascal is 6.x |

## Determining if You Need Pascal Support

Check your GPU's compute capability:

```bash
nvidia-smi --query-gpu=compute_cap --format=csv,noheader
```

- If the output is `6.x` → Use Pascal packages
- If the output is `7.0` or higher → Use regular packages
- If the output is `5.x` untested
- If the output is `4.x` or lower → Generally unsupported nothing I can do

## Troubleshooting

### "RuntimeError: CUDA error: no kernel image is available"

This usually means you're using the regular (non-Pascal) packages with a Pascal GPU. Solution: Switch to Pascal packages.

### "CUDNN_STATUS_ARCH_MISMATCH"

This indicates a cuDNN version mismatch. Verify you're using the Pascal variant which includes cuDNN 9.10.2.
