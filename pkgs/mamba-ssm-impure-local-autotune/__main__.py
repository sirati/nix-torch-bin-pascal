"""
Warm the triton kernel autotune cache for mamba-ssm in this Nix environment.

Run once (requires a local NVIDIA GPU) to pre-compute triton kernel
configurations for common mamba-ssm input shapes.  Subsequent mamba-ssm
calls in the same Nix environment will load the cached configurations and
skip the slow first-run autotuning.

Usage::

    python -m mamba_ssm_autotune [options]

Options:
  --seq-lens L1,L2,...   sequence lengths to warm up (default: 64,128,256,512,1024)
  --d-model D            model dimension (default: 64)
  --fp16 / --fp32        dtype to use (default: fp16)

The triton cache is stored at::

    ~/.cache/nix-mamba-autotune/<env-key>/

where <env-key> is derived from the Nix store path of this environment, so
each distinct (mamba-ssm version, triton version, CUDA, Python) combination
gets an isolated cache.  The cache location is printed at startup.
"""

import sys
import os
import argparse

# Importing the package ensures TRITON_CACHE_DIR is configured even when this
# module is invoked directly (e.g. python __main__.py) rather than via the
# .pth hook.
import mamba_ssm_autotune  # noqa: F401 – side-effect: sets TRITON_CACHE_DIR


def _main() -> None:
    parser = argparse.ArgumentParser(
        prog="python -m mamba_ssm_autotune",
        description="Pre-warm the triton autotune cache for mamba-ssm.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--seq-lens",
        default="64,128,256,512,1024",
        metavar="L1[,L2,...]",
        help="comma-separated sequence lengths to autotune (default: 64,128,256,512,1024)",
    )
    parser.add_argument(
        "--d-model",
        type=int,
        default=64,
        metavar="D",
        help="model inner dimension for autotuning (default: 64)",
    )
    dtype_group = parser.add_mutually_exclusive_group()
    dtype_group.add_argument(
        "--fp16",
        dest="dtype",
        action="store_const",
        const="fp16",
        default="fp16",
        help="use float16 (default)",
    )
    dtype_group.add_argument(
        "--fp32",
        dest="dtype",
        action="store_const",
        const="fp32",
        help="use float32",
    )
    args = parser.parse_args()

    seq_lens = [int(s.strip()) for s in args.seq_lens.split(",")]
    cache_dir = os.environ.get("TRITON_CACHE_DIR", "(triton default)")

    print(f"Triton cache dir : {cache_dir}")
    print(f"d_model          : {args.d_model}")
    print(f"dtype            : {args.dtype}")
    print(f"seq_lens         : {seq_lens}")
    print()

    # ── torch ──────────────────────────────────────────────────────────────
    try:
        import torch
    except ImportError:
        print("ERROR: torch is not available in this environment.", file=sys.stderr)
        sys.exit(1)

    if not torch.cuda.is_available():
        print(
            "ERROR: No CUDA GPU found.\n"
            "       This warmup step must be run on a machine with an NVIDIA GPU.",
            file=sys.stderr,
        )
        sys.exit(1)

    device = torch.device("cuda")
    props = torch.cuda.get_device_properties(0)
    print(f"GPU              : {props.name}  cc={props.major}.{props.minor}"
          f"  mem={props.total_memory / 1024**3:.1f} GiB")
    print(f"torch            : {torch.__version__}")

    dtype = torch.float16 if args.dtype == "fp16" else torch.float32

    # ── mamba-ssm ──────────────────────────────────────────────────────────
    try:
        from mamba_ssm.modules.mamba2 import Mamba2
        import mamba_ssm
        print(f"mamba_ssm        : {mamba_ssm.__version__}")
    except ImportError as exc:
        print(f"ERROR: mamba_ssm is not importable: {exc}", file=sys.stderr)
        sys.exit(1)

    # ── triton ─────────────────────────────────────────────────────────────
    try:
        import triton
        print(f"triton           : {triton.__version__}")
    except ImportError as exc:
        print(f"ERROR: triton is not importable: {exc}", file=sys.stderr)
        sys.exit(1)

    print()

    # ── Build a small Mamba2 model ─────────────────────────────────────────
    # d_state=16, d_conv=4, expand=2 are the typical defaults; d_model is
    # intentionally small so the warmup is fast regardless of GPU memory.
    model = Mamba2(
        d_model=args.d_model,
        d_state=16,
        d_conv=4,
        expand=2,
    ).to(device=device, dtype=dtype)
    model.eval()

    # ── Forward pass for each requested sequence length ────────────────────
    # The first forward for each (shape, config) combination triggers triton
    # autotuning; results are written to TRITON_CACHE_DIR automatically.
    errors: list[tuple[int, Exception]] = []

    with torch.no_grad():
        for seq_len in seq_lens:
            print(f"  warming seq_len={seq_len:6d} ...", end="", flush=True)
            try:
                x = torch.randn(
                    1, seq_len, args.d_model,
                    device=device, dtype=dtype,
                )
                model(x)
                print("  ok")
            except Exception as exc:  # noqa: BLE001
                print(f"  FAILED: {exc}")
                errors.append((seq_len, exc))

    # ── Summary ────────────────────────────────────────────────────────────
    print()
    if errors:
        print(f"WARNING: {len(errors)} shape(s) failed:", file=sys.stderr)
        for seq_len, exc in errors:
            print(f"  seq_len={seq_len}: {exc}", file=sys.stderr)
        print()

    ok = len(seq_lens) - len(errors)
    print(f"Warmup complete: {ok}/{len(seq_lens)} shapes succeeded.")
    print(f"Triton cache    : {cache_dir}")
    print()
    print("Subsequent mamba-ssm calls in this Nix environment will use the")
    print("cached kernel configurations and skip autotuning.")

    if errors:
        sys.exit(1)


if __name__ == "__main__":
    _main()
