from __future__ import annotations

import sys

from common.versions import deduplicate_post_versions
from nix_writer.schema import DimSpec
from nix_writer.organise import organize_wheels
from nix_writer.per_version import write_binary_hashes_per_version


def run_binary_hashes(
    all_raw_entries: list[tuple[dict, dict]],
    binary_hashes_dir: str,
    schema: list[DimSpec],
    dimensions: list[str],
    version_spec: DimSpec,
    header_template: str,
) -> dict:
    """
    Deduplicate post-releases, organise entries and write per-version
    ``binary-hashes/v{version}.nix`` files.

    Parameters
    ----------
    all_raw_entries:
        Flat list of ``(path_dict, leaf)`` pairs as returned by
        :func:`~github_release_runner.collector.collect_all_wheels`.
    binary_hashes_dir:
        Directory to write ``v{version}.nix`` files into (created if absent).
    schema:
        List of :class:`~nix_writer.schema.DimSpec` objects describing the
        nesting levels *inside* each version block (i.e. not including the
        version level itself).
    dimensions:
        Ordered list of dimension names including ``"version"`` as the first
        element.
    version_spec:
        :class:`~nix_writer.schema.DimSpec` for the version level (used for
        sort ordering only).
    header_template:
        Comment block written at the top of every generated file.  May
        contain a ``{version}`` placeholder.

    Returns
    -------
    dict
        The organised nested dict keyed by version, as produced by
        :func:`~nix_writer.organise.organize_wheels`.  Useful for callers
        that need to enumerate versions afterwards (e.g. for source-hash
        generation).

    Exits
    -----
    Calls ``sys.exit(1)`` when *all_raw_entries* is empty after deduplication
    so the caller does not need to check.
    """
    if not all_raw_entries:
        print(
            "No TRUE-ABI wheels matched across all tags — check tag names.",
            file=sys.stderr,
        )
        sys.exit(1)

    deduped = deduplicate_post_versions(all_raw_entries)
    print(
        f"\n{len(all_raw_entries)} raw wheel entries → "
        f"{len(deduped)} after post-version deduplication.",
        file=sys.stderr,
    )

    organized = organize_wheels(deduped, dimensions)
    write_binary_hashes_per_version(
        binary_hashes_dir,
        organized,
        schema,
        header_template,
        version_spec,
        prefix_attrs_fn=lambda version: {"_version": version},
    )
    return organized
