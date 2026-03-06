# Immediate TODOs

## Test gen-hashes refactor

Run the refactored runner end-to-end (binary hashes only, single tag) for each github-releases package to confirm the shared main + default regex work correctly:

  nix run .#default.flash-attn.gen-hashes -- --skip-source --tag v2.8.1
  nix run .#default.causal-conv1d.gen-hashes -- --skip-source --tag v1.6.0
  nix run .#default.mamba-ssm.gen-hashes -- --skip-source --tag v2.3.0

And for torch-website packages:

  nix run .#default.torch.gen-hashes -- --cuda cu126
  nix run .#default.triton.gen-hashes

Verify that the generated .nix files are identical to the existing ones (no content change expected — only the `# To regenerate:` comment line changes from `nix-shell` to `nix run .#default.<pkg>.gen-hashes`).


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