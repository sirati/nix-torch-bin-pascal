"""
sonic-moe generate-hashes configuration module.

Imported by the shared entry point ``generate-hashes/main.py``.
Do NOT add a main() here.

sonic-moe is SOURCE-ONLY in this flake: the GitHub releases only carry pure
py3-none-any wheels (no CUDA-specific binaries), so this module is used
exclusively for source-hash generation.  Release tags are BARE versions
(e.g. "0.1.2", no "v" prefix), like bitsandbytes.

Invocation (from project root):
  nix run .#default.sonic-moe.gen-hashes -- --source-only --tag 0.1.2
  nix run .#default.sonic-moe.gen-hashes -- --source-only

Options (handled by shared main):
  --tag TAG        Process only this specific release tag (bare, no "v").
  --source-only    Only generate source hashes (the only valid mode for
                   sonic-moe since it has no binary wheels).
  --token TOKEN    GitHub API token (also read from $GITHUB_TOKEN).
"""

# sonic-moe has no git submodules.
# HAS_SOURCE_HASHES defaults to True — correct for us.
