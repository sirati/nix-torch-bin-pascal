"""causal-conv1d manual debug / test script."""

import torch


def print_section(title):
    print("\n" + "=" * 60)
    print(f"  {title}")
    print("=" * 60)


def main(cuda_available: bool):
    print_section("causal-conv1d")

    import causal_conv1d as _cc1d_mod
    from causal_conv1d import causal_conv1d_fn

    print(f"  version : {getattr(_cc1d_mod, '__version__', 'unknown')}")

    if not cuda_available:
        print("  SKIP - causal-conv1d requires CUDA")
        return "skip"

    batch, dim, seqlen, width = 4, 64, 256, 4
    dtype = torch.float32
    device = "cuda"

    x = torch.randn(batch, dim, seqlen, dtype=dtype, device=device)
    weight = torch.randn(dim, width, dtype=dtype, device=device)
    bias = torch.randn(dim, dtype=dtype, device=device)

    # --- forward (no activation) ---
    out = causal_conv1d_fn(x, weight, bias=bias, activation=None)
    assert out.shape == (batch, dim, seqlen), f"Unexpected shape {out.shape}"
    assert not out.isnan().any(), "Output contains NaN"
    print(
        f"  \u2713 forward pass (no activation)  shape={tuple(out.shape)}  dtype={out.dtype}"
    )

    # --- forward with SiLU activation ---
    out_silu = causal_conv1d_fn(x, weight, bias=bias, activation="silu")
    assert out_silu.shape == (batch, dim, seqlen)
    assert not out_silu.isnan().any(), "SiLU output contains NaN"
    print(f"  \u2713 forward pass (silu activation) shape={tuple(out_silu.shape)}")

    # --- float16 variant ---
    x16 = x.half()
    w16 = weight.half()
    b16 = bias.half()
    out16 = causal_conv1d_fn(x16, w16, bias=b16, activation="silu")
    assert out16.dtype == torch.float16
    assert not out16.isnan().any(), "float16 output contains NaN"
    print(f"  \u2713 forward pass (float16 + silu)  shape={tuple(out16.shape)}")

    # --- causal check: output at position t depends only on x[..., :t+1] ---
    x_mask = x.clone()
    x_mask[0, :, seqlen // 2 :] = 0.0
    out_masked = causal_conv1d_fn(x_mask, weight, bias=bias, activation=None)
    check_t = width
    diff = (out[0, :, :check_t] - out_masked[0, :, :check_t]).abs().max()
    assert diff < 1e-5, f"Causal property violated: max diff={diff:.2e}"
    print(
        f"  \u2713 causal property verified  (max diff over first {check_t} steps = {diff:.2e})"
    )

    return 0


if __name__ == "__main__":
    import sys

    cuda = torch.cuda.is_available()
    sys.exit(main(cuda))
