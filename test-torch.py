#!/usr/bin/env python3
"""
Test script to verify PyTorch and optional CUDA extension packages.

Tests performed:
  1. PyTorch basics + CUDA availability
  2. Basic tensor operations and autograd
  3. Neural network forward/backward pass (GPU if available)
  4. causal-conv1d: actual forward pass (skipped if not installed)
  5. flash-attn:   actual forward pass (skipped if not installed)
"""

import sys
import torch


def print_section(title):
    print("\n" + "=" * 60)
    print(f"  {title}")
    print("=" * 60)


# ---------------------------------------------------------------------------
# 1. Basic PyTorch info
# ---------------------------------------------------------------------------
def test_pytorch_info():
    print_section("PyTorch Installation Info")
    print(f"  PyTorch version : {torch.__version__}")

    cuda_available = torch.cuda.is_available()
    print(f"  CUDA available  : {cuda_available}")
    if cuda_available:
        print(f"  CUDA version    : {torch.version.cuda}")
        print(f"  cuDNN version   : {torch.backends.cudnn.version()}")
        print(f"  GPU count       : {torch.cuda.device_count()}")
        for i in range(torch.cuda.device_count()):
            props = torch.cuda.get_device_properties(i)
            print(f"  GPU {i}  : {props.name}  "
                  f"cc={props.major}.{props.minor}  "
                  f"mem={props.total_memory / 1024**3:.1f} GiB")
    else:
        print("  (no CUDA – running in CPU-only mode)")
    return cuda_available


# ---------------------------------------------------------------------------
# 2. Tensor ops + autograd
# ---------------------------------------------------------------------------
def test_tensor_ops(cuda_available: bool):
    print_section("Tensor Operations + Autograd")

    # CPU matmul
    a = torch.randn(128, 128)
    b = torch.randn(128, 128)
    c = torch.mm(a, b)
    assert c.shape == (128, 128), "CPU matmul shape mismatch"
    print("  ✓ CPU matrix multiplication (128×128)")

    # Autograd
    x = torch.randn(4, 4, requires_grad=True)
    loss = (x ** 2).sum()
    loss.backward()
    assert x.grad is not None, "Gradient is None"
    print("  ✓ Autograd backward pass")

    # GPU matmul
    if cuda_available:
        a_gpu = a.cuda()
        b_gpu = b.cuda()
        c_gpu = torch.mm(a_gpu, b_gpu)
        assert c_gpu.device.type == "cuda"
        # Round-trip close to CPU result
        assert torch.allclose(c_gpu.cpu(), c, atol=1e-4), \
            "GPU/CPU matmul results differ"
        print("  ✓ GPU matrix multiplication (128×128, matches CPU)")

        # Larger stress test
        big = torch.randn(1024, 1024, device="cuda")
        out = torch.mm(big, big)
        assert out.shape == (1024, 1024)
        print("  ✓ GPU matrix multiplication stress (1024×1024)")


# ---------------------------------------------------------------------------
# 3. Neural network
# ---------------------------------------------------------------------------
def test_neural_network(cuda_available: bool):
    print_section("Neural Network Forward + Backward")
    import torch.nn as nn

    device = torch.device("cuda" if cuda_available else "cpu")

    model = nn.Sequential(
        nn.Linear(64, 128),
        nn.GELU(),
        nn.Linear(128, 32),
        nn.GELU(),
        nn.Linear(32, 1),
    ).to(device)

    x = torch.randn(16, 64, device=device)
    y_hat = model(x)
    assert y_hat.shape == (16, 1), f"Unexpected output shape {y_hat.shape}"
    print(f"  ✓ Forward pass  input={tuple(x.shape)} → output={tuple(y_hat.shape)}"
          f"  device={device}")

    loss = y_hat.sum()
    loss.backward()
    for name, p in model.named_parameters():
        assert p.grad is not None, f"Gradient missing for {name}"
    print("  ✓ Backward pass – all parameter gradients present")


# ---------------------------------------------------------------------------
# 4. causal-conv1d
# ---------------------------------------------------------------------------
def test_causal_conv1d(cuda_available: bool):
    print_section("causal-conv1d")

    try:
        from causal_conv1d import causal_conv1d_fn
        import causal_conv1d as _cc1d_mod
        print(f"  version : {getattr(_cc1d_mod, '__version__', 'unknown')}")
    except ImportError as exc:
        print(f"  SKIP – causal-conv1d not installed ({exc})")
        return

    if not cuda_available:
        print("  SKIP – causal-conv1d requires CUDA")
        return

    # ------------------------------------------------------------------
    # causal_conv1d_fn signature:
    #   x      : (batch, dim, seqlen)  float32 / float16 / bfloat16
    #   weight : (dim, width)          same dtype   (depthwise weights)
    #   bias   : (dim,)                optional
    #   activation : "silu" | None
    #
    # Returns (batch, dim, seqlen) – causal 1-D convolution output.
    # ------------------------------------------------------------------
    batch, dim, seqlen, width = 4, 64, 256, 4
    dtype = torch.float32
    device = "cuda"

    x = torch.randn(batch, dim, seqlen, dtype=dtype, device=device)
    weight = torch.randn(dim, width, dtype=dtype, device=device)
    bias = torch.randn(dim, dtype=dtype, device=device)

    # --- forward (no activation) ---
    out = causal_conv1d_fn(x, weight, bias=bias, activation=None)
    assert out.shape == (batch, dim, seqlen), \
        f"Unexpected shape {out.shape}"
    assert not out.isnan().any(), "Output contains NaN"
    print(f"  ✓ forward pass (no activation)  "
          f"shape={tuple(out.shape)}  dtype={out.dtype}")

    # --- forward with SiLU activation ---
    out_silu = causal_conv1d_fn(x, weight, bias=bias, activation="silu")
    assert out_silu.shape == (batch, dim, seqlen)
    assert not out_silu.isnan().any(), "SiLU output contains NaN"
    print(f"  ✓ forward pass (silu activation) shape={tuple(out_silu.shape)}")

    # --- float16 variant ---
    x16 = x.half()
    w16 = weight.half()   # (dim, width) float16
    b16 = bias.half()
    out16 = causal_conv1d_fn(x16, w16, bias=b16, activation="silu")
    assert out16.dtype == torch.float16
    assert not out16.isnan().any(), "float16 output contains NaN"
    print(f"  ✓ forward pass (float16 + silu)  shape={tuple(out16.shape)}")

    # --- causal check: output at position t depends only on x[..., :t+1] ---
    x_mask = x.clone()
    x_mask[0, :, seqlen // 2:] = 0.0           # zero out the second half
    out_masked = causal_conv1d_fn(x_mask, weight, bias=bias, activation=None)
    # First position after the "reception field" must be identical
    check_t = width  # first position fully independent of the zeroed region
    diff = (out[0, :, :check_t] - out_masked[0, :, :check_t]).abs().max()
    assert diff < 1e-5, \
        f"Causal property violated: max diff={diff:.2e}"
    print(f"  ✓ causal property verified  (max diff over first {check_t} steps = {diff:.2e})")


# ---------------------------------------------------------------------------
# 5. flash-attn
# ---------------------------------------------------------------------------
def test_flash_attn(cuda_available: bool):
    print_section("flash-attn")

    try:
        from flash_attn import flash_attn_func
        import flash_attn as _fa_mod
        print(f"  version : {getattr(_fa_mod, '__version__', 'unknown')}")
    except ImportError as exc:
        print(f"  SKIP – flash-attn not installed ({exc})")
        return

    if not cuda_available:
        print("  SKIP – flash-attn requires CUDA")
        return

    # ------------------------------------------------------------------
    # flash_attn_func signature:
    #   q, k, v : (batch, seqlen, nheads, headdim)  float16 / bfloat16
    #   dropout_p, softmax_scale, causal
    #
    # Returns  (batch, seqlen, nheads, headdim)
    # ------------------------------------------------------------------
    device = "cuda"
    dtype = torch.float16          # flash-attn requires fp16 or bf16

    batch, seqlen, nheads, headdim = 2, 512, 8, 64

    q = torch.randn(batch, seqlen, nheads, headdim, dtype=dtype, device=device)
    k = torch.randn(batch, seqlen, nheads, headdim, dtype=dtype, device=device)
    v = torch.randn(batch, seqlen, nheads, headdim, dtype=dtype, device=device)

    # --- causal attention ---
    out = flash_attn_func(q, k, v, causal=True)
    assert out.shape == (batch, seqlen, nheads, headdim), \
        f"Unexpected shape {out.shape}"
    assert not out.isnan().any(), "Output contains NaN"
    print(f"  ✓ causal attention  shape={tuple(out.shape)}  dtype={out.dtype}")

    # --- non-causal (bidirectional) attention ---
    out_bi = flash_attn_func(q, k, v, causal=False)
    assert out_bi.shape == (batch, seqlen, nheads, headdim)
    assert not out_bi.isnan().any(), "Bidirectional output contains NaN"
    print(f"  ✓ bidirectional attention  shape={tuple(out_bi.shape)}")

    # --- bfloat16 ---
    qb = q.to(torch.bfloat16)
    kb = k.to(torch.bfloat16)
    vb = v.to(torch.bfloat16)
    out_bf16 = flash_attn_func(qb, kb, vb, causal=True)
    assert out_bf16.dtype == torch.bfloat16
    assert not out_bf16.isnan().any(), "bfloat16 output contains NaN"
    print(f"  ✓ bfloat16 causal attention  shape={tuple(out_bf16.shape)}")

    # --- numerical sanity: flash output close to naive scaled dot-product ---
    # Use a short sequence so naive attn is cheap
    slen_small = 64
    qs = q[:, :slen_small].float()
    ks = k[:, :slen_small].float()
    vs = v[:, :slen_small].float()
    scale = headdim ** -0.5
    # naive: (b, h, s, s) attention
    scores = torch.einsum("bshd,bthd->bhst", qs, ks) * scale
    # causal mask
    mask = torch.triu(torch.ones(slen_small, slen_small, device=device), diagonal=1).bool()
    scores.masked_fill_(mask.unsqueeze(0).unsqueeze(0), float("-inf"))
    attn = torch.softmax(scores, dim=-1)
    naive_out = torch.einsum("bhst,bthd->bshd", attn, vs).half()
    flash_small = flash_attn_func(
        q[:, :slen_small], k[:, :slen_small], v[:, :slen_small], causal=True
    )
    max_diff = (flash_small.float() - naive_out.float()).abs().max().item()
    # fp16 accumulation allows ~1e-2 error
    assert max_diff < 0.05, \
        f"Flash-attn deviates too much from naive attn: max_diff={max_diff:.4f}"
    print(f"  ✓ numerical check vs naive attention  max_diff={max_diff:.4f}")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    cuda_available = test_pytorch_info()
    test_tensor_ops(cuda_available)
    test_neural_network(cuda_available)
    test_causal_conv1d(cuda_available)
    test_flash_attn(cuda_available)

    print_section("Summary")
    print("  ✓ All applicable tests passed!")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except AssertionError as exc:
        print(f"\n✗ Assertion failed: {exc}", file=sys.stderr)
        sys.exit(1)
    except Exception as exc:
        import traceback
        print(f"\n✗ Fatal error: {exc}", file=sys.stderr)
        traceback.print_exc()
        sys.exit(1)
