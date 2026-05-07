"""
Shared entry point for all package generate-hashes scripts.

Invoked by ``makeGenHashesApp`` in ``generate-hashes/lib.nix`` with the
package module path wired in automatically:

    python3 generate-hashes/main.py --pkg-module pkgs/flash-attn/generate-hashes.py [-- ...args]

Per-package ``generate-hashes.py`` files are *configuration modules*, not
scripts.  They do **not** define a ``main()``.  This file is the single entry
point for all packages.

Package module contract
-----------------------
Every ``pkgs/<name>/generate-hashes.py`` must define:

    ORIGIN_TYPE   str  – ``"github-releases"`` or ``"torch-website"``

For ``"github-releases"`` packages, additionally:

    GITHUB_REPO   str  – ``"owner/repo"`` slug

Optional overrides for ``"github-releases"``:

    WHEEL_RE                re.Pattern  – custom regex; must use the six
                                          named groups documented in
                                          ``github_release_runner/wheel_parser.py``.
                                          Defaults to the standard pattern
                                          derived from the package directory name.
    parse_wheel             callable    – fully custom parser; overrides WHEEL_RE
                                          and the shared factory entirely.
    WITH_SUBMODULES         bool        – default False
    HAS_SOURCE_HASHES       bool        – default True
    CUDA_VERSION_EXAMPLES   str         – default ``"cu11, cu12, cu13"``
    SCHEMA                  list        – default DEFAULT_SCHEMA
    DIMENSIONS              list        – default DEFAULT_DIMENSIONS
    VERSION_SPEC            DimSpec     – default DEFAULT_VERSION_SPEC

For ``"torch-website"`` packages:

    run()   callable  – called with no arguments after ``--pkg-module`` has
                        been removed from ``sys.argv``; the function parses
                        its own remaining args from ``sys.argv``.
"""
from __future__ import annotations

import argparse
import importlib.util
import os
import sys
from types import ModuleType

# Environment variable names used as fallbacks when the wrapper does not
# pass --origin-type / --github-repo (e.g. direct invocation for debugging).
_ENV_ORIGIN_TYPE  = "GEN_HASHES_ORIGIN_TYPE"
_ENV_GITHUB_REPO  = "GEN_HASHES_GITHUB_REPO"


# ---------------------------------------------------------------------------
# Module loader
# ---------------------------------------------------------------------------

def load_pkg_module(path: str) -> ModuleType:
    """
    Load a package's ``generate-hashes.py`` as an importable Python module.

    The module is executed with its own ``__file__`` set to the absolute path
    so that ``os.path.dirname(os.path.abspath(module.__file__))`` reliably
    returns the package directory.

    Parameters
    ----------
    path:
        Absolute or relative filesystem path to the ``generate-hashes.py``
        file, e.g. ``"pkgs/flash-attn/generate-hashes.py"``.

    Returns
    -------
    ModuleType
        The fully-executed module object.

    Raises
    ------
    RuntimeError
        When the path cannot be loaded as a module (missing file, syntax
        error, etc.).
    """
    abs_path = os.path.abspath(path)
    spec = importlib.util.spec_from_file_location("_pkg_generate_hashes", abs_path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Cannot load module from {path!r}")
    module = importlib.util.module_from_spec(spec)
    module.__file__ = abs_path
    spec.loader.exec_module(module)  # type: ignore[union-attr]
    return module


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _pkg_info(module: ModuleType) -> tuple[str, str, str]:
    """
    Derive ``(pkg_dir, pkg_name, pkg_path)`` from a loaded module.

    Returns
    -------
    pkg_dir:
        Absolute path to the package directory, e.g.
        ``"/…/pkgs/flash-attn"``.
    pkg_name:
        Bare directory name, e.g. ``"flash-attn"``.
    pkg_path:
        Relative path used in file headers, e.g. ``"pkgs/flash-attn"``.
    """
    pkg_dir  = os.path.dirname(os.path.abspath(module.__file__))
    pkg_name = os.path.basename(pkg_dir)
    pkg_path = "pkgs/" + pkg_name
    return pkg_dir, pkg_name, pkg_path


# ---------------------------------------------------------------------------
# github-releases runner
# ---------------------------------------------------------------------------

def _run_github_release(module: ModuleType, github_repo: str, args) -> None:
    """
    Run the full hash-generation pipeline for a ``"github-releases"`` package.

    Reads configuration from *module* attributes and delegates to
    :func:`~github_release_runner.runner.run_all_hashes`.

    Parameters
    ----------
    module:
        Loaded package configuration module.
    github_repo:
        ``"owner/repo"`` slug; injected by ``makeGenHashesApp`` from the HLD's
        ``srcOwner`` / ``srcRepo`` fields, so the module does not need to
        define ``GITHUB_REPO`` when invoked via ``nix run``.
    args:
        Parsed argument namespace from :func:`~github_release_runner.args.add_common_args`.
    """
    from github_release_runner.wheel_parser import (
        build_parse_wheel,
        make_default_wheel_re,
        DEFAULT_DIMENSIONS,
        DEFAULT_SCHEMA,
        DEFAULT_VERSION_SPEC,
    )
    from github_release_runner.runner import run_all_hashes
    from pkg_helpers import make_torch_binary_header_template

    pkg_dir, pkg_name, pkg_path = _pkg_info(module)

    # Wheel parser: prefer fully custom parse_wheel → custom WHEEL_RE → default regex
    if hasattr(module, "parse_wheel"):
        parse_wheel_fn = module.parse_wheel
    else:
        wheel_re = getattr(module, "WHEEL_RE", None) or make_default_wheel_re(pkg_name)
        parse_wheel_fn = build_parse_wheel(wheel_re)

    schema       = getattr(module, "SCHEMA",       DEFAULT_SCHEMA)
    dimensions   = getattr(module, "DIMENSIONS",   DEFAULT_DIMENSIONS)
    version_spec = getattr(module, "VERSION_SPEC", DEFAULT_VERSION_SPEC)

    has_source_hashes    = getattr(module, "HAS_SOURCE_HASHES",     True)
    with_submodules      = getattr(module, "WITH_SUBMODULES",        False)
    cuda_version_examples = getattr(module, "CUDA_VERSION_EXAMPLES", "cu11, cu12, cu13")

    binary_hashes_dir = os.path.join(pkg_dir, "binary-hashes")
    source_hashes_dir = os.path.join(pkg_dir, "source-hashes") if has_source_hashes else None

    header_template = make_torch_binary_header_template(
        github_repo=github_repo,
        pkg_path=pkg_path,
        has_source_hashes=has_source_hashes,
        cuda_version_examples=cuda_version_examples,
    )

    run_all_hashes(
        github_repo, parse_wheel_fn,
        binary_hashes_dir, source_hashes_dir,
        schema, dimensions, version_spec, header_template,
        pkg_dir, args,
        with_submodules=with_submodules,
    )


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def _resolve_str(cli_val: str | None, module: ModuleType, attr: str, env_var: str) -> str | None:
    """Return the first non-empty value from: CLI arg → module attr → env var."""
    return (
        cli_val
        or getattr(module, attr, None)
        or os.environ.get(env_var)
    ) or None


def main() -> None:
    from github_release_runner.args import add_common_args, strip_nix_shell_dashdash

    strip_nix_shell_dashdash()

    # Pull shared flags out before the package-specific argument pass so they
    # never collide with package args like --tag.
    # --origin-type and --github-repo are normally injected by makeGenHashesApp
    # from the HLD; they can also be passed manually for direct invocations.
    pre = argparse.ArgumentParser(add_help=False)
    pre.add_argument("--pkg-module", required=True, metavar="PATH",
                     help="Path to the package's generate-hashes.py module.")
    pre.add_argument("--origin-type", dest="origin_type", default=None, metavar="TYPE",
                     help="Override ORIGIN_TYPE from the HLD (github-releases|torch-website).")
    pre.add_argument("--github-repo", dest="github_repo", default=None, metavar="OWNER/REPO",
                     help="Override GITHUB_REPO from the HLD (e.g. Dao-AILab/flash-attention).")
    pre_args, remaining = pre.parse_known_args()
    sys.argv = [sys.argv[0]] + remaining

    module = load_pkg_module(pre_args.pkg_module)

    origin_type = _resolve_str(pre_args.origin_type, module, "ORIGIN_TYPE", _ENV_ORIGIN_TYPE)
    github_repo = _resolve_str(pre_args.github_repo, module, "GITHUB_REPO", _ENV_GITHUB_REPO)

    if origin_type is None:
        print(
            f"Error: origin type not known for {pre_args.pkg_module!r}.\n"
            "Provide --origin-type, set ORIGIN_TYPE in the module, or set "
            f"the {_ENV_ORIGIN_TYPE} environment variable.",
            file=sys.stderr,
        )
        sys.exit(1)

    if origin_type == "github-releases":
        if github_repo is None:
            print(
                f"Error: github repo not known for {pre_args.pkg_module!r}.\n"
                "Provide --github-repo, set GITHUB_REPO in the module, or set "
                f"the {_ENV_GITHUB_REPO} environment variable.",
                file=sys.stderr,
            )
            sys.exit(1)
        p = argparse.ArgumentParser(
            description=(
                "Generate binary-hashes and source-hashes for a "
                "GitHub-release torch-compat package."
            ),
        )
        add_common_args(p)
        args = p.parse_args()
        _run_github_release(module, github_repo, args)

    elif origin_type == "torch-website":
        if not hasattr(module, "run"):
            print(
                f"Error: torch-website module {pre_args.pkg_module!r} must define run().",
                file=sys.stderr,
            )
            sys.exit(1)
        module.run()

    else:
        print(
            f"Error: unknown origin type {origin_type!r} for {pre_args.pkg_module!r}. "
            "Expected \"github-releases\" or \"torch-website\".",
            file=sys.stderr,
        )
        sys.exit(1)


if __name__ == "__main__":
    main()
