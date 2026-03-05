## Python-defined version constraints script

The `versionConstraints` HLD field and merging logic in `concretise/default.nix` are in place, but no packages currently populate the field and no tooling exists to generate it.

Need a Python script (likely under `generate-hashes/`) that:
- Downloads or reads wheel METADATA for a given package + version
- Parses `Requires-Dist` entries to extract dependency version bounds
- Outputs a Nix snippet suitable for pasting into a `versionConstraints` field

Neither flash-attn 2.8.3 nor causal-conv1d 1.6.0 declare a torch version bound in their `install_requires` (both just say `torch`), so for current packages this produces empty output. The script is still worth building so future packages with real constraints can be handled automatically.

ABI-level per-version binary compat is already handled separately by `canBuildBin`; `versionConstraints` is specifically for Python-declared requirements.