"""PyTorch manual debug / test script."""

import torch


def print_section(title):
    print("\n" + "=" * 60)
    print(f"  {title}")
    print("=" * 60)


def main(cuda_available: bool):
    # --- Info ---
    print_section("PyTorch Installation Info")
    print(f"  PyTorch version : {torch.__version__}")
    print(f"  CUDA available  : {cuda_available}")
    if cuda_available:
        print(f"  CUDA version    : {torch.version.cuda}")
        print(f"  cuDNN version   : {torch.backends.cudnn.version()}")
        print(f"  GPU count       : {torch.cuda.device_count()}")
        for i in range(torch.cuda.device_count()):
            props = torch.cuda.get_device_properties(i)
            print(
                f"  GPU {i}  : {props.name}  "
                f"cc={props.major}.{props.minor}  "
                f"mem={props.total_memory / 1024**3:.1f} GiB"
            )
    else:
        print("  (no CUDA - running in CPU-only mode)")

    # --- Tensor ops + autograd ---
    print_section("Tensor Operations + Autograd")

    a = torch.randn(128, 128)
    b = torch.randn(128, 128)
    c = torch.mm(a, b)
    assert c.shape == (128, 128), "CPU matmul shape mismatch"
    print("  \u2713 CPU matrix multiplication (128\u00d7128)")

    x = torch.randn(4, 4, requires_grad=True)
    loss = (x**2).sum()
    loss.backward()
    assert x.grad is not None, "Gradient is None"
    print("  \u2713 Autograd backward pass")

    if cuda_available:
        a_gpu = a.cuda()
        b_gpu = b.cuda()
        c_gpu = torch.mm(a_gpu, b_gpu)
        assert c_gpu.device.type == "cuda"
        assert torch.allclose(c_gpu.cpu(), c, atol=1e-4), (
            "GPU/CPU matmul results differ"
        )
        print("  \u2713 GPU matrix multiplication (128\u00d7128, matches CPU)")

        big = torch.randn(1024, 1024, device="cuda")
        out = torch.mm(big, big)
        assert out.shape == (1024, 1024)
        print("  \u2713 GPU matrix multiplication stress (1024\u00d71024)")

    # --- Neural network ---
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
    print(
        f"  \u2713 Forward pass  input={tuple(x.shape)} \u2192 output={tuple(y_hat.shape)}"
        f"  device={device}"
    )

    loss = y_hat.sum()
    loss.backward()
    for name, p in model.named_parameters():
        assert p.grad is not None, f"Gradient missing for {name}"
    print("  \u2713 Backward pass - all parameter gradients present")

    return 0


if __name__ == "__main__":
    import sys

    cuda = torch.cuda.is_available()
    sys.exit(main(cuda))
