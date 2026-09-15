"""
flash-attn4 generate-hashes configuration module.

The FA4 tag stream uses prerelease tags of the form fa4-v4.0.0.betaN.  This
HLD starts at beta17 and is source-only.
"""

import re

WITH_SUBMODULES = True
SOURCE_ONLY_PACKAGE = True
INCLUDE_PRERELEASES = True

_TAG_RE = re.compile(r"^fa4-v4\.0\.0\.beta([0-9]+)$")
_MIN_BETA = 30


def filter_tags(tag: str) -> bool:
    match = _TAG_RE.match(tag)
    return match is not None and int(match.group(1)) >= _MIN_BETA
