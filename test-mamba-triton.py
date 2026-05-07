#!/usr/bin/env python3
"""
Test script: trigger mamba_ssm triton kernel autotuning.

This exercises the exact call path shown in problem_mamba_tuning_call_triton:
  Mamba2.forward
    -> mamba_split_conv1d_scan_combined
      -> _mamba_chunk_scan_combined_fwd
        -> _chunk_cumsum_fwd
          -> triton autotuner (requires libcuda.so.1 via libcuda_dirs())

Running this verifies that the /sbin/ldconfig fix in pkgs/triton/override.nix
works correctly: the os.path.exists(cudaStubsDir) short-circuit lets triton
find libcuda.so.1 without calling the non-existent /sbin/ldconfig on NixOS.

Usage (from the mamba-source nix shell or app):
  python3 test-mamba-triton.py

Or via nix run:
  TRITON_LIBCUDA_PATH=/run/opengl-driver/lib nix run .#test-mamba-source-py313-cu128
"""

import sys
import os

print(f"Python: {sys.version}")
print(f"TRITON_LIBCUDA_PATH: {os.environ.get('TRITON_LIBCUDA_PATH', '(not set)')}")


# ---------------------------------------------------------------------------
# 1. Basic sanity: torch + CUDA
# ---------------------------------------------------------------------------
print("\n[1] Importing torch...")
import torch

print(f"    torch version : {torch.__version__}")
cuda_ok = torch.cuda.is_available()
print(f"    CUDA available: {cuda_ok}")
if not cuda_ok:
    print("    WARNING: no CUDA device — triton autotuning will not run.")
    print("    Set TRITON_LIBCUDA_PATH and make sure an NVIDIA GPU is present.")
    sys.exit(0)

device = torch.device("cuda")
props = torch.cuda.get_device_properties(0)
print(f"    GPU 0: {props.name}  cc={props.major}.{props.minor}  "
      f"mem={props.total_memory / 1024**3:.1f} GiB")


# ---------------------------------------------------------------------------
# 2. Import triton and confirm the ldconfig fix is present
# ---------------------------------------------------------------------------
print("\n[2] Importing triton and checking driver.py patch...")
import triton  # noqa: F401 — side-effect: loads triton
import importlib.util, pathlib

driver_py = pathlib.Path(triton.__file__).parent / "backends" / "nvidia" / "driver.py"
src = driver_py.read_text()
if "os.path.exists" in src and "stubs" in src:
    print("    ✓ ldconfig short-circuit patch is present in driver.py")
    # Show the injected lines for confirmation
    for i, line in enumerate(src.splitlines()):
        if "stubs" in line or ("os.path.exists" in line and i < 50):
            print(f"      L{i+1}: {line}")
else:
    print("    ✗ WARNING: patch NOT found in driver.py — ldconfig fix missing!")
    print("      driver.py path:", driver_py)


# ---------------------------------------------------------------------------
# 3. Import mamba_ssm
# ---------------------------------------------------------------------------
print("\n[3] Importing mamba_ssm...")
try:
    from mamba_ssm.modules.mamba2 import Mamba2
    from mamba_ssm.ops.triton.ssd_combined import mamba_split_conv1d_scan_combined
    print("    ✓ mamba_ssm imported successfully")
except ImportError as e:
    print(f"    ✗ ImportError: {e}")
    sys.exit(1)


# ---------------------------------------------------------------------------
# 4. Construct a small Mamba2 layer and run a forward pass.
#
#    Parameters chosen to be minimal but still exercise the triton kernels:
#      d_model=64, d_state=16, d_conv=4, expand=2 → d_inner=128
#    batch=1, seqlen=64, chunk_size=16 (default)
#
#    This will trigger triton autotuning on the first call, which is the
#    exact code path that previously raised FileNotFoundError on /sbin/ldconfig.
# ---------------------------------------------------------------------------
print("\n[4] Building Mamba2 model (small) on GPU...")
model = Mamba2(
    d_model=64,
    d_state=16,
    d_conv=4,
    expand=2,
).to(device, dtype=torch.float32)
print(f"    params: {sum(p.numel() for p in model.parameters()):,}")

batch, seqlen = 1, 64
x = torch.randn(batch, seqlen, 64, device=device, dtype=torch.float32)
print(f"    input  shape: {list(x.shape)}  dtype={x.dtype}  device={x.device}")

print("\n[5] Running forward pass (this triggers triton autotuning)...")
print("    (first call compiles triton kernels — may take 30-90 s) ...")
try:
    with torch.no_grad():
        out = model(x)
    print(f"    ✓ forward pass succeeded  output shape: {list(out.shape)}")
except FileNotFoundError as e:
    print(f"    ✗ FileNotFoundError (ldconfig fix NOT effective): {e}")
    sys.exit(1)
except Exception as e:
    print(f"    ✗ Unexpected error during forward: {type(e).__name__}: {e}")
    import traceback; traceback.print_exc()
    sys.exit(1)


# ---------------------------------------------------------------------------
# 5. Second forward (cached — should be fast, confirms cache works)
# ---------------------------------------------------------------------------
print("\n[6] Second forward pass (cached kernels, should be fast)...")
try:
    with torch.no_grad():
        out2 = model(x)
    print(f"    ✓ second forward succeeded  output shape: {list(out2.shape)}")
except Exception as e:
    print(f"    ✗ Error on second forward: {type(e).__name__}: {e}")
    import traceback; traceback.print_exc()
    sys.exit(1)


# ---------------------------------------------------------------------------
# 6. Backward pass (exercises additional triton kernels)
# ---------------------------------------------------------------------------
print("\n[7] Backward pass (additional triton kernels)...")
model.train()
x_grad = torch.randn(batch, seqlen, 64, device=device, dtype=torch.float32,
                     requires_grad=False)
try:
    out3 = model(x_grad)
    loss = out3.sum()
    loss.backward()
    print(f"    ✓ backward pass succeeded")
except FileNotFoundError as e:
    print(f"    ✗ FileNotFoundError during backward: {e}")
    sys.exit(1)
except Exception as e:
    print(f"    ✗ Error during backward: {type(e).__name__}: {e}")
    import traceback; traceback.print_exc()
    sys.exit(1)


# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
print("\n" + "=" * 60)
print("  ALL TESTS PASSED")
print("  triton ldconfig fix works correctly on NixOS")
print("=" * 60)
