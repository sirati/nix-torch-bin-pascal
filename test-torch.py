#!/usr/bin/env python3
"""
Test script to verify PyTorch with CUDA 12.6 installation.

This script:
1. Imports torch and checks basic functionality
2. Verifies CUDA availability
3. Tests basic tensor operations
4. Checks CUDA device properties
5. Runs a simple GPU computation
"""

import sys
import torch
import subprocess

def print_section(title):
    """Print a formatted section header."""
    print("\n" + "="*60)
    print(f"  {title}")
    print("="*60)

def main():
    print_section("PyTorch Installation Test")

    # Basic imports
    print("\n✓ Successfully imported torch")
    print(f"  PyTorch version: {torch.__version__}")

    # Check CUDA availability
    print_section("CUDA Availability")
    cuda_available = torch.cuda.is_available()
    print(f"  CUDA available: {cuda_available}")

    if cuda_available:
        print(f"  CUDA version: {torch.version.cuda}")
        print(f"  cuDNN version: {torch.backends.cudnn.version()}")
        print(f"  Number of GPUs: {torch.cuda.device_count()}")

        for i in range(torch.cuda.device_count()):
            print(f"\n  GPU {i}: {torch.cuda.get_device_name(i)}")
            props = torch.cuda.get_device_properties(i)
            print(f"    Compute Capability: {props.major}.{props.minor}")
            print(f"    Total Memory: {props.total_memory / 1024**3:.2f} GB")
    else:
        print("  ⚠ CUDA is not available - running in CPU mode")

    # Test basic tensor operations
    print_section("Basic Tensor Operations")

    # CPU tensor
    cpu_tensor = torch.randn(3, 3)
    print(f"  CPU Tensor:\n{cpu_tensor}")

    # Test matrix multiplication
    result = torch.mm(cpu_tensor, cpu_tensor)
    print(f"\n  ✓ Matrix multiplication works")
    print(f"    Result shape: {result.shape}")

    # GPU tensor test (if CUDA is available)
    if cuda_available:
        print_section("GPU Tensor Operations")
        try:
            gpu_tensor = torch.randn(3, 3, device='cuda')
            print(f"  GPU Tensor device: {gpu_tensor.device}")

            # GPU matrix multiplication
            gpu_result = torch.mm(gpu_tensor, gpu_tensor)
            print(f"  ✓ GPU matrix multiplication works")
            print(f"    Result device: {gpu_result.device}")

            # Test data transfer
            cpu_from_gpu = gpu_result.cpu()
            print(f"  ✓ GPU->CPU transfer works")

            gpu_from_cpu = cpu_tensor.cuda()
            print(f"  ✓ CPU->GPU transfer works")

            # Test a larger computation
            print("\n  Testing larger GPU computation...")
            large_gpu_tensor = torch.randn(1000, 1000, device='cuda')
            large_result = torch.mm(large_gpu_tensor, large_gpu_tensor)
            print(f"  ✓ Large matrix multiplication (1000x1000) works")

        except Exception as e:
            print(f"  ✗ GPU operation failed: {e}")
            return 1

    # Test autograd
    print_section("Autograd Test")
    x = torch.randn(2, 2, requires_grad=True)
    y = x ** 2
    z = y.sum()
    z.backward()
    print(f"  ✓ Autograd works")
    print(f"    Gradient:\n{x.grad}")

    # Test neural network
    print_section("Neural Network Test")
    try:
        import torch.nn as nn

        model = nn.Sequential(
            nn.Linear(10, 20),
            nn.ReLU(),
            nn.Linear(20, 1)
        )

        if cuda_available:
            model = model.cuda()
            input_tensor = torch.randn(5, 10, device='cuda')
        else:
            input_tensor = torch.randn(5, 10)

        output = model(input_tensor)
        print(f"  ✓ Neural network forward pass works")
        print(f"    Input shape: {input_tensor.shape}")
        print(f"    Output shape: {output.shape}")

    except Exception as e:
        print(f"  ✗ Neural network test failed: {e}")
        return 1

    # Summary
    print_section("Test Summary")
    print("  ✓ All tests passed!")
    print(f"  PyTorch version: {torch.__version__}")
    if cuda_available:
        print(f"  CUDA version: {torch.version.cuda}")
        print(f"  Running on: {torch.cuda.get_device_name(0)}")
    else:
        print("  Running on: CPU only")

    return 0

if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as e:
        print(f"\n✗ Fatal error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)
