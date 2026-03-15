"""flash-attn manual debug / test script."""

import torch


def print_section(title):
    print("\n" + "=" * 60)
    print(f"  {title}")
    print("=" * 60)


def main(cuda_available: bool):
    print_section("flash-attn")

    try:
        import flash_attn as _fa_mod
        from flash_attn import flash_attn_func

        print(f"  version : {getattr(_fa_mod, '__version__', 'unknown')}")
    except ImportError as exc:
        print(f"  SKIP - flash-attn not installed ({exc})")
        return 0

    if not cuda_available:
        print("  SKIP - flash-attn requires CUDA")
        return 0

    device = "cuda"
    dtype = torch.float16

    batch, seqlen, nheads, headdim = 2, 512, 8, 64

    q = torch.randn(batch, seqlen, nheads, headdim, dtype=dtype, device=device)
    k = torch.randn(batch, seqlen, nheads, headdim, dtype=dtype, device=device)
    v = torch.randn(batch, seqlen, nheads, headdim, dtype=dtype, device=device)

    # --- causal attention ---
    out = flash_attn_func(q, k, v, causal=True)
    assert out.shape == (batch, seqlen, nheads, headdim), (
        f"Unexpected shape {out.shape}"
    )
    assert not out.isnan().any(), "Output contains NaN"
    print(f"  \u2713 causal attention  shape={tuple(out.shape)}  dtype={out.dtype}")

    # --- non-causal (bidirectional) attention ---
    out_bi = flash_attn_func(q, k, v, causal=False)
    assert out_bi.shape == (batch, seqlen, nheads, headdim)
    assert not out_bi.isnan().any(), "Bidirectional output contains NaN"
    print(f"  \u2713 bidirectional attention  shape={tuple(out_bi.shape)}")

    # --- bfloat16 ---
    qb = q.to(torch.bfloat16)
    kb = k.to(torch.bfloat16)
    vb = v.to(torch.bfloat16)
    out_bf16 = flash_attn_func(qb, kb, vb, causal=True)
    assert out_bf16.dtype == torch.bfloat16
    assert not out_bf16.isnan().any(), "bfloat16 output contains NaN"
    print(f"  \u2713 bfloat16 causal attention  shape={tuple(out_bf16.shape)}")

    # --- numerical sanity: flash output close to naive scaled dot-product ---
    slen_small = 64
    qs = q[:, :slen_small].float()
    ks = k[:, :slen_small].float()
    vs = v[:, :slen_small].float()
    scale = headdim**-0.5
    scores = torch.einsum("bshd,bthd->bhst", qs, ks) * scale
    mask = torch.triu(
        torch.ones(slen_small, slen_small, device=device), diagonal=1
    ).bool()
    scores.masked_fill_(mask.unsqueeze(0).unsqueeze(0), float("-inf"))
    attn = torch.softmax(scores, dim=-1)
    naive_out = torch.einsum("bhst,bthd->bshd", attn, vs).half()
    flash_small = flash_attn_func(
        q[:, :slen_small], k[:, :slen_small], v[:, :slen_small], causal=True
    )
    max_diff = (flash_small.float() - naive_out.float()).abs().max().item()
    assert max_diff < 0.05, (
        f"Flash-attn deviates too much from naive attn: max_diff={max_diff:.4f}"
    )
    print(f"  \u2713 numerical check vs naive attention  max_diff={max_diff:.4f}")

    return 0


if __name__ == "__main__":
    import sys

    cuda = torch.cuda.is_available()
    sys.exit(main(cuda))
