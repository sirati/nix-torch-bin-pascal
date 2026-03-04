# Steps 7a + 7b + 7c + pkgs/ refactor – COMPLETE

All tasks are done and `nix flake check --no-build` passes cleanly.

---

## pkgs/ refactor (this session)

### What changed

- `torch/`, `flash-attn/`, `causal-conv1d/` moved into a new `pkgs/` subdirectory.

- `pkgs/default.nix` created: auto-discovers every subdirectory that contains a
  `high-level.nix` and builds a lazily-resolved fixed-point scope so inter-package
  dependencies are wired automatically by name (same pattern as `lib.makeScope` /
  `lib.fix` + `callPackage`).  No manual HLD wiring in `flake.nix` anymore.

- All relative paths inside moved files updated (`../` → `../../` for paths that
  crossed the new `pkgs/` boundary):
  - `pkgs/torch/high-level.nix`       – `../../concretise/hld-helpers.nix`
  - `pkgs/torch/override-common.nix`  – `../../generate-binary-hashes/lib.nix`
  - `pkgs/flash-attn/high-level.nix`  – `../../concretise/hld-helpers.nix`
  - `pkgs/flash-attn/override.nix`    – `../../generate-binary-hashes/lib.nix`
  - `pkgs/causal-conv1d/high-level.nix` – `../../concretise/hld-helpers.nix`
  - `pkgs/causal-conv1d/override.nix` – `../../generate-binary-hashes/lib.nix`

- `concretise/default.nix` – `../torch/cuda-packages-pascal.nix`
  → `../pkgs/torch/cuda-packages-pascal.nix`

- `test-retry-wrappers.nix` – same path update.

- `flake.nix` – manual `torchHLD` / `flashAttnHLD` / `causalConv1dHLD` bindings
  replaced with a single `pytorchScope = import ./pkgs;`.
  `pytorch-packages` output is now `pytorchScope // { concretise = …; }`.
  Path references to `./torch/cuda-packages-pascal.nix` updated to
  `./pkgs/torch/cuda-packages-pascal.nix`.

### Adding a new package

Create `pkgs/<name>/high-level.nix` as a function whose argument names match
other HLD attribute names in the scope.  `pkgs/default.nix` picks it up
automatically on the next evaluation — no changes to `flake.nix` needed.

---

## Step 7c – Cross-concretise mixing detection (COMPLETE)

### What was built

- `concretise/default.nix`: each concrete package is stamped with
  `passthru.concretiseMarker = "cuda=…,pascal=…,python=…"` via a new
  `addMarker` helper (applied in `buildOne`).

- `checkedWithPackages` wrapper replaces `augmentedPython.withPackages`.
  When called, it inspects every requested package for a `concretiseMarker`
  and throws a clear diagnostic if any marker differs from the current call's
  marker.  Packages without a marker (plain nixpkgs packages like `numpy`)
  are silently accepted.

- `result.python` now returns `checkedPython` (the wrapped interpreter) so
  callers automatically get the mixing check when they call
  `result.python.withPackages (ps: [...])`.

---

## Compiler-version validation (COMPLETE)

- `concretise/default.nix`: added `_checkCudaCompiler` assert (evaluated
  before the return attrset).  Checks that `pkgs.gcc13.version` starts with
  `"13."`.  Fails with a clear diagnostic if:
  - `pkgs.gcc13` is absent from the provided nixpkgs instance, or
  - its version major component is not 13.

---

## What was already built (steps 7a + 7b)

### 7a – Self-describing binary-hashes

- `generate-binary-hashes/nix_writer.py`: `prefix_attrs` / `prefix_attrs_fn` parameters.
- `torch/generate-hashes.py`: emits `_cudaLabel`.
- `flash-attn/generate-hashes.py` + `causal-conv1d/generate-hashes.py`: emit `_version`.
- Existing binary-hashes files patched with self-identifying keys.
- `concretise/hld-helpers.nix`: filters `_cudaLabel` in `getVersionsFromCudaFiles`.

### 7b – Fail-early binary availability check

- `concretise/default.nix`: `_checkBinAvailable` pre-flight check throws a clear
  diagnostic when `preferBin = true` and `getVersions` returns `[]`.

---

# Next steps (longer term)

- Implement `buildSource` / the four-derivation split described in `refactor_plan.md`
- 7c marker check does not cover the case where the user bypasses `result.python`
  and constructs a Python environment manually; document this limitation