"""
torchaudio generate-hashes configuration module.

Imported by the shared entry point ``generate-hashes/main.py``.
Do NOT add a main() here.

torchaudio wheels are distributed via download.pytorch.org per CUDA variant
and per Python version (cp312-cp312, etc.), exactly like torch — the whole flow
lives in ``generate-hashes/torch_website.py``; this module only supplies the
package-specific config.  torchaudio depends on a matching torch at runtime;
that wiring lives in high-level.nix (highLevelDeps), not here.

Invocation (from project root):
  nix run .#default.torchaudio.gen-hashes [-- --cuda cu126]
  nix run .#default.torchaudio.gen-hashes [-- --cuda cu128]

Options (handled by run() below):
  --cuda VARIANT   CUDA variant to generate (e.g. cu126, cu128).
                   May be repeated. Defaults to all variants.
"""

import os
import sys

# When loaded as a module by main.py, generate-hashes/ is already on sys.path.
# When run directly for debugging, add it manually.
_GENERATE_HASHES_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../..", "generate-hashes")
if _GENERATE_HASHES_DIR not in sys.path:
    sys.path.insert(0, _GENERATE_HASHES_DIR)

from torch_website import TorchWebsiteHashGen

# ORIGIN_TYPE ("torch-website") is injected by makeGenHashesApp from the HLD.

_GEN = TorchWebsiteHashGen(
    package="torchaudio",
    output_dir=os.path.join(os.path.dirname(os.path.abspath(__file__)), "binary-hashes"),
    cuda_variants=["cu126", "cu128", "cu130", "cu132"],
    # cu132 exists upstream but has no torchaudio wheels yet; write an empty
    # (but valid) hash file rather than aborting the run.
    allow_empty=True,
)


def run() -> None:
    """Entry point called by ``generate-hashes/main.py`` for torch-website packages."""
    _GEN.run()
