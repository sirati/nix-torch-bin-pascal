"""triton manual debug / test script.

Verifies that:
  1. The ldconfig short-circuit patch is present in driver.py
  2. A trivial triton kernel compiles and runs correctly
     (this exercises the exact code path that previously raised
     FileNotFoundError on /sbin/ldconfig on NixOS)
"""

import torch


def print_section(title):
    print("\n" + "=" * 60)
    print(f"  {title}")
    print("=" * 60)


def main(cuda_available: bool):
    print_section("triton")

    import triton

    print(f"  version : {getattr(triton, '__version__', 'unknown')}")

    if not cuda_available:
        print("  SKIP - triton requires CUDA")
        return "skip"

    # --- Check ldconfig patch ---
    import pathlib

    driver_py = (
        pathlib.Path(triton.__file__).parent / "backends" / "nvidia" / "driver.py"
    )
    if driver_py.exists():
        src = driver_py.read_text()
        if "os.path.exists" in src and "stubs" in src:
            print("  \u2713 ldconfig short-circuit patch present in driver.py")
        else:
            print("  \u26a0 ldconfig patch NOT found in driver.py")
    else:
        print(f"  \u26a0 driver.py not found at {driver_py}")

    # --- Compile and run a trivial triton kernel ---
    import triton.language as tl

    @triton.jit
    def _add_kernel(x_ptr, y_ptr, out_ptr, n: tl.constexpr):
        idx = tl.program_id(0) * n + tl.arange(0, n)
        x = tl.load(x_ptr + idx)
        y = tl.load(y_ptr + idx)
        tl.store(out_ptr + idx, x + y)

    size = 1024
    x = torch.randn(size, device="cuda")
    y = torch.randn(size, device="cuda")
    out = torch.empty(size, device="cuda")

    block_size = 256
    grid = (size // block_size,)
    _add_kernel[grid](x, y, out, block_size)

    expected = x + y
    assert torch.allclose(out, expected, atol=1e-5), (
        f"Triton kernel output mismatch: max diff={(out - expected).abs().max().item():.2e}"
    )
    print(f"  \u2713 trivial kernel compiled and ran correctly (size={size})")

    return 0


if __name__ == "__main__":
    import sys

    cuda = torch.cuda.is_available()
    sys.exit(main(cuda))
