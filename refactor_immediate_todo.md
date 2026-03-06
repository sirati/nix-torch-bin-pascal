# Immediate TODOs

## Run triton gen-hashes to migrate to per-version binary hash files

The triton binary-hashes layout was changed from a single `any.nix` to per-version
`v{version}.nix` files.  A fallback ensures the old `any.nix` still works during
the transition, but the new layout should be activated:

  nix run .#default.triton.gen-hashes

After that succeeds, delete `pkgs/triton/binary-hashes/any.nix`.

## Test gen-hashes refactor

Run the refactored runner end-to-end (binary hashes only, single tag) for each
github-releases package to confirm the shared main + default regex work correctly:

  nix run .#default.flash-attn.gen-hashes -- --skip-source --tag v2.8.1
  nix run .#default.causal-conv1d.gen-hashes -- --skip-source --tag v1.6.0
  nix run .#default.mamba-ssm.gen-hashes -- --skip-source --tag v2.3.0

And for torch-website packages:

  nix run .#default.torch.gen-hashes -- --cuda cu128
  nix run .#default.triton.gen-hashes

Verify that the generated .nix files are identical to the existing ones (no content
change expected for github-releases packages — only the `# To regenerate:` comment
line changes from `nix-shell` to `nix run .#default.<pkg>.gen-hashes`).
For triton, per-version files are expected instead of `any.nix`.

## Other pending items (from human-todo-notes.md)

- Add test cases for CUDA 13.0 (infrastructure deferred; 12.6 tests added)
- `concretise` overlay/override hook: apply after HDLs are solved but before
  non-HLD python packages are resolved