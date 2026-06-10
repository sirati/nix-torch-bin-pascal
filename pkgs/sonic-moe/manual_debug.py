"""sonic-moe manual debug / test script."""

import torch


def print_section(title):
    print("\n" + "=" * 60)
    print(f"  {title}")
    print("=" * 60)


def main(cuda_available: bool):
    print_section("sonic-moe")

    import sonicmoe

    print(f"  version : {getattr(sonicmoe, '__version__', 'unknown')}")

    if not cuda_available:
        print("  SKIP - sonic-moe requires CUDA")
        return "skip"

    cap = torch.cuda.get_device_capability(0)
    if cap < (9, 0):
        print(f"  SKIP - sonic-moe requires SM90+ (Hopper/Blackwell), got SM{cap[0]}{cap[1]}")
        return "skip"

    from sonicmoe import MoE, KernelBackendMoE
    from sonicmoe.enums import ActivationType

    torch.manual_seed(0)
    device = "cuda"
    dtype = torch.bfloat16

    # tokens, hidden, intermediate, experts, top-k
    T, H, I, E, K = 4096, 1024, 512, 32, 4

    moe = MoE(
        num_experts=E,
        num_experts_per_tok=K,
        hidden_size=H,
        intermediate_size=I,
        activation_function=ActivationType.SWIGLU,
        add_bias=False,
        std=0.02,
    ).to(device=device, dtype=dtype)

    x = torch.randn(T, H, device=device, dtype=dtype, requires_grad=True)

    # Forward (CuTeDSL kernels JIT-compile on first call)
    out, aux_loss = moe(x, kernel_backend_moe=KernelBackendMoE.sonicmoe)
    assert out.shape == (T, H), f"Unexpected shape {out.shape}"
    assert torch.isfinite(out.float()).all(), "Output contains non-finite values"
    print(f"  ✓ MoE forward pass  shape={tuple(out.shape)}  dtype={out.dtype}")

    # Backward
    loss = out.float().square().mean()
    if aux_loss is not None:
        loss = loss + aux_loss.float()
    loss.backward()
    assert x.grad is not None and torch.isfinite(x.grad.float()).all(), "bad input grad"
    for name, p in moe.named_parameters():
        assert p.grad is not None, f"missing grad: {name}"
        assert torch.isfinite(p.grad.float()).all(), f"non-finite grad: {name}"
    print(f"  ✓ MoE backward pass  loss={loss.item():.6f}")
