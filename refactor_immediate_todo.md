# Immediate TODOs

## Current work: HLD Python package dependency resolution

From `refactor_impl.md`: packages like `einops`, `transformers` are hardcoded as `pkgs.python3Packages.<name>` in override files. Design and implement `pythonDeps` field on HLDs so concretise can resolve Python dependencies through the fixed-point scope before falling back to nixpkgs.

Key design points already documented in `refactor_impl.md`:
- New `pythonDeps` field: list of string package names
- Resolution order: (1) peer HLD in scope, (2) already-concretised HLD output, (3) `pkgs.python3Packages.<name>` fallback
- Concretise injects `resolvedPythonDeps` attrset alongside `resolvedDeps`
- Override files consume `resolvedPythonDeps` instead of hardcoding `pkgs.python3Packages.*`
- Adding a new HLD for a formerly-nixpkgs package then auto-supersedes the fallback everywhere

## Other pending items (from human-todo-notes.md)

- Add test cases for CUDA 12.6 and CUDA 13.0
- Derivation store paths should encode torch/cuda/pascal version + `-bin` suffix for wheel builds
- Fix duplicate-package conflict when `extraPythonPackages` includes a package already in the HLD closure (einops conflict example in human-todo-notes.md)
- `concretise` overlay/override hook: apply after HDLs are solved but before non-HLD python packages are resolved