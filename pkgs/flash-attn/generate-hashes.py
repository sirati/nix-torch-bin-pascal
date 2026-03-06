"""
flash-attn generate-hashes configuration module.

Imported by the shared entry point ``generate-hashes/main.py``.
Do NOT add a main() here.

Invocation (from project root):
  nix run .#default.flash-attn.gen-hashes [-- --tag v2.8.3]
  nix run .#default.flash-attn.gen-hashes [-- --skip-source --tag v2.8.3]
  nix run .#default.flash-attn.gen-hashes [-- --source-only --tag v2.8.3]

Options (handled by shared main):
  --tag TAG        Process only this specific release tag.
  --skip-source    Skip source-hash generation (binary hashes only).
  --source-only    Only generate source hashes; skip binary-wheel hashes.
  --prereleases    Include pre-releases when fetching all releases.
  --token TOKEN    GitHub API token (also read from $GITHUB_TOKEN).
"""

WITH_SUBMODULES = True
CUDA_VERSION_EXAMPLES = "cu12, cu126"
