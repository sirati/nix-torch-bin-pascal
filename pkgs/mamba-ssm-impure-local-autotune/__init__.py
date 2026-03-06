"""
mamba_ssm_autotune – Nix-managed triton autotuning cache for mamba-ssm.

This module is imported automatically by its ``.pth`` hook on every Python
startup in any Nix environment that includes
``mamba-ssm-impure-local-autotune``.  It configures ``TRITON_CACHE_DIR`` to a
stable, per-environment directory under ``~/.cache/nix-mamba-autotune/`` before
triton initialises, so that pre-warmed kernel configurations are always picked
up without any manual setup.

The cache path is derived from the Nix store path of this file, which encodes
the full input closure of the environment (mamba-ssm version, triton version,
CUDA label, Python version, …).  Two environments that differ in any of those
dimensions therefore get separate caches — there is no cross-contamination of
autotuned configurations.  Rebuilding an unchanged environment reuses the
existing warm cache.

``TRITON_CACHE_DIR`` is set only if it has not already been set by the user,
so any explicit override (e.g. ``export TRITON_CACHE_DIR=/tmp/foo``) takes
precedence.

To pre-warm the cache (requires a local GPU, run once per environment):

    python -m mamba_ssm_autotune
"""

import os as _os


def _configure_triton_cache() -> None:
    import hashlib as _hl

    # __file__ is a Nix store path such as:
    #   /nix/store/abc123...-python3.13-mamba-ssm-impure-local-autotune-.../
    #     lib/python3.13/site-packages/mamba_ssm_autotune/__init__.py
    #
    # The leading hash component encodes the entire build-time input closure, so
    # this key is unique per distinct Nix environment without any extra hashing.
    _key = _hl.sha256(__file__.encode()).hexdigest()[:24]
    _cache = _os.path.join(
        _os.path.expanduser("~"), ".cache", "nix-mamba-autotune", _key
    )
    _os.environ.setdefault("TRITON_CACHE_DIR", _cache)


_configure_triton_cache()
del _configure_triton_cache
