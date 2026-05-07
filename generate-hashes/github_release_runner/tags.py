from __future__ import annotations

import sys

from common.versions import parse_version_post
from source_github.releases import list_release_info


def resolve_tags(
    github_repo: str,
    args,
) -> tuple[list[str], list[str]]:
    """
    Return ``(valid_tags, too_old_tags)`` for the given repository.

    When ``args.tag`` is set returns ``([args.tag], [])`` immediately —
    single-tag mode bypasses all filtering (the caller knows what they want).

    Otherwise queries the GitHub API for all releases (respecting
    ``args.prereleases`` and ``args.token``).  Releases whose
    ``published_at`` year is ≤ ``args.cutoff_year`` (default 2022) are
    separated into *too_old_tags* and excluded from *valid_tags*.  Callers
    should pass *too_old_tags* to :func:`~github_release_runner.missing_digests.write_missing_digests`
    so they are recorded in ``missing-digests.txt`` with a "too old" label.

    Exits with a non-zero status if no valid (non-too-old) tags are found.
    """
    if args.tag:
        print(f"Processing single tag: {args.tag}", file=sys.stderr)
        return [args.tag], []

    cutoff_year: int = getattr(args, "cutoff_year", 2022)

    print(f"Fetching all release tags for {github_repo} …", file=sys.stderr)
    release_info = list_release_info(
        github_repo,
        token=args.token,
        include_prereleases=args.prereleases,
    )
    if not release_info:
        print("No releases found.", file=sys.stderr)
        sys.exit(1)

    valid_tags: list[str] = []
    too_old_tags: list[str] = []

    for info in release_info:
        tag = info["tag_name"]
        published_at: str = info.get("published_at", "") or ""
        if cutoff_year > 0 and published_at:
            try:
                year = int(published_at[:4])
            except ValueError:
                year = 9999
            if year <= cutoff_year:
                too_old_tags.append(tag)
                continue
        valid_tags.append(tag)

    if not valid_tags:
        print("No releases found after applying cutoff-year filter.", file=sys.stderr)
        sys.exit(1)

    print(f"Found {len(valid_tags)} release(s): {', '.join(valid_tags)}", file=sys.stderr)
    if too_old_tags:
        print(
            f"Skipping {len(too_old_tags)} too-old release(s) "
            f"(published <= {cutoff_year}): {', '.join(too_old_tags)}",
            file=sys.stderr,
        )
    return valid_tags, too_old_tags


def winning_tag_for_base_versions(tags: list[str]) -> dict[str, str]:
    """
    Map each base version to the highest ``.postN`` release tag for it.

    Given a list of release tags the function strips the leading ``v``,
    parses the optional ``.postN`` suffix and returns a dict of
    ``base_version → winning_tag`` where the winning tag is the one with
    the largest post number (bare versions count as post ``-1``, so they
    are superseded by any ``.post0`` or higher).

    Example
    -------
    ::

        ["v1.6.0", "v1.6.0.post1", "v1.5.0"]
        → {"1.6.0": "v1.6.0.post1", "1.5.0": "v1.5.0"}

    This is used when generating source hashes: for a version like
    ``1.6.0`` the source tarball should be taken from the ``post1`` tag
    (the latest published tag for that base version), not from the bare
    ``v1.6.0`` tag.
    """
    best: dict[str, tuple[int, str]] = {}   # base → (post_num, tag)
    for tag in tags:
        raw = tag.lstrip("v")
        base, post_num = parse_version_post(raw)
        existing = best.get(base)
        if existing is None or post_num > existing[0]:
            best[base] = (post_num, tag)
    return {base: tag for base, (_, tag) in best.items()}
