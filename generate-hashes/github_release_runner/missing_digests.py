from __future__ import annotations

import os
import sys


def write_missing_digests(
    hld_dir: str,
    tags_missing: list[str],
    too_old_tags: list[str] | None = None,
) -> None:
    """
    Write (or remove) ``missing-digests.txt`` inside *hld_dir*.

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
        Absolute path to the package's HLD folder (e.g.
        ``.../pkgs/causal-conv1d/``).  The file is written there so it
        lives next to the binary-hashes and source-hashes sub-directories.
    tags_missing:
        Ordered list of release tags that had at least one digest-less asset.
    too_old_tags:
        Ordered list of release tags skipped as too old (published year <=
        cutoff year).  Pass ``None`` or ``[]`` when not applicable.
    """
    path = os.path.join(hld_dir, "missing-digests.txt")
    too_old = too_old_tags or []

    if not tags_missing and not too_old:
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

    if too_old:
        lines += [
            "# Release tags skipped as too old (published year <= cutoff year).",
            "# These pre-date GitHub's digest feature and will never have API-provided",
            "# hashes.  They are intentionally not fetched.",
            "",
            *too_old,
            "",
        ]

    with open(path, "w") as fh:
        fh.write("\n".join(lines))

    parts = []
    if tags_missing:
        parts.append(f"{len(tags_missing)} tag(s) with missing digests")
    if too_old:
        parts.append(f"{len(too_old)} too-old tag(s)")
    print(f"Wrote {path}  ({', '.join(parts)})", file=sys.stderr)
