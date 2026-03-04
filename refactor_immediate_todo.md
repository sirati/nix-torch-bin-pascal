# Immediate TODOs

## causal-conv1d 1.6.0 ABI incompatibility with torch >= 2.9

### Finding (this session)

Attempted `nix build` for Python 3.13 + CUDA 12.8:

- **torch only** (`test-torch-py313-cu128`): **SUCCESS** — torch 2.10.0+cu128
  built and `torch.cuda.is_available()` returned `True`.

- **torch + causal-conv1d** (`test-causal-conv1d-py313-cu128`): **FAIL** at
  `pythonImportsCheckPhase` with:

  ```
  ImportError: causal_conv1d_cuda.cpython-313-x86_64-linux-gnu.so:
    undefined symbol: _ZN3c104cuda29c10_cuda_check_implementationEiPKcS2_ib
  ```

  Demangled: `c10::cuda::c10_cuda_check_implementation(int, char const*,
  char const*, int, bool)` — a symbol that was removed from PyTorch in a
  release between 2.8 and 2.10.

- **all three** (`test-all-py313-cu128`): not attempted (blocked by above).

### Root cause

`pkgs/causal-conv1d/binary-hashes/v1.6.0.nix` contains cu12 compat keys only
up to `"2.8"`.  `concretise` picks torch 2.10.0 (latest available for
cu128/py313), the compat fallback logic in `override.nix` selects the 2.8
wheel, but that wheel references `c10_cuda_check_implementation` which was
removed in torch >= 2.9.  This is a genuine ABI break.

The same issue will affect the cu126 default build (which also now has torch
2.10.0 as latest).

### Investigation needed before fixing

1. Confirm whether `c10_cuda_check_implementation` was removed in 2.9 or 2.10
   (check PyTorch changelog / GitHub).
2. Check whether causal-conv1d has a release newer than 1.6.0 with wheels
   built against torch 2.9 / 2.10:
   https://github.com/Dao-AILab/causal-conv1d/releases
3. If a newer causal-conv1d release exists, run its `generate-hashes.py` and
   add the new `binary-hashes/v{version}.nix` file.
4. If no newer release exists, the only short-term fix is to cap torch at 2.8
   when causal-conv1d is in the package list — this requires a version-capping
   mechanism in `concretise` (see design note below).

### Design note – version capping

One option: let HLDs declare an optional `maxTorchVersion` field (or a
`versionConstraints` field) that `concretise` respects when selecting the torch
version via `getVersions`.  Alternatively, the compat-key selection logic in
`causal-conv1d/override.nix` could be extended to refuse compat keys that are
known to be ABI-incompatible with the resolved torch version.

A simpler short-term option: downgrade the maximum cu128 and cu126 torch
version to 2.8.x until a causal-conv1d update is available — i.e. remove the
2.9.x and 2.10.x entries from the binary-hashes files.  This is safe because
those entries are not yet used by any working build.

### Also check: default cu126-pascal build

The default flake output (`packages.x86_64-linux.default`) uses cu126 + pascal
+ all three packages + Python 3.13.  Since cu126 also now has torch 2.10.0 as
latest, it will hit the same ABI break.  Verify by building:

```
nix build .#packages.x86_64-linux.default
```

and confirm whether it passes or fails.

---

## Previously completed (kept for reference)

- HLD type + hldHelpers injection complete
- Steps 7a + 7b + 7c complete
- pkgs/ refactor complete
- Compiler-version validation in concretise/default.nix complete
- Cross-concretise mixing detection (concretiseMarker + checkedWithPackages) complete

---

## Next steps (longer term, unblocked)

- Implement `buildSource` / the four-derivation split described in
  `refactor_plan.md` — this is the main remaining feature (independent of the
  causal-conv1d ABI issue above)
- 7c mixing check limitation: only fires via `result.python.withPackages`;
  document this when buildSource lands