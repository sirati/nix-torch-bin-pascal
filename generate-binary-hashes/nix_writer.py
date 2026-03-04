"""
Generic Nix binary-hashes.nix writer.

Converts a nested Python dict of wheel data into the Nix attribute-set format
expected by the package override files.

Typical usage
-------------
    from nix_writer import DimSpec, organize_wheels, write_binary_hashes_nix
    from common import sort_version_key, sort_pyver_key_ft

    SCHEMA = [
        DimSpec("version",  quoted=True, sort_key=sort_version_key),
        DimSpec("pyVer",    sort_key=sort_pyver_key_ft),
        DimSpec("os"),
        DimSpec("arch"),
    ]

    parsed = [(parse_wheel(e), e) for e in source.fetch_wheels()]
    parsed = [(p, e) for p, e in parsed if p is not None]

    organized = organize_wheels(
        [(path, entry.to_leaf()) for path, entry in parsed],
        ["version", "pyVer", "os", "arch"],
    )

    write_binary_hashes_nix("pkg/binary-hashes.nix", organized, SCHEMA, HEADER)

File structure produced
-----------------------
    version:
    builtins.getAttr version {
      "2.10.0" = {
        py312 = {
          linux = {
            x86_64 = {
              name = "...";
              url  = "...";
              hash = "sha256-...";
            };
          };
        };
      };
    }
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any, Callable, IO


# ---------------------------------------------------------------------------
# Schema definition
# ---------------------------------------------------------------------------

@dataclass
class DimSpec:
    """
    Specification for one level of nesting in the binary-hashes.nix structure.

    Parameters
    ----------
    name:
        Human-readable label for this dimension (used in error messages and
        the generated file's header comment only).
    quoted:
        When True, attribute names at this level are emitted as ``"key"``
        rather than ``key``.  Needed for keys that start with a digit or
        contain dots, e.g. version strings like ``"2.4"``.
    sort_key:
        Optional callable used as the ``key`` argument to ``sorted()`` when
        ordering attribute names at this level.  ``None`` means natural
        (alphabetical) sort.
    required_keys:
        Attribute names that must always appear in the output even when the
        source data has no entries for them — they are emitted as empty
        attribute sets (``{}``).  Useful for structural invariants, e.g.
        always emitting both ``FALSE`` and ``TRUE`` for the cxx11abi level.
    comment_fn:
        Optional callable ``(key: str) -> str``.  When present, a ``# …``
        comment line is written immediately before each attribute at this
        level.  The returned string should *not* include the leading ``# ``.
    """
    name: str
    quoted: bool = False
    sort_key: Callable[[str], Any] | None = None
    required_keys: list[str] | None = None
    comment_fn: Callable[[str], str] | None = None


# ---------------------------------------------------------------------------
# Data organisation
# ---------------------------------------------------------------------------

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


# ---------------------------------------------------------------------------
# Internal writer helpers
# ---------------------------------------------------------------------------

def _sorted_keys(data: dict, spec: DimSpec) -> list[str]:
    """Return keys of *data* merged with ``spec.required_keys``, sorted."""
    keys: set[str] = set(data.keys())
    if spec.required_keys:
        keys |= set(spec.required_keys)
    if spec.sort_key:
        return sorted(keys, key=spec.sort_key)
    return sorted(keys)


def _attr_name(key: str, quoted: bool) -> str:
    return f'"{key}"' if quoted else key


def _write_nested(
    f: IO[str],
    data: dict,
    schema: list[DimSpec],
    depth: int,
    indent: str = "  ",
) -> None:
    """
    Recursively write *data* as a Nix attribute set, guided by *schema*.

    The caller is responsible for writing ``attr = `` before calling this
    function; this function writes the opening ``{``, body, and closing
    ``};\\n``.

    When *schema* is empty the function is at the leaf level and *data* is
    expected to be a ``{name, url, hash}`` dict whose values are strings.
    """
    pad = indent * depth

    # ── Leaf level ────────────────────────────────────────────────────────
    if not schema:
        if not data:
            f.write("{};\n")
            return
        f.write("{\n")
        for k, v in data.items():
            if isinstance(v, dict):
                # Nested sub-attribute within the leaf (e.g. precx11abi = { … })
                if not v:
                    f.write(f"{pad}{indent}{k} = {{}};\n")
                else:
                    f.write(f"{pad}{indent}{k} = {{\n")
                    for sk, sv in v.items():
                        f.write(f"{pad}{indent}{indent}{sk} = \"{sv}\";\n")
                    f.write(f"{pad}{indent}}};\n")
            else:
                f.write(f"{pad}{indent}{k} = \"{v}\";\n")
        f.write(f"{pad}}};\n")
        return

    # ── Intermediate level ────────────────────────────────────────────────
    spec = schema[0]
    rest = schema[1:]
    keys = _sorted_keys(data, spec)

    if not keys:
        f.write("{};\n")
        return

    f.write("{\n")
    for key in keys:
        if spec.comment_fn:
            comment = spec.comment_fn(key)
            f.write(f"\n{pad}{indent}# {comment}\n")
        attr = _attr_name(key, spec.quoted)
        f.write(f"{pad}{indent}{attr} = ")
        child = data.get(key, {})
        _write_nested(f, child, rest, depth + 1, indent)
    f.write(f"{pad}}};\n")


# ---------------------------------------------------------------------------
# Public entry point
# ---------------------------------------------------------------------------

def write_binary_hashes_nix(
    output_path: str,
    organized: dict,
    schema: list[DimSpec],
    header: str,
    top_key_var: str = "version",
    wrap_in_func: bool = True,
    prefix_attrs: dict[str, str] | None = None,
) -> None:
    """
    Write a ``binary-hashes.nix`` file.

    When *wrap_in_func* is ``True`` (the default) the file is a Nix expression
    of the form::

        version:
        builtins.getAttr version {
          "<key>" = { … };
          …
        }

    When *wrap_in_func* is ``False`` the file is a plain attrset::

        {
          "<key>" = { … };
          …
        }

    Parameters
    ----------
    output_path:
        Filesystem path for the output file (created/overwritten).
    organized:
        Nested dict built by :func:`organize_wheels` (or constructed
        manually).  The outermost keys correspond to ``schema[0]``.
    schema:
        One :class:`DimSpec` per nesting level.  The *last* DimSpec
        describes the attributes whose children are the leaf ``{name, url,
        hash}`` dicts.
    header:
        Verbatim comment block written at the very top of the file.
        Each line should start with ``#``.  A trailing newline is added
        automatically.
    top_key_var:
        Name of the Nix lambda argument (default ``"version"``).
        Ignored when *wrap_in_func* is ``False``.
    wrap_in_func:
        When ``True`` (default) emits the ``version: builtins.getAttr …``
        wrapper.  When ``False`` emits a plain ``{ … }`` attrset.
    prefix_attrs:
        Optional mapping of Nix attribute name → string value that is
        emitted verbatim as the *first* attributes inside the top-level
        attrset, before any of the sorted wheel-data keys.  Iteration
        order of the dict is preserved.  Values are quoted as Nix string
        literals.  Example::

            prefix_attrs={"_cudaLabel": "cu126"}

        produces::

            {
              _cudaLabel = "cu126";
              "2.10.0" = { … };
              …
            }
    """
    if not schema:
        raise ValueError("schema must contain at least one DimSpec")

    top_spec = schema[0]
    rest = schema[1:]

    total = _count_leaves(organized, len(schema))

    with open(output_path, "w") as f:
        f.write(header.rstrip("\n") + "\n\n")

        if wrap_in_func:
            f.write(f"{top_key_var}:\n")
            f.write(f"builtins.getAttr {top_key_var} {{\n")
        else:
            f.write("{\n")

        if prefix_attrs:
            for attr_name, attr_value in prefix_attrs.items():
                f.write(f"  {attr_name} = \"{attr_value}\";\n")

        for key in _sorted_keys(organized, top_spec):
            if top_spec.comment_fn:
                comment = top_spec.comment_fn(key)
                f.write(f"\n  # {comment}\n")
            attr = _attr_name(key, top_spec.quoted)
            f.write(f"  {attr} = ")
            child = organized.get(key, {})
            _write_nested(f, child, rest, depth=1)

        f.write("}\n")

    print(f"Wrote {output_path}  ({total} wheel entries)")


# ---------------------------------------------------------------------------
# Per-version writer
# ---------------------------------------------------------------------------

def write_binary_hashes_per_version(
    output_dir: str,
    organized: dict,
    schema: list[DimSpec],
    header_template: str,
    version_spec: DimSpec,
    prefix_attrs_fn: "Callable[[str], dict[str, str]] | None" = None,
) -> None:
    """
    Split *organized* by its outermost key (version) and write one plain
    attrset binary-hashes file per version into *output_dir*.

    File names: ``v{version}.nix``

    Each file is written as a plain attrset (``wrap_in_func=False``).

    Parameters
    ----------
    output_dir:
        Directory where the per-version ``.nix`` files are written.
        Created automatically if it does not exist.
    organized:
        Nested dict whose outermost keys are version strings, produced by
        :func:`organize_wheels` with ``"version"`` as the first dimension.
    schema:
        One :class:`DimSpec` per nesting level **not** including the leading
        version level (i.e. the schema that describes the content *inside*
        each version block).
    header_template:
        Comment block written at the top of every file.  May contain a
        ``{version}`` placeholder that is substituted with the version string.
    version_spec:
        The :class:`DimSpec` that corresponds to the version dimension
        (used only for its ``sort_key`` when ordering the output files).
    prefix_attrs_fn:
        Optional callable ``(version: str) -> dict[str, str]``.  When
        provided it is called for each version and the returned mapping is
        forwarded as ``prefix_attrs`` to :func:`write_binary_hashes_nix`,
        emitting self-identifying attributes (e.g. ``_version``) at the top
        of every generated file.  Example::

            prefix_attrs_fn=lambda version: {"_version": version}
    """
    import os as _os
    _os.makedirs(output_dir, exist_ok=True)

    keys = _sorted_keys(organized, version_spec)
    for version in keys:
        path = _os.path.join(output_dir, f"v{version}.nix")
        header = header_template.format(version=version)
        write_binary_hashes_nix(
            path,
            organized[version],
            schema,
            header,
            wrap_in_func=False,
            prefix_attrs=prefix_attrs_fn(version) if prefix_attrs_fn is not None else None,
        )


# ---------------------------------------------------------------------------
# Internal counting helper
# ---------------------------------------------------------------------------

def _count_leaves(d: dict, total_dims: int, current_dim: int = 0) -> int:
    """Count the number of leaf entries in the organised nested dict."""
    # The leaves live at depth == total_dims - 1 (zero-indexed).
    # Beyond that depth the values are leaf dicts, not nesting dicts.
    if current_dim >= total_dims - 1:
        return len(d)
    return sum(
        _count_leaves(v, total_dims, current_dim + 1)
        for v in d.values()
        if isinstance(v, dict)
    )
