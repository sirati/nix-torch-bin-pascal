"""
bitsandbytes generate-hashes configuration module.

Imported by the shared entry point ``generate-hashes/main.py``.
Do NOT add a main() here.

bitsandbytes does NOT distribute CUDA-compiled wheels via GitHub Releases
(only source archives).  This module is used exclusively for source-hash
generation.

Invocation (from project root):
  nix run .#default.bitsandbytes.gen-hashes [-- --source-only --tag 0.45.5]
  nix run .#default.bitsandbytes.gen-hashes [-- --source-only]

Options (handled by shared main):
  --tag TAG        Process only this specific release tag.
  --source-only    Only generate source hashes (the only valid mode for
                   bitsandbytes since it has no binary wheels).
  --token TOKEN    GitHub API token (also read from $GITHUB_TOKEN).
"""

# bitsandbytes has no git submodules.
# HAS_SOURCE_HASHES defaults to True — correct for us.
