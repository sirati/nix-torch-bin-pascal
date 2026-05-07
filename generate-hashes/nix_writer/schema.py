from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any, Callable


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
