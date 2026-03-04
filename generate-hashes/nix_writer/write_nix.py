from __future__ import annotations

import os
from typing import IO, Callable

from nix_writer.schema import DimSpec


# ---------------------------------------------------------------------------
# Internal helpers
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


def _count_leaves(d: dict, total_dims: int, current_dim: int = 0) -> int:
    """Count the number of leaf entries in the organised nested dict."""
    if current_dim >= total_dims - 1:
        return len(d)
    return sum(
        _count_leaves(v, total_dims, current_dim + 1)
        for v in d.values()
        if isinstance(v, dict)
    )


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
        Nested dict built by :func:`~nix_writer.organise.organize_wheels`.
        The outermost keys correspond to ``schema[0]``.
    schema:
        One :class:`~nix_writer.schema.DimSpec` per nesting level.  The
        *last* DimSpec describes the attributes whose children are the leaf
        ``{name, url, hash}`` dicts.
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
        Optional mapping of Nix attribute name → string value emitted as
        the *first* attributes inside the top-level attrset, before any
        sorted wheel-data keys.  Example::

            prefix_attrs={"_version": "1.6.0"}

        produces::

            {
              _version = "1.6.0";
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
