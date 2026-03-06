"""
causal-conv1d generate-hashes configuration module.

Imported by the shared entry point ``generate-hashes/main.py``.
Do NOT add a main() here.

Invocation (from project root):
  nix run .#default.causal-conv1d.gen-hashes [-- --tag v1.6.0]
  nix run .#default.causal-conv1d.gen-hashes [-- --skip-source --tag v1.6.0]
  nix run .#default.causal-conv1d.gen-hashes [-- --source-only --tag v1.6.0]

Options (handled by shared main):
  --tag TAG        Process only this specific release tag.
  --skip-source    Skip source-hash generation (binary hashes only).
  --source-only    Only generate source hashes; skip binary-wheel hashes.
  --prereleases    Include pre-releases when fetching all releases.
  --token TOKEN    GitHub API token (also read from $GITHUB_TOKEN).
"""

# WITH_SUBMODULES defaults to False — causal-conv1d has no git submodules.
# HAS_SOURCE_HASHES defaults to True.
