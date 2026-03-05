

## HLD Python package dependency resolution

Currently, packages like `einops`, `transformers`, and `triton` are hardcoded as `pkgs.python3Packages.<name>` directly inside `override-source.nix` and `override.nix`.  This causes version conflicts (e.g. `pkgs.python3Packages.triton` 3.5.1 vs torch 2.10's propagated triton 3.6.0) and requires editing override files whenever a new HLD is added for a formerly-nixpkgs package.

Design: each HLD declares its non-HLD Python dependencies by name in a new `pythonDeps` field (list of strings, e.g. `[ "einops" "transformers" "triton" ]`).  During concretisation, dependency resolution proceeds in three passes:
1. Check if a peer HLD exists in the scope for that name (fix-point already resolves these).
2. Check if any already-concretised HLD has set the package via a future `providePythonPackage` mechanism.
3. Fall back to `pkgs.python3Packages.<name>`.

This means adding an HLD for e.g. `triton` later automatically supersedes the nixpkgs fallback for all packages declaring `"triton"` in `pythonDeps`, with zero changes to other HLDs.

As a byproduct, once `pythonDeps` is resolved per-HLD, the `buildBin` / `buildSource` implementations no longer need to manually thread through `pkgs.python3Packages.*` calls — `concretise` can inject a `resolvedPythonDeps` attrset alongside `resolvedDeps`, and the override files can consume it directly.  This further reduces per-package boilerplate.

## Python-defined version constraints script

The `versionConstraints` HLD field and merging logic in `concretise/default.nix` are in place, but no packages currently populate the field and no tooling exists to generate it.

Need a Python script (likely under `generate-hashes/`) that:
- Downloads or reads wheel METADATA for a given package + version
- Parses `Requires-Dist` entries to extract dependency version bounds
- Outputs a Nix snippet suitable for pasting into a `versionConstraints` field

Neither flash-attn 2.8.3 nor causal-conv1d 1.6.0 declare a torch version bound in their `install_requires` (both just say `torch`), so for current packages this produces empty output. The script is still worth building so future packages with real constraints can be handled automatically.

ABI-level per-version binary compat is already handled separately by `canBuildBin`; `versionConstraints` is specifically for Python-declared requirements.