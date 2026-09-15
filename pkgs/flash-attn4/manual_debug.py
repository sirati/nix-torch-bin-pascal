"""Exercise the packaged FA4 API, including SM120 dispatch and FA2 coexistence."""

from importlib.metadata import version

import torch


def _forward(fa4, fa2, head_dim, causal, softcap):
    torch.manual_seed(41 + head_dim)
    tensors = [
        torch.randn(8, 256, 4, head_dim, device="cuda", dtype=torch.bfloat16)
        for _ in range(3)
    ]
    kwargs = dict(causal=causal, softmax_scale=1 / 16, softcap=softcap)
    output, _ = fa4(*tensors, **kwargs)
    reference = fa2(*tensors, dropout_p=0, **kwargs)
    assert output.dtype == reference.dtype == torch.bfloat16
    assert output.shape == reference.shape == tensors[0].shape
    assert torch.isfinite(output).all()
    torch.testing.assert_close(output, reference, atol=0.02, rtol=0.02)
    print(f"  PASS forward D={head_dim} causal={causal} softcap={softcap}")


def _backward(fa4, fa2):
    torch.manual_seed(42)
    tensors = [
        torch.randn(8, 256, 4, 128, device="cuda", dtype=torch.bfloat16,
                    requires_grad=True)
        for _ in range(3)
    ]
    kwargs = dict(causal=True, softmax_scale=1 / 16, softcap=0.0)
    output, _ = fa4(*tensors, **kwargs)
    reference = fa2(*tensors, dropout_p=0, **kwargs)
    upstream = torch.randn_like(output)
    gradients = torch.autograd.grad(output, tensors, upstream)
    reference_gradients = torch.autograd.grad(reference, tensors, upstream)
    for gradient, reference_gradient in zip(gradients, reference_gradients):
        assert torch.isfinite(gradient).all()
        torch.testing.assert_close(gradient, reference_gradient, atol=0.03, rtol=0.03)
    print("  PASS backward D=128 causal=True softcap=0")


def main(cuda_available: bool):
    from flash_attn import flash_attn_func as fa2
    from flash_attn.cute import __version__ as fa4_version
    from flash_attn.cute.interface import flash_attn_func as fa4

    assert fa4_version == version("flash-attn-4")
    for package in ("flash-attn", "flash-attn-4", "nvidia-cutlass-dsl",
                    "quack-kernels", "apache-tvm-ffi"):
        print(f"  {package}: {version(package)}")
    if not cuda_available:
        print("  SKIP - FA4 execution requires CUDA")
        return "skip"
    print(f"  GPU: {torch.cuda.get_device_name()} {torch.cuda.get_device_capability()}")
    for head_dim in (128, 256):
        if torch.cuda.get_device_capability() == (12, 0) and head_dim == 256:
            print("  SKIP forward D=256 on SM120: upstream requests 131072 "
                  "shared bytes; hardware permits 101376")
            continue
        for causal in (False, True):
            for softcap in (0.0, 32.0):
                _forward(fa4, fa2, head_dim, causal, softcap)
    _backward(fa4, fa2)
    torch.cuda.synchronize()
    return 0


if __name__ == "__main__":
    raise SystemExit(main(torch.cuda.is_available()))
