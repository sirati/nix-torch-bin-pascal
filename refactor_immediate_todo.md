## Longer-term

- Add cu130 support once nixpkgs exposes `cudaPackages_13_0`
- Add python-defined dependency information / wheel-level ABI compat in Nix
- mixing check: only fires via `result.python.withPackages`; revisit when
  buildSource lands for torch