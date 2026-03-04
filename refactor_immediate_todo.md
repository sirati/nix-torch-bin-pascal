## causal-conv1d source build failure — STILL BROKEN (lower priority)

`nix build .#packages.x86_64-linux.test-causal-conv1d-from-source-py313-cu128` fails with:

```
ERROR Missing dependencies:
	torch
	nvidia-cuda-cupti-cu12==12.8.90
	torch
	... (all of torch's transitive nvidia-* pip deps)
```

Upstream nixpkgs causal-conv1d puts `torch` in `build-system` (not just
`dependencies`). Our `override-source.nix` currently does NOT put torch in
`build-system`. Fix: align with upstream — put `torch` in `build-system` and
move `cuda_nvcc` from `build-system` to `buildInputs`.

This unblocks `test-all-py313-cu128` (torch 2.10 + flash-attn + causal-conv1d).

---

## generate-hashes: add hashWithSubmodules support

`source_fetcher.py` currently fetches GitHub tarballs without submodules.
`flash-attn/override-source.nix` needs `hashWithSubmodules` in the source-hashes
file. The hash for v2.8.3 was added manually this session.

Fix `source_fetcher.py` to also compute and write a `hashWithSubmodules` field
using `fetchgit` or `nix-prefetch-github --prefetch-submodules`, then delete all
flash-attn source-hashes and regenerate them.

---

## Other testing still needed

### `generate-hashes.py` — verify regenerated output matches existing files
- `nix-shell pkgs/causal-conv1d/generate-hashes.py -- --skip-source --tag v1.6.0`
- `nix-shell pkgs/flash-attn/generate-hashes.py -- --skip-source --tag v2.8.3`

---

## Longer-term

- Add cu130 support once nixpkgs exposes `cudaPackages_13_0`
- `_checkBinAvailable` does not account for `canBuildBin` when
  `allowBuildingFromSource = false`
- Add python-defined dependency information / wheel-level ABI compat in Nix
- mixing check: only fires via `result.python.withPackages`; revisit when
  buildSource lands for torch