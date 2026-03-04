# Refactor Implementation Notes

## Status: steps 1–7c complete + pkgs/ refactor complete

---

## pkgs/ refactor (this session)

All three package directories moved under a new `pkgs/` subdirectory.
`pkgs/default.nix` auto-discovers every subdirectory that contains a
`high-level.nix` file and builds a lazily-resolved fixed-point scope using the
`lib.fix` + `builtins.functionArgs` pattern so inter-HLD dependencies are
wired automatically by name — no manual listing in `flake.nix`.

`flake.nix` reduced to:
```
pytorchScope = import ./pkgs;
pytorch-packages = pytorchScope // { concretise = import ./concretise; };
```

Adding a new package: create `pkgs/<name>/high-level.nix` as a function whose
argument names match peer HLD attribute names.  Auto-discovered on the next
evaluation.

All relative paths inside moved files updated (`../` → `../../` for every
cross-`pkgs/`-boundary import):
- `high-level.nix` files  → `../../concretise/hld-helpers.nix`
- `override*.nix` files   → `../../generate-binary-hashes/lib.nix`
- `concretise/default.nix` → `../pkgs/torch/cuda-packages-pascal.nix`
- `test-retry-wrappers.nix` → `./pkgs/torch/cuda-packages-pascal.nix`

---

## Step 7c – Cross-concretise mixing detection (COMPLETE)

Each concrete package is stamped with
`passthru.concretiseMarker = "cuda=…,pascal=…,python=…"` via a new `addMarker`
helper applied inside `buildOne`.

`checkedWithPackages` wraps `augmentedPython.withPackages`: it inspects every
requested package for a `concretiseMarker` and throws a clear diagnostic if any
marker differs from the current call's key.  Plain nixpkgs packages (no marker)
are silently accepted.  `result.python` is now `checkedPython` so callers
automatically get the mixing check.

**Known limitation:** the check only fires when the caller uses
`result.python.withPackages`.  A user who constructs a Python environment
manually (e.g. `basePython.withPackages`) bypasses it.

---

## Compiler-version validation (COMPLETE)

`concretise/default.nix` now asserts that `pkgs.gcc13.version` starts with
`"13."`.  Fails early with a clear message if `pkgs.gcc13` is absent or has an
unexpected major version.

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

### Known limitations / follow-up work

### `buildSource` not implemented
All HLDs throw from `buildSource`.  No source-derivation layer exists yet.
This is the main remaining piece of the four-derivation split described in
`refactor_plan.md`.

### 7c mixing check is best-effort
`checkedWithPackages` only fires when callers use `result.python.withPackages`.
A manually constructed Python environment (e.g. via `basePython.withPackages`)
bypasses the check.  Document this in user-facing docs when buildSource lands.