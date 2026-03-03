# Refactor Implementation Notes

## Status: steps 1–5 complete; step 6 in progress

---

## Settled decisions

### Folder names (step 1 ✓)
`torch-bin` → `torch`, `torch-bin-cu126` → `torch-cu126`, `torch-bin-cu128` → `torch-cu128`,
`flash-attn-bin` → `flash-attn`, `causal-conv1d-bin` → `causal-conv1d`.

### High-level derivations / HLD interface (steps 3–4 ✓)
Each package folder has `high-level.nix` exporting a plain attrset (not a derivation):
- `_isHighLevelDerivation = true`
- `packageName`
- `highLevelDeps = { name -> hld }`
- `getVersions = cudaLabel -> [versionString]`  ← replaces old `binVersions`/`defaultVersion`
- `buildBin  = { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version } -> drv`
- `buildSource = …` (throws – not yet implemented)

`getVersions` reads directly from the package's `binary-hashes/` folder so versions are
never hardcoded in the HLD itself.

### `concretise.nix` interface (step 4 ✓, partially updated)
Single attrset argument:
```
{ pkgs, packages, python, cuda, pascal ? false, preferBin ? true }
```
- `python` – human string `"3.11"` … `"3.14"`
- `cuda`   – human string `"12.6"` or `"12.8"`
- `packages` – list of HLDs; transitive deps collected automatically via `highLevelDeps`
- Uses `lib.toposort` for ordering; cycle detection included
- Returns `{ python, packages, env }`

Version selection: calls `hld.getVersions cudaLabel`, sorts with `lib.versionOlder`, picks latest.

### `flake.nix` `pytorch-packages` output (step 5 ✓)
```
pytorch-packages = { torch; "flash-attn"; "causal-conv1d"; concretise; }
```
No prefix/suffix on names.

### Binary-hashes file layout (step 6 – in progress)
New layout (replaces per-CUDA `torch-cu126/` and `torch-cu128/` folders):
```
torch/
  binary-hashes/
    cu126.nix    # plain attrset: version → pyVer → os → arch → wheelData
    cu128.nix    # same
  cuda-packages-pascal-cu126.nix
  cuda-packages-pascal-cu128.nix
  manifests/cu126/…
  manifests/cu128/…
  generate-hashes-cu126.py
  generate-hashes-cu128.py
  override-common.nix   # uses binaryHashes.${torchVersion} (not a function call)
  high-level.nix

flash-attn/
  binary-hashes/
    v2.8.3.nix   # plain attrset: cudaKey → torchCompat → pyVer → os → arch → wheelData
  override.nix   # imports (./binary-hashes + "/v${version}.nix").${cudaVersion}
  high-level.nix
  generate-hashes.py

causal-conv1d/
  binary-hashes/
    v1.6.0.nix   # same structure as flash-attn
  override.nix
  high-level.nix
  generate-hashes.py
```

`nix_writer.py` gains a `wrap_in_func` flag (default True → current behaviour;
False → plain `{ … }` attrset) plus a `write_binary_hashes_per_version` helper
that splits organized data by version key and writes one file per version.

---

## Known limitations / follow-up work
- `buildSource` not implemented (all HLDs throw).
- No cross-concretise mixing detection yet.