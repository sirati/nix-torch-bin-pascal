"""
quack-kernels generate-hashes configuration module.

Imported by the shared entry point ``generate-hashes/main.py``.
Do NOT add a main() here.

quack-kernels is SOURCE-ONLY in this flake: the GitHub releases only carry
pure py3-none-any wheels (no CUDA-specific binaries), so this module is used
exclusively for source-hash generation from the v-prefixed release tags.

Invocation (from project root):
  nix run .#default.quack-kernels.gen-hashes -- --source-only --tag v0.4.1
  nix run .#default.quack-kernels.gen-hashes -- --source-only

Options (handled by shared main):
  --tag TAG        Process only this specific release tag.
  --source-only    Only generate source hashes (the only valid mode for
                   quack-kernels since it has no binary wheels).
  --token TOKEN    GitHub API token (also read from $GITHUB_TOKEN).
"""

# quack has no git submodules.
# HAS_SOURCE_HASHES defaults to True — correct for us.
