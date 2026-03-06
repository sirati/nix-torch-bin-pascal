from __future__ import annotations

import os
import sys


# ---------------------------------------------------------------------------
# Parsing
# ---------------------------------------------------------------------------

def read_missing_digests(hld_dir: str) -> tuple[list[str], list[str]]:
    """
    Read and parse an existing ``missing-digests.txt`` file.

    Returns ``(missing_tags, too_old_tags)`` — both lists are in the order
    they appeared in the file.  Returns ``([], [])`` when the file does not
    exist or is empty.

    Parameters
    ----------
    hld_dir:
        Absolute path to the package's HLD folder.
    """
    path = os.path.join(hld_dir, "missing-digests.txt")
    if not os.path.exists(path):
        return [], []

    missing: list[str] = []
    too_old: list[str] = []

    # Detect which section we are in by looking at comment markers.
    # Lines starting with "#" or blank lines are skipped.
    # The "too old" section is introduced by a comment containing "too old".
    in_too_old = False
    with open(path) as fh:
        for line in fh:
            stripped = line.rstrip("\n")
            if not stripped or stripped.startswith("#"):
                if "too old" in stripped.lower():
                    in_too_old = True
                continue
            if in_too_old:
                too_old.append(stripped)
            else:
                missing.append(stripped)

    return missing, too_old


# ---------------------------------------------------------------------------
# Writing
# ---------------------------------------------------------------------------

def _write_missing_digests_raw(
    path: str,
    tags_missing: list[str],
    too_old_tags: list[str],
) -> None:
    """Write *tags_missing* and *too_old_tags* to *path*, or remove it when both are empty."""
    if not tags_missing and not too_old_tags:
        if os.path.exists(path):
            os.remove(path)
            print(
                f"Removed {path} (all assets now have digests)",
                file=sys.stderr,
            )
        return

    lines: list[str] = []

    if tags_missing:
        lines += [
            "# Release tags for which the GitHub API returned no 'digest' on at least",
            "# one wheel asset.  Binary hashes were still generated for the assets that",
            "# did have digests.  Re-run the generator once GitHub backfills the rest.",
            "",
            *tags_missing,
            "",
        ]

    if too_old_tags:
        lines += [
            "# Release tags skipped as too old (published year <= cutoff year).",
            "# These pre-date GitHub's digest feature and will never have API-provided",
            "# hashes.  They are intentionally not fetched.",
            "",
            *too_old_tags,
            "",
        ]

    with open(path, "w") as fh:
        fh.write("\n".join(lines))

    parts = []
    if tags_missing:
        parts.append(f"{len(tags_missing)} tag(s) with missing digests")
    if too_old_tags:
        parts.append(f"{len(too_old_tags)} too-old tag(s)")
    print(f"Wrote {path}  ({', '.join(parts)})", file=sys.stderr)


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def update_missing_digests(
    hld_dir: str,
    processed_tags: list[str],
    new_missing: list[str],
    new_too_old: list[str] | None = None,
) -> None:
    """
    Update ``missing-digests.txt`` by merging with its current content.

    Only entries for *processed_tags* are replaced.  All other tags already
    recorded in the file are preserved, so calling this function with a
    subset of tags (e.g. via ``--tag``) does not corrupt entries for tags
    that were not part of the current run.

    Algorithm
    ---------
    1. Read the existing ``missing-digests.txt`` (if any).
    2. Remove all tags in *processed_tags* from both the missing and too-old
       sections of the existing data.
    3. Append any tags from *new_missing* that are not already present.
    4. Append any tags from *new_too_old* that are not already present.
    5. Write the merged result (or remove the file when both lists are empty).

    Parameters
    ----------
    hld_dir:
        Absolute path to the package's HLD folder (e.g.
        ``.../pkgs/causal-conv1d/``).
    processed_tags:
        Tags that were fetched/inspected during this run.  Their status is
        authoritative; existing entries for these tags are replaced.
    new_missing:
        Tags (subset of *processed_tags*) that had at least one digest-less
        asset in this run.
    new_too_old:
        Tags (subset of *processed_tags*) that were skipped as too old.
        Pass ``None`` or ``[]`` when not applicable (e.g. ``--tag`` runs
        where the cutoff filter was bypassed).
    """
    existing_missing, existing_too_old = read_missing_digests(hld_dir)

    processed_set = set(processed_tags)

    # Remove processed tags from the existing lists so we replace, not duplicate.
    merged_missing = [t for t in existing_missing if t not in processed_set]
    merged_too_old = [t for t in existing_too_old if t not in processed_set]

    # Append new entries (preserve order: existing first, then new).
    new_missing_set = set(merged_missing)
    for tag in new_missing:
        if tag not in new_missing_set:
            merged_missing.append(tag)
            new_missing_set.add(tag)

    new_too_old_set = set(merged_too_old)
    for tag in (new_too_old or []):
        if tag not in new_too_old_set:
            merged_too_old.append(tag)
            new_too_old_set.add(tag)

    path = os.path.join(hld_dir, "missing-digests.txt")
    _write_missing_digests_raw(path, merged_missing, merged_too_old)


def write_missing_digests(
    hld_dir: str,
    tags_missing: list[str],
    too_old_tags: list[str] | None = None,
) -> None:
    """
    Write (or remove) ``missing-digests.txt`` inside *hld_dir*.

    .. deprecated::
        Prefer :func:`update_missing_digests` which merges with existing
        content so that partial runs (``--tag``) do not corrupt entries for
        unprocessed tags.  This function is kept for callers that process
        all tags at once and want a full overwrite.

    The file has up to two sections:

    1. **Missing digest** — release tags for which the GitHub API returned no
       ``digest`` on at least one wheel asset.  Binary hashes are still
       generated for the assets that did have digests.
    2. **Too old** — release tags skipped because their publication year was
       at or before the configured cutoff year.  These pre-date GitHub's
       digest feature and will never gain hashes via the API.

    When both lists are empty any pre-existing file is removed — the absence
    of the file is the "clean state" signal.

    Parameters
    ----------
    hld_dir:
        Absolute path to the package's HLD folder.
    tags_missing:
        Ordered list of release tags that had at least one digest-less asset.
    too_old_tags:
        Ordered list of release tags skipped as too old (published year <=
        cutoff year).  Pass ``None`` or ``[]`` when not applicable.
    """
    path = os.path.join(hld_dir, "missing-digests.txt")
    _write_missing_digests_raw(path, tags_missing, too_old_tags or [])
