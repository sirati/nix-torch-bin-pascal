## Longer-term

- Add cu130 support once nixpkgs exposes `cudaPackages_13_0`
- `_checkBinAvailable` does not account for `canBuildBin` when
  `allowBuildingFromSource = false`
- Add python-defined dependency information / wheel-level ABI compat in Nix
- mixing check: only fires via `result.python.withPackages`; revisit when
  buildSource lands for torch