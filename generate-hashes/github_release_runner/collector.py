from __future__ import annotations

import sys
from typing import Callable

from source_github.wheel_source import GithubReleasesSource
from github_release_runner.tags import winning_tag_for_base_versions


def _collect_wheels_for_tag(
    github_repo: str,
    tag: str,
    token: str | None,
    parse_wheel_fn: Callable,
) -> tuple[list[tuple[dict, dict]], bool]:
    """
    Fetch all wheel assets for a single *tag* and return parsed entries.

    Parameters
    ----------
    github_repo:
        ``owner/name`` repository slug.
    tag:
        Release tag to fetch, e.g. ``"v1.6.0"``.
    token:
        Optional GitHub API token.
    parse_wheel_fn:
        Package-specific parser.  Called with a
        :class:`~common.WheelEntry`; should return
        ``(key, cxx11abi, path_dict, leaf)`` or ``None`` to skip.

    Returns
    -------
    entries:
        Flat list of ``(path_dict, leaf)`` pairs for wheels that had a
        digest.  Partial results are included when only some assets lacked
        a digest — the caller should record the tag as incomplete.
    has_missing_digest:
        ``True`` if any wheel asset in this release had no ``digest`` field
        in the GitHub API response.
    """
    print(f"Fetching binary assets for {github_repo} @ {tag} …", file=sys.stderr)
    source = GithubReleasesSource(repo=github_repo, tag=tag, token=token)

    true_wheels:  dict = {}   # key → (path_dict, leaf)
    false_wheels: dict = {}   # key → leaf
    skipped = 0

    for entry in source.fetch_wheels():
        parsed = parse_wheel_fn(entry)
        if parsed is None:
            print(f"  SKIP  {entry.name}", file=sys.stderr)
            skipped += 1
            continue
        key, cxx11abi, path_dict, leaf = parsed
        if cxx11abi == "TRUE":
            true_wheels[key] = (path_dict, leaf)
        else:
            false_wheels[key] = leaf

    if skipped:
        print(
            f"  ({skipped} asset(s) skipped due to unrecognised pattern)",
            file=sys.stderr,
        )

    if source.skipped_no_digest:
        print(
            f"  ({len(source.skipped_no_digest)} asset(s) had no digest — "
            f"tag will be recorded in missing-digests.txt)",
            file=sys.stderr,
        )

    # Warn about orphan FALSE-only wheels.
    for key in false_wheels:
        if key not in true_wheels:
            print(
                f"  WARNING: no TRUE-ABI wheel for key {key!r}; "
                f"skipping FALSE-only wheel.",
                file=sys.stderr,
            )

    # Merge FALSE wheels into corresponding TRUE wheel leaf as precx11abi.
    entries: list[tuple[dict, dict]] = []
    for key, (path_dict, leaf) in true_wheels.items():
        if key in false_wheels:
            leaf = dict(leaf)
            leaf["precx11abi"] = false_wheels[key]
        entries.append((path_dict, leaf))

    return entries, bool(source.skipped_no_digest)


def collect_all_wheels(
    github_repo: str,
    tags: list[str],
    token: str | None,
    parse_wheel_fn: Callable,
) -> tuple[list[tuple[dict, dict]], list[str]]:
    """
    Collect wheel entries across all *tags*.

    Before making any API requests the function pre-filters *tags* to only
    the **winning** tag per base version (the highest ``.postN`` for each
    base version).  Superseded intermediate post-releases (e.g.
    ``v1.5.0.post3`` when ``v1.5.0.post8`` also exists) are skipped
    entirely — no API call is made for them.  This mirrors the
    deduplication that :func:`~github_release_runner.runner.run_binary_hashes`
    would apply later anyway, but avoids wasting API quota on releases whose
    data will be discarded.

    Parameters
    ----------
    github_repo:
        ``owner/name`` repository slug.
    tags:
        Ordered list of release tags to fetch (already filtered for age by
        :func:`~github_release_runner.tags.resolve_tags`).
    token:
        Optional GitHub API token.
    parse_wheel_fn:
        Package-specific wheel filename parser — see
        :func:`_collect_wheels_for_tag`.

    Returns
    -------
    all_raw_entries:
        Combined flat list of ``(path_dict, leaf)`` pairs from all tags.
    tags_missing_digest:
        Tags for which at least one asset had no ``digest`` field.  In
        practice this is all-or-nothing per release, but partial cases are
        handled gracefully: hashes are generated for the assets that did
        have digests, and the tag is still recorded as incomplete.
    """
    # Pre-filter: only fetch assets for the winning tag per base version.
    # This avoids API calls for intermediate post-releases that will be
    # discarded by deduplication in run_binary_hashes anyway.
    if len(tags) > 1:
        winning = winning_tag_for_base_versions(tags)
        winning_set = set(winning.values())
        skipped = [t for t in tags if t not in winning_set]
        if skipped:
            print(
                f"Skipping {len(skipped)} superseded post-release tag(s) "
                f"(will be deduped): {', '.join(skipped)}",
                file=sys.stderr,
            )
        effective_tags = [t for t in tags if t in winning_set]
    else:
        effective_tags = tags

    all_raw_entries: list[tuple[dict, dict]] = []
    tags_missing_digest: list[str] = []

    for tag in effective_tags:
        entries, has_missing = _collect_wheels_for_tag(
            github_repo, tag, token, parse_wheel_fn,
        )
        all_raw_entries.extend(entries)
        if has_missing:
            tags_missing_digest.append(tag)

    return all_raw_entries, tags_missing_digest
