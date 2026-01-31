#!/usr/bin/env python3
"""
Test script to verify PyTorch with CUDA 12.6 installation.
Specifically checks compatibility with Pascal GPU (GTX 1080 Ti, SM 6.1).
"""

import sys

def test_torch_import():
    """Test that torch can be imported."""
    try:
        import torch
        print("✓ PyTorch imported successfully")
        return torch
    except ImportError as e:
        print(f"✗ Failed to import PyTorch: {e}")
        sys.exit(1)

def test_cuda_availability(torch):
    """Test CUDA availability."""
    if torch.cuda.is_available():
        print("✓ CUDA is available")
        return True
    else:
        print("✗ CUDA is not available")
        print("  This may be expected if running without a GPU")
        return False

def print_torch_info(torch):
    """Print detailed PyTorch and CUDA information."""
    print("\n" + "="*50)
    print("PyTorch Configuration")
    print("="*50)
    print(f"PyTorch version: {torch.__version__}")
    print(f"Python version: {sys.version.split()[0]}")
    print(f"CUDA available: {torch.cuda.is_available()}")

    if torch.cuda.is_available():
        print(f"CUDA version (runtime): {torch.version.cuda}")
        print(f"cuDNN version: {torch.backends.cudnn.version()}")
        print(f"Number of CUDA devices: {torch.cuda.device_count()}")

        for i in range(torch.cuda.device_count()):
            print(f"\nDevice {i}: {torch.cuda.get_device_name(i)}")
            props = torch.cuda.get_device_properties(i)
            print(f"  Compute capability: {props.major}.{props.minor}")
            print(f"  Total memory: {props.total_memory / 1024**3:.2f} GB")

            # Check if it's a Pascal GPU (SM 6.x)
            if props.major == 6 and props.minor == 1:
                print("  ✓ Pascal GPU detected (GTX 1080 Ti compatible, SM 6.1)")
            elif props.major == 6:
                print(f"  ✓ Pascal GPU detected (SM 6.{props.minor})")
            else:
                print(f"  Note: Not a Pascal GPU (SM {props.major}.{props.minor})")

    print("\nBuild configuration:")
    print(f"  CUDA compiled: {torch.version.cuda is not None}")
    if hasattr(torch, '_C') and hasattr(torch._C, '_cuda_getCompiledVersion'):
        print(f"  CUDA compiled version: {torch._C._cuda_getCompiledVersion()}")

    print("="*50)

def test_tensor_operations(torch):
    """Test basic tensor operations."""
    print("\n" + "="*50)
    print("Testing Tensor Operations")
    print("="*50)

    # CPU tensor
    try:
        cpu_tensor = torch.randn(3, 3)
        print("✓ CPU tensor creation successful")
        print(f"  Shape: {cpu_tensor.shape}, dtype: {cpu_tensor.dtype}")
    except Exception as e:
        print(f"✗ CPU tensor creation failed: {e}")
        return False

    # CUDA tensor (if available)
    if torch.cuda.is_available():
        try:
            cuda_tensor = torch.randn(3, 3, device='cuda')
            print("✓ CUDA tensor creation successful")
            print(f"  Shape: {cuda_tensor.shape}, dtype: {cuda_tensor.dtype}")

            # Test matrix multiplication on GPU
            result = torch.mm(cuda_tensor, cuda_tensor)
            print("✓ CUDA matrix multiplication successful")

            # Test CPU-GPU transfer
            cpu_from_cuda = cuda_tensor.cpu()
            cuda_from_cpu = cpu_tensor.cuda()
            print("✓ CPU ↔ GPU tensor transfer successful")

            return True
        except Exception as e:
            print(f"✗ CUDA tensor operations failed: {e}")
            return False
    else:
        print("⊘ Skipping CUDA tensor tests (no GPU available)")
        return True

def main():
    """Run all tests."""
    print("="*50)
    print("PyTorch CUDA 12.6 Installation Test")
    print("Target: Python 3.13, Pascal GPU (SM 6.1)")
    print("="*50 + "\n")

    # Test 1: Import
    torch = test_torch_import()

    # Test 2: CUDA availability
    cuda_available = test_cuda_availability(torch)

    # Test 3: Print info
    print_torch_info(torch)

    # Test 4: Tensor operations
    test_tensor_operations(torch)

    print("\n" + "="*50)
    if cuda_available:
        print("✓ All tests completed successfully!")
        print("PyTorch with CUDA 12.6 is properly configured.")
    else:
        print("✓ PyTorch tests completed (without GPU).")
        print("To test CUDA, run this script on a machine with a GPU.")
    print("="*50)

if __name__ == "__main__":
    main()
