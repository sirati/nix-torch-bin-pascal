"""bitsandbytes manual debug / test script."""

import torch


def print_section(title):
    print("\n" + "=" * 60)
    print(f"  {title}")
    print("=" * 60)


def main(cuda_available: bool):
    print_section("bitsandbytes")

    import bitsandbytes as bnb

    print(f"  version : {getattr(bnb, '__version__', 'unknown')}")

    if not cuda_available:
        print("  SKIP - bitsandbytes requires CUDA")
        return "skip"

    # --- 4-bit quantization ---
    weight = torch.randn(128, 256, dtype=torch.float16, device="cuda")
    qweight4, quant_state4 = bnb.functional.quantize_4bit(weight)
    dequantized4 = bnb.functional.dequantize_4bit(qweight4, quant_state4)
    assert dequantized4.shape == weight.shape, (
        f"Dequantized shape mismatch: {dequantized4.shape} vs {weight.shape}"
    )
    max_diff4 = (dequantized4.float() - weight.float()).abs().max().item()
    print(
        f"  \u2713 4-bit quantize/dequantize  shape={tuple(dequantized4.shape)}  "
        f"max_diff={max_diff4:.4f}"
    )

    # --- Linear4bit layer ---
    import bitsandbytes as bnb

    linear_4bit = bnb.nn.Linear4bit(256, 128, compute_dtype=torch.float16).cuda()
    x = torch.randn(4, 256, dtype=torch.float16, device="cuda")
    out = linear_4bit(x)
    assert out.shape == (4, 128), f"Unexpected shape {out.shape}"
    assert not out.isnan().any(), "Output contains NaN"
    print(
        f"  \u2713 Linear4bit forward pass  shape={tuple(out.shape)}  dtype={out.dtype}"
    )

    return 0


if __name__ == "__main__":
    import sys

    cuda = torch.cuda.is_available()
    sys.exit(main(cuda))
