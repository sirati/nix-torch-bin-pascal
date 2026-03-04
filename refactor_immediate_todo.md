## versionConstraints mechanism: keep in concretise, not yet in fieldSpecs

`concretise/default.nix` has `allVersionConstraints` / `applyVersionConstraints`
infrastructure that reads `hld.versionConstraints or {}` from each HLD.
Currently no HLD declares this field, so the code is dormant.

Decision: do NOT add `versionConstraints` to `fieldSpecs` until a genuine
use-case is identified that cannot be handled by `override.nix` logic.

---

## Testing needed

The following were implemented but not yet tested end-to-end:

### `nix develop` devShell — python3 in PATH
- Run `nix develop .#devShells.x86_64-linux.test-causal-conv1d-py313-cu128`
- Confirm `python3 --version` works inside the shell
- Confirm `python3 -c "import causal_conv1d"` works (requires a GPU build or
  skipped import check)

### `wheel-helpers.nix` — binary wheel builds
- Confirm `nix build .#packages.x86_64-linux.test-causal-conv1d-py313-cu128`
  still produces a valid derivation after the override.nix refactor
- Confirm `nix build .#packages.x86_64-linux.test-all-py313-cu128` still works
  (flash-attn binary wheel path goes through wheel-helpers.nix)

### `generate-hashes.py` combined binary+source generator (causal-conv1d)
- Run `nix-shell pkgs/causal-conv1d/generate-hashes.py -- --skip-source --tag v1.6.0`
  from the project root and verify:
  - `binary-hashes/v1.6.0.nix` is regenerated correctly (matches existing file)
  - header line reads `-- --skip-source --tag v1.6.0` as expected
- Run with `--tag v1.6.0` (without --skip-source) and confirm source hash is
  skipped with "already exists — skipping" message in stderr
- Run with `--tag v1.6.0` after deleting `source-hashes/v1.6.0.nix` and confirm
  the file is regenerated with the correct hash
  (`sha256-hFaF/oMdScDpdq+zq8WppWe9GONWppEEx2pIcnaALiI=`)
- Run without `--tag` (all-releases mode) and confirm:
  - too-old releases (published <= 2022) are skipped before any API fetch
  - superseded post-releases (e.g. v1.5.0.post3 when v1.5.0.post8 exists) are
    skipped before any API fetch
  - `missing-digests.txt` is written with correct sections when applicable
  - all expected `binary-hashes/v*.nix` files are written/skipped correctly

### `source_fetcher.py` / `source_github` module
- Confirm `list_release_tags("Dao-AILab/causal-conv1d")` returns at least `v1.6.0`
- Confirm `source_hash_exists` returns True for the now-present `v1.6.0.nix`
- Unit-test `winning_tag_for_base_versions`:
  `["v1.6.0", "v1.6.0.post1", "v1.5.0"]` → `{"1.6.0": "v1.6.0.post1", "1.5.0": "v1.5.0"}`

### `override-source.nix` folder path
- Confirm `nix build .#packages.x86_64-linux.test-causal-conv1d-from-source-py313-cu128`
  still evaluates (no path error on the new `./source-hashes + "/v…"` import)

### `pkg_helpers.make_torch_binary_header_template`
- Confirm the `{version}` placeholder survives and is substituted correctly in
  generated files (i.e. `v1.6.0.nix` header contains `--tag v1.6.0`, not `--tag v{version}`)
- Confirm `{{ }}` Nix attribute-set examples render as `{ }` in the output file

---

## Longer-term

- Implement `buildSource` / four-derivation split for torch and flash-attn
  (causal-conv1d buildSource is now implemented)
- Add `pkgs/flash-attn/generate-source-hashes.py` once flash-attn buildSource
  is implemented (mirror the causal-conv1d pattern using source_fetcher.py)
- Add python-defined dependency information: translate Python package version
  requirements into Nix expressions; handle wheel-level binary ABI compat
- 7c mixing check limitation: only fires via `result.python.withPackages`;
  revisit when buildSource lands for torch
- Add cu130 support to `concretise/default.nix` once nixpkgs exposes
  `cudaPackages_13_0` (hash files already generated in
  `pkgs/torch/binary-hashes/cu130.nix`)
- `_checkBinAvailable` does not account for `canBuildBin`: when
  `allowBuildingFromSource = false`, the fail-early check passes if a binary
  version exists but `canBuildBin` would return false for it.  The error is
  still caught (inside `buildOne`), just not as early.  Revisit once the
  `canBuildBin` predicate is used by more packages.