from __future__ import annotations

import sys

from common.versions import deduplicate_post_versions, parse_version_post
from common.sort_keys import sort_version_key
from nix_writer.schema import DimSpec
from nix_writer.organise import organize_wheels
from nix_writer.per_version import write_binary_hashes_per_version
from source_fetcher import (
    SourceEntry,
    fetch_github_source_hash,
    fetch_github_source_hash_with_submodules,
    fetch_github_source_hashes_with_submodules_batch,
    source_hash_exists,
    write_source_hash_file,
)


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


def _winning_tags_from_tags(tags: list[str]) -> dict[str, str]:
    """Map each base version to its highest .postN tag."""
    best: dict[str, tuple[int, str]] = {}
    for tag in tags:
        raw = tag.lstrip("v")
        base, post_num = parse_version_post(raw)
        existing = best.get(base)
        if existing is None or post_num > existing[0]:
            best[base] = (post_num, tag)
    return {base: t for base, (_, t) in best.items()}


def run_source_hashes(
    tags: list[str],
    source_hashes_dir: str,
    github_repo: str,
    args,
    with_submodules: bool = False,
) -> None:
    """
    Fetch and write per-version ``source-hashes/v{version}.nix`` files.

    Skips immediately when ``args.skip_source`` is ``True``.
    Skips individual versions whose file already exists on disk.

    When *with_submodules* is ``True`` and more than one tag needs to be
    fetched (i.e. ``--tag`` was *not* supplied), the batch variant
    :func:`~source_fetcher.fetch_github_source_hashes_with_submodules_batch`
    is used.  It clones the repository once and reuses that local mirror for
    all tags, saving a full network clone per tag.  For the single-tag case
    (``--tag`` supplied) the original
    :func:`~source_fetcher.fetch_github_source_hash_with_submodules` is used
    unchanged so callers do not need ``nix-prefetch-git`` in their nix-shell.

    Parameters
    ----------
    tags:
        Valid release tags as returned by :func:`~github_release_runner.tags.resolve_tags`.
        Both bare (``v1.5.0``) and post-release (``v1.5.0.post8``) tags are
        accepted; only the winning tag per base version is fetched.
    source_hashes_dir:
        Directory to write ``v{version}.nix`` files into.
    github_repo:
        ``owner/name`` slug — split to derive *owner* and *repo*.
    args:
        Parsed arguments namespace.  ``args.skip_source`` is honoured.
    with_submodules:
        When ``True``, compute the hash via the submodule-aware path instead
        of the default tarball fetch.  Use this for packages whose
        ``fetchFromGitHub`` sets ``fetchSubmodules = true`` (e.g. flash-attn).
    """
    if getattr(args, "skip_source", False):
        print("\nSkipping source-hash generation (--skip-source).", file=sys.stderr)
        return

    owner, repo = github_repo.split("/", 1)
    winning_tags = _winning_tags_from_tags(tags)

    # Partition: already-cached vs. needs fetching
    to_fetch: dict[str, str] = {}   # base_version → winning_tag
    print(file=sys.stderr)
    for base_version in sorted(winning_tags.keys(), key=sort_version_key):
        if source_hash_exists(source_hashes_dir, base_version):
            print(
                f"  source-hashes/v{base_version}.nix already exists — skipping.",
                file=sys.stderr,
            )
        else:
            to_fetch[base_version] = winning_tags[base_version]

    if not to_fetch:
        return

    # Choose batch vs. single-tag strategy.
    # Batch is used when:
    #   (a) the package requires submodules (with_submodules=True), AND
    #   (b) --tag was not supplied (i.e. we have multiple tags to fetch).
    # Single-tag mode keeps the original nix-prefetch-github path so the
    # caller's nix-shell only needs nix-prefetch-github, not nix-prefetch-git.
    use_batch = with_submodules and not getattr(args, "tag", None) and len(to_fetch) > 1

    if use_batch:
        # Ordered list of tags to pass to the batch fetcher (sorted by version
        # so progress output is deterministic).
        ordered_tags = [
            to_fetch[base]
            for base in sorted(to_fetch.keys(), key=sort_version_key)
        ]
        try:
            batch_results = fetch_github_source_hashes_with_submodules_batch(
                owner, repo, ordered_tags,
            )
        except Exception as exc:  # noqa: BLE001
            print(
                f"  ERROR in batch submodule hash fetch for {github_repo}: {exc}",
                file=sys.stderr,
            )
            sys.exit(1)

        for base_version in sorted(to_fetch.keys(), key=sort_version_key):
            winning_tag = to_fetch[base_version]
            sri_hash = batch_results[winning_tag]
            write_source_hash_file(
                source_hashes_dir,
                SourceEntry(version=base_version, tag=winning_tag, hash=sri_hash),
            )
    else:
        for base_version in sorted(to_fetch.keys(), key=sort_version_key):
            winning_tag = to_fetch[base_version]
            try:
                if with_submodules:
                    sri_hash = fetch_github_source_hash_with_submodules(
                        owner, repo, winning_tag,
                    )
                else:
                    sri_hash = fetch_github_source_hash(owner, repo, winning_tag)
                write_source_hash_file(
                    source_hashes_dir,
                    SourceEntry(version=base_version, tag=winning_tag, hash=sri_hash),
                )
            except Exception as exc:  # noqa: BLE001
                print(
                    f"  ERROR fetching source hash for {base_version} "
                    f"({winning_tag}): {exc}",
                    file=sys.stderr,
                )
                sys.exit(1)


def run_all_hashes(
    github_repo: str,
    parse_wheel_fn,
    binary_hashes_dir: str,
    source_hashes_dir: str | None,
    schema: list[DimSpec],
    dimensions: list[str],
    version_spec: DimSpec,
    header_template: str,
    here: str,
    args,
    *,
    with_submodules: bool = False,
) -> None:
    """
    High-level entry point that runs the full hash-generation pipeline.

    Handles all branching for ``--skip-source``, ``--source-only``, and the
    normal (binary + source) flow, so per-package ``main()`` functions need
    only call this with their constants and ``parse_wheel`` function.

    Parameters
    ----------
    github_repo:
        ``owner/name`` slug.
    parse_wheel_fn:
        Package-specific wheel parser — see
        :func:`~github_release_runner.collector.collect_all_wheels`.
    binary_hashes_dir:
        Directory for ``binary-hashes/v{version}.nix`` output.
    source_hashes_dir:
        Directory for ``source-hashes/v{version}.nix`` output, or ``None``
        for packages that have no source hashes.
    schema, dimensions, version_spec, header_template:
        Passed through to :func:`run_binary_hashes`.
    here:
        Package directory (``_HERE`` in each generator) — passed to
        :func:`~github_release_runner.missing_digests.write_missing_digests`.
    args:
        Parsed argument namespace from :func:`~github_release_runner.args.add_common_args`.
    with_submodules:
        Forwarded to :func:`run_source_hashes`.  Set to ``True`` for packages
        whose ``fetchFromGitHub`` uses ``fetchSubmodules = true`` (e.g.
        flash-attn).
    """
    from github_release_runner.tags import resolve_tags
    from github_release_runner.collector import collect_all_wheels
    from github_release_runner.missing_digests import write_missing_digests

    source_only = getattr(args, "source_only", False)
    skip_source = getattr(args, "skip_source", False)

    if source_only and skip_source:
        print("Error: --source-only and --skip-source are mutually exclusive.", file=sys.stderr)
        sys.exit(1)

    if source_only and source_hashes_dir is None:
        print("Error: --source-only is not supported for this package (no source hashes).", file=sys.stderr)
        sys.exit(1)

    tags, too_old_tags = resolve_tags(github_repo, args)

    if source_only:
        # Do not touch missing-digests.txt here — we fetched no wheels so we
        # have no new information about missing digests.  Any existing file
        # from a previous binary run must be preserved as-is.
        run_source_hashes(tags, source_hashes_dir, github_repo, args, with_submodules=with_submodules)
        return

    all_raw, missing_tags = collect_all_wheels(github_repo, tags, args.token, parse_wheel_fn)
    write_missing_digests(here, missing_tags, too_old_tags)
    run_binary_hashes(all_raw, binary_hashes_dir, schema, dimensions, version_spec, header_template)

    if source_hashes_dir is not None:
        run_source_hashes(tags, source_hashes_dir, github_repo, args, with_submodules=with_submodules)
