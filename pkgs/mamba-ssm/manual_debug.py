"""mamba-ssm manual debug / test script."""

import torch


def print_section(title):
    print("\n" + "=" * 60)
    print(f"  {title}")
    print("=" * 60)


def main(cuda_available: bool):
    print_section("mamba-ssm")

    import mamba_ssm

    print(f"  version : {getattr(mamba_ssm, '__version__', 'unknown')}")

    if not cuda_available:
        print("  SKIP - mamba-ssm requires CUDA")
        return "skip"

    from mamba_ssm import Mamba

    batch, seqlen, dim = 2, 128, 64
    device = "cuda"
    dtype = torch.float32

    model = Mamba(d_model=dim, d_state=16, d_conv=4, expand=2).to(
        device=device, dtype=dtype
    )

    x = torch.randn(batch, seqlen, dim, dtype=dtype, device=device)
    out = model(x)
    assert out.shape == (batch, seqlen, dim), f"Unexpected shape {out.shape}"
    assert not out.isnan().any(), "Output contains NaN"
    print(f"  \u2713 Mamba forward pass  shape={tuple(out.shape)}  dtype={out.dtype}")

    # Backward pass
    loss = out.sum()
    loss.backward()
    grad_count = sum(1 for p in model.parameters() if p.grad is not None)
    total_count = sum(1 for _ in model.parameters())
    assert grad_count == total_count, f"Missing gradients: {grad_count}/{total_count}"
    print(f"  \u2713 Mamba backward pass  gradients={grad_count}/{total_count}")

    # float16 variant
    model_fp16 = Mamba(d_model=dim, d_state=16, d_conv=4, expand=2).to(
        device=device, dtype=torch.float16
    )
    x_fp16 = x.half()
    out_fp16 = model_fp16(x_fp16)
    assert out_fp16.dtype == torch.float16
    assert not out_fp16.isnan().any(), "float16 output contains NaN"
    print(f"  \u2713 Mamba float16 forward pass  shape={tuple(out_fp16.shape)}")

    return 0


if __name__ == "__main__":
    import sys

    cuda = torch.cuda.is_available()
    sys.exit(main(cuda))
