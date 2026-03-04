from __future__ import annotations

import re


def parse_version_post(version: str) -> tuple[str, int]:
    """
    Split a version string with an optional ``.postN`` suffix into a
    ``(base_version, post_num)`` pair.

    The ``post_num`` is ``-1`` when no ``.post`` suffix is present, so the
    base version without any post release sorts before ``.post0``.

    Examples
    --------
    ``"2.9.1"``        → ``("2.9.1",   -1)``
    ``"2.9.1.post1"``  → ``("2.9.1",    1)``
    ``"2.8.3.post2"``  → ``("2.8.3",    2)``
    """
    m = re.match(r'^(.*?)\.post(\d+)$', version)
    if m:
        return m.group(1), int(m.group(2))
    return version, -1


def deduplicate_post_versions(
    entries: list[tuple[dict, dict]],
    version_key: str = "version",
) -> list[tuple[dict, dict]]:
    """
    Deduplicate wheel entries that differ only in a ``.postN`` version suffix.

    For each group of entries that share the same *base* version (i.e. the
    same version after stripping ``.postN``) **and** the same values for all
    other path-dict keys, only the entry with the **highest** ``.post``
    number is kept.  A bare version with no ``.post`` suffix counts as
    ``post -1``, so it is superseded by any ``.post0`` or higher.

    The surviving entry's version key is **relabeled** to the base version
    (the ``.postN`` suffix is removed), so downstream Nix code sees a single
    canonical key (e.g. ``"2.9.1"`` instead of ``"2.9.1.post2"``).

    Post-release logic is per base version: ``"2.1.post1"`` does not affect
    ``"2.0"`` — they have different base versions and are processed
    independently.

    Parameters
    ----------
    entries:
        Flat list of ``(path_dict, leaf_dict)`` pairs as produced by wheel
        parser helpers.
    version_key:
        The key inside ``path_dict`` that holds the version string
        (default: ``"version"``).

    Returns
    -------
    Deduplicated list.  The order within the result is unspecified.
    """
    # best_map[(base_version, other_key_tuple)] = (post_num, path_dict, leaf_dict)
    best_map: dict = {}
    for path_dict, leaf_dict in entries:
        raw_version = path_dict[version_key]
        base_version, post_num = parse_version_post(raw_version)
        # Build a stable hashable key from all non-version path dimensions.
        other_keys = tuple(sorted(
            (k, v) for k, v in path_dict.items() if k != version_key
        ))
        key = (base_version, other_keys)
        if key not in best_map or post_num > best_map[key][0]:
            best_map[key] = (post_num, path_dict, leaf_dict)

    result: list[tuple[dict, dict]] = []
    for (base_version, _), (_, path_dict, leaf_dict) in best_map.items():
        new_path = dict(path_dict)
        new_path[version_key] = base_version
        result.append((new_path, leaf_dict))
    return result
