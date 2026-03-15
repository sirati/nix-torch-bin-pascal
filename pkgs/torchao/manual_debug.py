"""torchao manual debug / test script."""

import torch


def print_section(title):
    print("\n" + "=" * 60)
    print(f"  {title}")
    print("=" * 60)


def main(cuda_available: bool):
    print_section("torchao")

    try:
        import torchao

        print(f"  version : {getattr(torchao, '__version__', 'unknown')}")
    except ImportError as exc:
        print(f"  SKIP - torchao not installed ({exc})")
        return 0

    if not cuda_available:
        print("  SKIP - torchao requires CUDA")
        return 0

    import torch.nn as nn
    from torchao.quantization import Int8WeightOnlyConfig, quantize_

    # Create a simple model and quantize it with int8 weight-only
    model = nn.Sequential(
        nn.Linear(256, 128),
        nn.GELU(),
        nn.Linear(128, 64),
    ).to(device="cuda", dtype=torch.bfloat16)

    # Run baseline forward pass
    x = torch.randn(4, 256, dtype=torch.bfloat16, device="cuda")
    out_baseline = model(x)
    assert out_baseline.shape == (4, 64)
    print(f"  \u2713 baseline forward pass  shape={tuple(out_baseline.shape)}")

    # Quantize in-place
    quantize_(model, Int8WeightOnlyConfig())
    out_quantized = model(x)
    assert out_quantized.shape == (4, 64), f"Unexpected shape {out_quantized.shape}"
    assert not out_quantized.isnan().any(), "Quantized output contains NaN"
    max_diff = (out_quantized.float() - out_baseline.float()).abs().max().item()
    print(
        f"  \u2713 int8 weight-only quantized forward pass  shape={tuple(out_quantized.shape)}  "
        f"max_diff={max_diff:.4f}"
    )

    return 0


if __name__ == "__main__":
    import sys

    cuda = torch.cuda.is_available()
    sys.exit(main(cuda))
