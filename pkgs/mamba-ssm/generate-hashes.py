"""
mamba-ssm generate-hashes configuration module.

Imported by the shared entry point ``generate-hashes/main.py``.
Do NOT add a main() here.

Invocation (from project root):
  nix run .#default.mamba-ssm.gen-hashes [-- --tag v2.3.0]
  nix run .#default.mamba-ssm.gen-hashes [-- --skip-source --tag v2.3.0]
  nix run .#default.mamba-ssm.gen-hashes [-- --source-only --tag v2.3.0]

Options (handled by shared main):
  --tag TAG        Process only this specific release tag.
  --skip-source    Skip source-hash generation (binary hashes only).
  --source-only    Only generate source hashes; skip binary-wheel hashes.
  --prereleases    Include pre-releases when fetching all releases.
  --token TOKEN    GitHub API token (also read from $GITHUB_TOKEN).
"""

# WITH_SUBMODULES defaults to False — mamba has no git submodules.
# HAS_SOURCE_HASHES defaults to True.
