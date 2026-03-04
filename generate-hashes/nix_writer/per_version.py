from __future__ import annotations

import os
from typing import Callable

from nix_writer.schema import DimSpec
from nix_writer.write_nix import write_binary_hashes_nix, _sorted_keys


def write_binary_hashes_per_version(
    output_dir: str,
    organized: dict,
    schema: list[DimSpec],
    header_template: str,
    version_spec: DimSpec,
    prefix_attrs_fn: Callable[[str], dict[str, str]] | None = None,
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
        :func:`~nix_writer.organise.organize_wheels` with ``"version"`` as
        the first dimension.
    schema:
        One :class:`~nix_writer.schema.DimSpec` per nesting level **not**
        including the leading version level (i.e. the schema that describes
        the content *inside* each version block).
    header_template:
        Comment block written at the top of every file.  May contain a
        ``{version}`` placeholder that is substituted with the version string.
    version_spec:
        The :class:`~nix_writer.schema.DimSpec` that corresponds to the
        version dimension (used only for its ``sort_key`` when ordering the
        output files).
    prefix_attrs_fn:
        Optional callable ``(version: str) -> dict[str, str]``.  When
        provided it is called for each version and the returned mapping is
        forwarded as ``prefix_attrs`` to
        :func:`~nix_writer.write_nix.write_binary_hashes_nix`, emitting
        self-identifying attributes (e.g. ``_version``) at the top of every
        generated file.  Example::

            prefix_attrs_fn=lambda version: {"_version": version}
    """
    os.makedirs(output_dir, exist_ok=True)

    for version in _sorted_keys(organized, version_spec):
        path = os.path.join(output_dir, f"v{version}.nix")
        header = header_template.format(version=version)
        write_binary_hashes_nix(
            path,
            organized[version],
            schema,
            header,
            wrap_in_func=False,
            prefix_attrs=prefix_attrs_fn(version) if prefix_attrs_fn is not None else None,
        )
