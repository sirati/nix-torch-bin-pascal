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

## source_fetcher: batch-clone optimization for submodule hashes

Currently `fetch_github_source_hash_with_submodules` calls `nix-prefetch-github
--fetch-submodules` once per tag, which does a full fresh clone + submodule
fetch every time (~59 clones for flash-attn = very slow).

Replace with a single-clone approach in `source_fetcher.py`:

1. `git clone --filter=blob:none --no-checkout <url> <tmpdir>` once.
2. For each tag in order:
   a. `git -C <tmpdir> checkout <tag>`
   b. `git -C <tmpdir> submodule update --init --recursive`
   c. Copy tree to a clean scratch dir (strip all `.git` dirs).
   d. Compute NAR hash: `nix hash path --sri --type sha256 <clean_dir>`.
   e. Clean up scratch dir; reset submodules before next tag.
3. Return dict of tag → SRI hash.

The hash produced by step (d) must match what `fetchFromGitHub { fetchSubmodules
= true; }` expects. Verify against the already-known v2.8.3 hash
(`sha256-6I1O4E5K5IdbpzrXFHK06QVcOE8zuVkFE338ffk6N8M=`) before deleting the
nix-prefetch-github path. If `nix hash path` does not match (e.g. due to
timestamp normalisation differences in fetchgit), fall back to calling
`nix-prefetch-git --fetch-submodules --url file://<tmpdir> --rev <full-sha>`
using the local mirror as the URL so git data is not re-downloaded (submodules
still hit the network, but the main repo does not).

New public API surface (add to `source_fetcher.py`):

```python
def fetch_github_source_hashes_with_submodules_batch(
    owner: str, repo: str, tags: list[str]
) -> dict[str, str]:
    """Clone once, return {tag: sri_hash} for all tags."""
    ...
```

`run_source_hashes` in `runner.py` should call the batch variant when
`with_submodules=True` and there is more than one tag to fetch, falling back to
the single-tag function for the `--tag` case.

---

## Other testing still needed

### `generate-hashes.py` — verify regenerated output matches existing files
- `nix-shell pkgs/causal-conv1d/generate-hashes.py -- --skip-source --tag v1.6.0`
- `nix-shell pkgs/flash-attn/generate-hashes.py -- --source-only --tag v2.8.3`
- After batch-clone is implemented: run full `--source-only` for flash-attn and
  stage the resulting source-hashes files.

---

## Longer-term

- Add cu130 support once nixpkgs exposes `cudaPackages_13_0`
- `_checkBinAvailable` does not account for `canBuildBin` when
  `allowBuildingFromSource = false`
- Add python-defined dependency information / wheel-level ABI compat in Nix
- mixing check: only fires via `result.python.withPackages`; revisit when
  buildSource lands for torch