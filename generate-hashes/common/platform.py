from __future__ import annotations


def parse_wheel_platform(platform_tag: str) -> tuple[str, str] | None:
    """
    Map a wheel platform tag to a ``(os_name, arch)`` pair.

    Returns ``None`` for unrecognised tags so callers can skip or warn.

    Supported inputs
    ----------------
    manylinux_*_x86_64   → ("linux",   "x86_64")
    manylinux_*_aarch64  → ("linux",   "aarch64")
    win_amd64            → ("windows", "x86_64")
    linux_x86_64         → ("linux",   "x86_64")   # flash-attn bare style
    linux_aarch64        → ("linux",   "aarch64")
    """
    if platform_tag.startswith("manylinux"):
        if platform_tag.endswith("_x86_64"):
            return ("linux", "x86_64")
        if platform_tag.endswith("_aarch64"):
            return ("linux", "aarch64")
        # Generic fallback: take the last underscore-delimited component
        last = platform_tag.rsplit("_", 1)[-1]
        return ("linux", last) if last else None

    if platform_tag == "win_amd64":
        return ("windows", "x86_64")

    if platform_tag.startswith("linux_"):
        arch = platform_tag[len("linux_"):]
        return ("linux", arch) if arch else None

    return None
