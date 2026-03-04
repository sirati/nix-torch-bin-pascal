from __future__ import annotations

import re


_CONTAINER_PREFIX = "nvidia-container-"
_YYMM_RE = re.compile(r"^\d{2}\.\d{2}$")


def sort_version_key(v: str) -> tuple[int, ...]:
    """
    Numeric sort key for dotted version strings.

    Handles major.minor (e.g. "2.4", "2.10") and full triples
    (e.g. "2.9.1", "2.10.0") correctly — purely lexicographic comparison
    breaks for "2.10" vs "2.9".
    """
    try:
        return tuple(int(x) for x in v.split("."))
    except ValueError:
        return (0,)


def normalize_torch_compat(torch_compat: str) -> str:
    """
    Normalise a torch compat string extracted from a wheel filename.

    Regular PyTorch versions (e.g. "2.7", "2.10") are returned unchanged.

    NVIDIA container version strings use a YY.MM calendar format
    (e.g. "25.11", "26.01").  These look superficially like short PyTorch
    versions but are NOT — they are NVIDIA NGC container release identifiers
    that happen to bundle a specific PyTorch build.  To avoid any ambiguity
    they are prefixed with "nvidia-container-" so downstream Nix code and
    humans can distinguish them at a glance.

    Detection heuristic: a two-component string whose major part is >= 20 is
    treated as YY.MM.  Real PyTorch major versions will remain single-digit
    (or at most low-teens) for the foreseeable future.
    """
    if _YYMM_RE.match(torch_compat):
        major = int(torch_compat.split(".")[0])
        if major >= 20:
            return _CONTAINER_PREFIX + torch_compat
    return torch_compat


def sort_torch_compat_key(k: str) -> tuple:
    """
    Sort key for torchCompat values that may be either:

    - Regular PyTorch versions:   "2.5", "2.8", "2.10"
    - NVIDIA container versions:  "nvidia-container-25.08", "nvidia-container-26.01"

    Container versions always sort after all regular PyTorch versions.
    Within each group numeric ordering is preserved.
    """
    if k.startswith(_CONTAINER_PREFIX):
        parts = k[len(_CONTAINER_PREFIX):].split(".")
        try:
            return (1, tuple(int(x) for x in parts))
        except ValueError:
            return (1, (0,))
    parts = k.split(".")
    try:
        return (0, tuple(int(x) for x in parts))
    except ValueError:
        return (0, (0,))


def sort_pyver_key(pyver: str) -> int:
    """
    Numeric sort key for Python version attribute names.

    Examples:
        "py39"               → 39
        "py312"              → 312
        "py313-freethreaded" → 313   (free-threaded sorts after non-FT at same version
                                      because of the tuple used in the caller)
    """
    base = pyver[2:].replace("-freethreaded", "")
    try:
        return int(base)
    except ValueError:
        return 0


def sort_pyver_key_ft(pyver: str) -> tuple[int, int]:
    """
    Like sort_pyver_key but places free-threaded variants after the normal
    variant of the same Python version.

    Examples:
        "py313"              → (313, 0)
        "py313-freethreaded" → (313, 1)
    """
    is_ft = int(pyver.endswith("-freethreaded"))
    return (sort_pyver_key(pyver), is_ft)
