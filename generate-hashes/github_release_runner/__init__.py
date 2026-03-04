"""
Shared runner logic for GitHub-release binary-wheel hash generators.

Each package's ``generate-hashes.py`` is responsible only for:

  - Package-specific constants (GITHUB_REPO, SCHEMA, DIMENSIONS, …).
  - A ``parse_wheel(entry) -> (key, cxx11abi, path_dict, leaf) | None`` function.
  - A thin ``main()`` that calls the helpers here.

Typical package main()
----------------------

    from github_release_runner import (
        strip_nix_shell_dashdash,
        add_common_args,
        resolve_tags,
        collect_all_wheels,
        write_missing_digests,
        run_binary_hashes,
    )

    def main() -> None:
        strip_nix_shell_dashdash()

        p = argparse.ArgumentParser(...)
        add_common_args(p)
        # add package-specific flags here, e.g. --skip-source
        args = p.parse_args()

        tags, too_old_tags = resolve_tags(GITHUB_REPO, args)
        all_raw, missing_tags = collect_all_wheels(GITHUB_REPO, tags, args.token, parse_wheel)
        write_missing_digests(_HERE, missing_tags, too_old_tags)
        organized = run_binary_hashes(
            all_raw, OUTPUT_DIR, SCHEMA, DIMENSIONS, VERSION_SPEC, HEADER_TEMPLATE,
        )
        # optional post-step, e.g. source hashes:
        # if not args.skip_source:
        #     run_source_hashes(organized, tags, SOURCE_HASHES_DIR, OWNER, REPO)

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
    :func:`run_binary_hashes`
"""
from github_release_runner.args import strip_nix_shell_dashdash, add_common_args
from github_release_runner.tags import resolve_tags, winning_tag_for_base_versions
from github_release_runner.collector import collect_all_wheels
from github_release_runner.missing_digests import write_missing_digests
from github_release_runner.runner import run_binary_hashes, run_source_hashes, run_all_hashes

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
]
