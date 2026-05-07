from __future__ import annotations


def organize_wheels(
    entries: list[tuple[dict[str, str], dict[str, str]]],
    dimensions: list[str],
) -> dict:
    """
    Build a nested dict from a flat list of ``(path_dict, leaf_dict)`` pairs.

    Parameters
    ----------
    entries:
        Each element is a ``(path_dict, leaf_dict)`` tuple where

        * ``path_dict`` maps every dimension name to its value for this
          wheel (e.g. ``{"version": "2.10.0", "pyVer": "py312", ...}``).
        * ``leaf_dict`` is the ready-to-write Nix leaf attribute set
          (typically ``{"name": "…", "url": "…", "hash": "sha256-…"}``).

    dimensions:
        Ordered list of dimension names that defines the nesting depth.
        Must be a subset of the keys present in every ``path_dict``.

    Returns
    -------
    dict
        A nested dict whose depth equals ``len(dimensions)``.  Each
        intermediate node is a plain ``dict``; the deepest nodes are the
        ``leaf_dict`` values.
    """
    organized: dict = {}
    for path_dict, leaf in entries:
        node = organized
        for dim in dimensions[:-1]:
            key = path_dict[dim]
            node = node.setdefault(key, {})
        leaf_key = path_dict[dimensions[-1]]
        node[leaf_key] = leaf
    return organized
