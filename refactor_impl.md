# Refactor Implementation Notes

## Status: steps 1–6 complete

---

## Settled decisions

### Folder names (step 1 ✓)
`torch-bin` → `torch`, `torch-bin-cu126` → `torch-cu126`, `torch-bin-cu128` → `torch-cu128`,
`flash-attn-bin` → `flash-attn`, `causal-conv1d-bin` → `causal-conv1d`.

Step 6 then merged `torch-cu126/` and `torch-cu128/` into `torch/` and deleted them.

### High-level derivations / HLD interface (steps 3–4 ✓)
Each package folder has `high-level.nix` exporting a plain attrset (not a derivation):
- `_isHighLevelDerivation = true`
- `packageName`
- `highLevelDeps = { name -> hld }`
- `getVersions = cudaLabel -> [versionString]`  ← delegates to `concretise/hld-helpers.nix`
- `buildBin  = { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version } -> drv`
- `buildSource = …` (throws – not yet implemented)

`getVersions` reads directly from the package's `binary-hashes/` folder so versions are
never hardcoded in the HLD itself.  The scanning/filtering logic is **shared** in
`concretise/hld-helpers.nix`; each HLD picks the appropriate helper with one line.

### `concretise/` folder (step 6 ✓)
`concretise.nix` was promoted to a folder so shared HLD utilities live alongside the
main concretise function without polluting the project root.

```
concretise/
  default.nix       ← the concretise function (import ./concretise resolves here)
  hld-helpers.nix   ← getVersionsFromCudaFiles, getVersionsFromVersionFiles
```

`concretise/default.nix` interface – single attrset argument:
```
{ pkgs, packages, python, cuda, pascal ? false, preferBin ? true }
```
- `python`   – human string `"3.11"` … `"3.14"`
- `cuda`     – human string `"12.6"` or `"12.8"`
- `packages` – list of HLDs; transitive deps collected automatically via `highLevelDeps`
- Uses `lib.toposort` for ordering; cycle detection included
- Returns `{ python, packages, env }`

Version selection: calls `hld.getVersions cudaLabel`, sorts with `lib.versionOlder`, picks latest.

### `concretise/hld-helpers.nix` (step 6 ✓)
Two reusable helpers for the two binary-hashes directory layouts:

- `getVersionsFromCudaFiles binaryHashesDir cudaLabel`
  For torch: reads `binaryHashesDir/{cudaLabel}.nix`, returns `builtins.attrNames`.
  Returns `[]` if the file does not exist.

- `getVersionsFromVersionFiles binaryHashesDir cudaLabel`
  For flash-attn / causal-conv1d: scans `binaryHashesDir/` for `v*.nix` files,
  returns only versions whose file contains a key for `cudaLabel` or the generic
  `"cu12"` fallback.

### `flake.nix` `pytorch-packages` output (step 5 ✓)
```
pytorch-packages = { torch; "flash-attn"; "causal-conv1d"; concretise; }
```
No prefix/suffix on names.

### Binary-hashes file layout (step 6 ✓)
```
torch/
  binary-hashes/
    cu126.nix         plain attrset: version → pyVer → os → arch → wheelData
    cu128.nix         same
  cuda-packages-pascal.nix        shared implementation: { pkgs, cudaLabel, cudaPackages }
  cuda-packages-pascal-cu126.nix  5-line wrapper → cuda-packages-pascal.nix
  cuda-packages-pascal-cu128.nix  5-line wrapper → cuda-packages-pascal.nix
  manifests/
    cu126/cudnn/…
    cu126/libcutensor/…
    cu128/cudnn/…
    cu128/libcutensor/…
  generate-hashes.py   unified script; --cuda cu126|cu128 (defaults to all variants)
  override-common.nix  uses binaryHashes.${torchVersion} (plain attrset, not function call)
  high-level.nix

flash-attn/
  binary-hashes/
    v2.8.3.nix        plain attrset: cudaKey → torchCompat → pyVer → os → arch → wheelData
  override.nix        imports (./binary-hashes + "/v${version}.nix").${cudaVersion}
  high-level.nix      uses hldHelpers.getVersionsFromVersionFiles
  generate-hashes.py  uses write_binary_hashes_per_version; DIMENSIONS version-first

causal-conv1d/
  binary-hashes/
    v1.6.0.nix        same structure as flash-attn versioned file
  override.nix        same pattern as flash-attn
  high-level.nix      uses hldHelpers.getVersionsFromVersionFiles
  generate-hashes.py  same changes as flash-attn
```

`nix_writer.py` has `wrap_in_func` flag (default True → current behaviour;
False → plain `{ … }` attrset) and `write_binary_hashes_per_version` helper
that splits organized data by version key and writes one file per version.

### Deduplication decisions taken in step 6
- `torch/cuda-packages-pascal.nix` is the single source of truth for Pascal overrides;
  per-variant files are thin wrappers.  `flake.nix`, `test-retry-wrappers.nix`, and
  `concretise/default.nix` all call the shared file directly.
- `torch/generate-hashes.py` is a single script with `--cuda` flag; the plan's
  per-variant `generate-hashes-cu126.py` / `generate-hashes-cu128.py` were never created.
- `getVersions` logic is centralised in `concretise/hld-helpers.nix`; HLDs contain
  no scanning/filtering code of their own.

---

## Known limitations / follow-up work

### Self-describing binary-hashes files (step 7a – planned)
`torch/binary-hashes/cu126.nix` and `cu128.nix` are identified only by their filename.
If renamed the content becomes ambiguous.  Plan: add `_cudaLabel = "cu126";` as a
prefix attribute; `getVersionsFromCudaFiles` filters it out via
`builtins.filter (k: k != "_cudaLabel") (builtins.attrNames ...)`.
Same pattern for flash-attn / causal-conv1d: `_version = "2.8.3";` in each `v*.nix`.
`nix_writer.py` needs a `prefix_attrs` parameter to emit these automatically.

### Fail-early when no binary wheel exists (step 7b – planned)
When `preferBin = true` and `getVersions` returns `[]`, `concretise` falls through to
`buildSource` which immediately throws "not yet implemented".  The error is opaque.
A pre-flight check in `concretise/default.nix` should throw a clear message before
reaching `buildOne`.

### Cross-concretise mixing detection (step 7c – planned)
Packages concretised by two separate `concretise` calls can end up in the same Python
environment, silently causing mismatched CUDA/Python/Pascal assumptions.  Plan: stamp
each concrete package with an opaque `passthru.concretiseMarker` derivation encoding
`{ cuda, pascal, python }` and check for marker equality at overlay time.

### `buildSource` not implemented
All HLDs throw from `buildSource`.  No source-derivation layer exists yet.

### No compiler-version validation
`concretise` enforces GCC 13 via `pkgs.overrideCC` but does not verify that the nixpkgs
CUDA package set was itself compiled with a compatible compiler.  A fail-early assert
comparing `cudaPackages.stdenv.cc.version` against the allowed range would help.