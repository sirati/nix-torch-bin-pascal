"""
Shared runner logic for GitHub-release binary-wheel hash generators.

Each package's ``generate-hashes.py`` is responsible only for:

  - ``ORIGIN_TYPE = "github-releases"``
  - ``GITHUB_REPO`` — ``"owner/repo"`` slug.
  - Optionally ``WHEEL_RE`` — a compiled regex with the six required named
    groups; defaults to the standard torch-compat pattern derived from the
    package directory name via :func:`~wheel_parser.make_default_wheel_re`.
  - Optionally ``WITH_SUBMODULES``, ``CUDA_VERSION_EXAMPLES``,
    ``SCHEMA``, ``DIMENSIONS``, ``VERSION_SPEC``.
  - No ``parse_wheel`` and no ``main``; the shared
    :mod:`generate-hashes.main` entry point handles both.

Sub-modules
-----------
args
    :func:`strip_nix_shell_dashdash`, :func:`add_common_args`
tags
    :func:`resolve_tags`, :func:`winning_tag_for_base_versions`
collector
    :func:`collect_all_wheels`
missing_digests
    :func:`write_missing_digests`
runner
    :func:`run_binary_hashes`, :func:`run_source_hashes`, :func:`run_all_hashes`
wheel_parser
    :func:`make_default_wheel_re`, :func:`build_parse_wheel`,
    :data:`DEFAULT_SCHEMA`, :data:`DEFAULT_DIMENSIONS`, :data:`DEFAULT_VERSION_SPEC`
"""
from github_release_runner.args import strip_nix_shell_dashdash, add_common_args
from github_release_runner.tags import resolve_tags, winning_tag_for_base_versions
from github_release_runner.collector import collect_all_wheels
from github_release_runner.missing_digests import write_missing_digests
from github_release_runner.runner import run_binary_hashes, run_source_hashes, run_all_hashes
from github_release_runner.wheel_parser import (
    make_default_wheel_re,
    build_parse_wheel,
    DEFAULT_SCHEMA,
    DEFAULT_DIMENSIONS,
    DEFAULT_VERSION_SPEC,
)
from source_fetcher import fetch_github_source_hashes_with_submodules_batch

__all__ = [
    "strip_nix_shell_dashdash",
    "add_common_args",
    "resolve_tags",
    "winning_tag_for_base_versions",
    "collect_all_wheels",
    "write_missing_digests",
    "run_binary_hashes",
    "run_source_hashes",
    "run_all_hashes",
    "make_default_wheel_re",
    "build_parse_wheel",
    "DEFAULT_SCHEMA",
    "DEFAULT_DIMENSIONS",
    "DEFAULT_VERSION_SPEC",
    "fetch_github_source_hashes_with_submodules_batch",
]
