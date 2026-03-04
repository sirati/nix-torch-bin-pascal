# Steps 7a + 7b – COMPLETE

All tasks from steps 7a and 7b are done and `nix flake check --no-build` passes cleanly.

## What was actually built

### 7a – Self-describing binary-hashes

- `generate-binary-hashes/nix_writer.py`: added `prefix_attrs: dict[str, str] | None = None`
  parameter to `write_binary_hashes_nix`; when provided the entries are emitted verbatim as
  the *first* attributes inside the top-level attrset before any sorted wheel keys.
  Added `prefix_attrs_fn: Callable[[str], dict[str, str]] | None = None` to
  `write_binary_hashes_per_version`; it is called with the version string and the result
  forwarded to each `write_binary_hashes_nix` call.

- `torch/generate-hashes.py`: passes `prefix_attrs={"_cudaLabel": cuda_variant}` so future
  regenerations automatically emit the self-identifying key.

- `flash-attn/generate-hashes.py` + `causal-conv1d/generate-hashes.py`: pass
  `prefix_attrs_fn=lambda version: {"_version": version}`.

- Existing binary-hashes files patched in-place:
  - `torch/binary-hashes/cu126.nix` → `_cudaLabel = "cu126";`
  - `torch/binary-hashes/cu128.nix` → `_cudaLabel = "cu128";`
  - `flash-attn/binary-hashes/v2.8.3.nix` → `_version = "2.8.3";`
  - `causal-conv1d/binary-hashes/v1.6.0.nix` → `_version = "1.6.0";`

- `concretise/hld-helpers.nix` – `getVersionsFromCudaFiles` now filters `_cudaLabel` via
  `builtins.filter (k: k != "_cudaLabel") (builtins.attrNames ...)`.
  `getVersionsFromVersionFiles` is unchanged because it only checks `hasAttr cudaLabel` (never
  `attrNames`), so the new `_version` key does not affect it.

### 7b – Fail-early binary availability check

- `concretise/default.nix`: added `_checkBinAvailable` which, when `preferBin = true`,
  iterates `sortedHLDs` and throws a clear diagnostic if any package returns `[]` from
  `getVersions cudaLabel`.  Asserted together with the other input checks before the return
  attrset.

---

## Verified: high-level definition style works end-to-end

All checks below are pure `nix eval` (no build):

| Scenario | Result |
|---|---|
| `torch` only, cu126, py313, pascal | `torch 2.10.0` → correct wheel selected |
| `flash-attn` only (torch implied), cu126, py312 | both packages resolve; correct wheels |
| All three pkgs, cu128, py312 | all three packages resolve; correct cu128 wheels |
| `cuda = "11.8"` (invalid) | immediate error: *unsupported cuda '11.8'* |
| HLD with no wheels + `preferBin = true` | immediate error: *no pre-built wheel for 'my-custom-pkg' with cudaLabel 'cu126'* |
| HLD with no wheels + `preferBin = false` | `_checkBinAvailable` bypassed; lazy `buildSource not implemented` in result |

---

# Step 7c – Cross-concretise mixing detection (deferred)

**Status: deferred** — not blocking any current use-cases.

Approach when needed: stamp each concrete package with a small `passthru.concretiseMarker`
derivation (encoding `{ cuda, pascal, python }`) produced once per `concretise` call.
The Python overlay can then check that all packages in a `withPackages` call share the
same marker and throw otherwise.

---

# Next steps (longer term)

- Implement `buildSource` / the four-derivation split described in `refactor_plan.md`
- Add compiler-version validation inside `concretise` (assert `cudaPackages.stdenv.cc`
  is within the GCC 12–13 range for CUDA 12.x)
- 7c cross-concretise mixing detection (see above)