"""
Package-level helpers for GitHub-release binary-wheel hash generators.

Provides two utilities that every ``pkgs/*/generate-hashes.py`` script needs:

1. :func:`pkg_hash_dirs` — canonical ``binary-hashes/`` and ``source-hashes/``
   directory paths relative to the package's own ``__file__``.

2. :func:`make_torch_binary_header_template` — builds the standard header
   comment block written at the top of every generated ``v{version}.nix``
   file for packages that depend on PyTorch.  All such packages share the
   same structure (cudaVersion → torchCompat → pyVer → os → arch) so the
   header is almost identical across packages; only the GitHub repo URL,
   the regenerate-command path, and the cuda-version examples differ.

Typical usage
-------------

    import os
    from pkg_helpers import make_torch_binary_header_template, pkg_hash_dirs

    GITHUB_REPO = "Dao-AILab/causal-conv1d"
    _HERE = os.path.dirname(os.path.abspath(__file__))

    BINARY_HASHES_DIR, SOURCE_HASHES_DIR = pkg_hash_dirs(_HERE)

    BINARY_HEADER_TEMPLATE = make_torch_binary_header_template(
        github_repo=GITHUB_REPO,
        pkg_path="pkgs/causal-conv1d",
        has_source_hashes=True,
    )
"""
from __future__ import annotations

import os


# ---------------------------------------------------------------------------
# Canonical output-directory paths
# ---------------------------------------------------------------------------

def pkg_hash_dirs(here: str) -> tuple[str, str]:
    """
    Return ``(binary_hashes_dir, source_hashes_dir)`` for a package.

    Both directories are always named ``binary-hashes`` and ``source-hashes``
    and live directly inside the package folder — no package should deviate
    from this convention.

    Parameters
    ----------
    here:
        Absolute path to the package directory, typically obtained via
        ``os.path.dirname(os.path.abspath(__file__))`` inside the package's
        ``generate-hashes.py``.

    Returns
    -------
    tuple[str, str]
        ``(binary_hashes_dir, source_hashes_dir)`` — both are absolute paths.
    """
    return (
        os.path.join(here, "binary-hashes"),
        os.path.join(here, "source-hashes"),
    )


# ---------------------------------------------------------------------------
# Standard binary-hashes file header for torch-dependent packages
# ---------------------------------------------------------------------------

def make_torch_binary_header_template(
    github_repo: str,
    pkg_path: str,
    has_source_hashes: bool = False,
    cuda_version_examples: str = "cu11, cu12, cu13",
) -> str:
    """
    Build the standard header comment template for a torch-dependent package's
    ``binary-hashes/v{version}.nix`` files.

    The returned string is a *template* — it still contains the ``{version}``
    placeholder used by :func:`~nix_writer.write_binary_hashes_per_version`
    when it writes each per-version file.  The ``{{ }}`` sequences in the Nix
    attribute-set examples are double-brace escapes that become literal
    ``{ }`` after ``.format(version=…)`` is applied.

    Parameters
    ----------
    github_repo:
        ``owner/name`` slug, e.g. ``"Dao-AILab/causal-conv1d"``.  Used to
        build the ``# Source:`` URL.
    pkg_path:
        Relative path to the package directory from the project root, e.g.
        ``"pkgs/causal-conv1d"``.  Used to build the regenerate command.
    has_source_hashes:
        When ``True`` the regenerate command includes ``--skip-source`` so
        the reader knows that omitting the flag would also regenerate source
        hashes.  Set to ``False`` (default) for packages that have no source
        hashes (e.g. flash-attn).
    cuda_version_examples:
        Comma-separated example cuda-version keys for the ``cudaVersion``
        comment line, e.g. ``"cu11, cu12, cu13"`` (default) or
        ``"cu12, cu126"``.

    Returns
    -------
    str
        Multi-line header template string, suitable for use as the
        ``header_template`` argument of :func:`~nix_writer.write_binary_hashes_per_version`.
    """
    flags = "--skip-source --tag" if has_source_hashes else "--tag"
    cuda_note = (
        f"CUDA major[minor] the wheel was compiled against "
        f"(e.g. {cuda_version_examples})."
    )
    return "\n".join([
        "# WARNING: Auto-generated file. Do not edit manually!",
        f"# Source:  https://github.com/{github_repo}/releases",
        f"# To regenerate: nix-shell {pkg_path}/generate-hashes.py [-- {flags} v{{version}}]",
        "#",
        "# Structure: cudaVersion -> torchCompat -> pyVer -> os -> arch",
        "#",
        f"#   cudaVersion: {cuda_note}",
        "#   torchCompat: torch major.minor the wheel was compiled against.",
        "#   pyVer:       py39, py310, \u2026  (CPython only; no free-threaded variants).",
        "#   os:          linux  (only Linux wheels provided as pre-built binaries)",
        "#   arch:        x86_64, aarch64",
        "#",
        "# Each leaf node contains the TRUE cxx11abi (new ABI) wheel data:",
        "#   {{ name, url, hash }}",
        "# When a FALSE cxx11abi (pre-cxx11 ABI) wheel also exists it is embedded as:",
        "#   {{ name, url, hash, precx11abi = {{ name, url, hash }}; }}",
    ])
