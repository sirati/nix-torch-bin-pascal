This file is AI generated, and only for consumption by AI. It is to be as brief as possible, without examples, and should instead refer to other files.

# Implementation Overview

## High-Level Derivations (HLDs)

Field contract declared in [`pkgs/hld-type.nix`](pkgs/hld-type.nix).  Required fields: `highLevelDeps`, `getVersions`, `buildBin`, `buildSource`.  Optional: `canBuildBin` (default `_: true`), `versionConstraints` (default `{}`), `data` (default `{}`).  `packageName` is injected from the directory name; HLD files never set it.

[`pkgs/default.nix`](pkgs/default.nix) auto-discovers all `pkgs/<name>/high-level.nix` files, builds a fixed-point scope so HLDs can reference siblings by name, validates each result through `hldType.validate`, and stamps `_isHighLevelDerivation = true`.  The `fix` combinator is defined locally because this file does not import nixpkgs.

Each HLD receives `hldHelpers` (from [`concretise/hld-helpers.nix`](concretise/hld-helpers.nix)) injected by `pkgs/default.nix`.

See [`pkgs/torch/high-level.nix`](pkgs/torch/high-level.nix), [`pkgs/flash-attn/high-level.nix`](pkgs/flash-attn/high-level.nix), [`pkgs/causal-conv1d/high-level.nix`](pkgs/causal-conv1d/high-level.nix).

## Concretisation

[`concretise/default.nix`](concretise/default.nix) — single attrset argument: `{ pkgs, packages, python, cuda, torch, pascal?, allowBuildingFromSource }`.  Returns `{ env, devShell, python, packages }`.

Steps:
1. Validate inputs; resolve `cudaPackages`, `basePython`, `cudaLabel`.
2. Collect all transitive HLDs via `highLevelDeps`; topological sort (cycle detection included).
3. Merge `versionConstraints` from all HLDs (stricter bound wins).
4. Pre-resolve versions in dependency order so `canBuildBin` can inspect sibling versions.
5. For each HLD: pick latest version satisfying constraints; call `canBuildBin`; dispatch to `buildBin` or `buildSource`; accumulate `resolvedDeps`.
6. Build Python environment with cross-concretise mixing detection via `checkedWithPackages`.

Version-scanning helpers live in [`concretise/hld-helpers.nix`](concretise/hld-helpers.nix): `getVersionsFromCudaFiles` (torch layout: one file per cuda label), `getVersionsFromVersionFiles` (flash-attn / causal-conv1d layout: one file per package version).  Also provides `canBuildBinFromVersionFiles` (shared `canBuildBin` for version-file packages; used by flash-attn, causal-conv1d, mamba-ssm) and `requireSourceHash` (shared `buildSource` pre-flight that validates version non-null and source-hashes file exists, returning the validated version string or throwing a descriptive error).

## Hash and wheel data generation

Binary wheel hashes: `pkgs/<pkg>/binary-hashes/`.  Source hashes: `pkgs/<pkg>/source-hashes/`.  Each package has its own `generate-hashes.py` entry point.

Shared Python tooling in [`generate-hashes/`](generate-hashes/):
- [`common/`](generate-hashes/common/) — wheel entry parsing, version deduplication, sort keys, platform helpers.
- [`nix_writer/`](generate-hashes/nix_writer/) — writes binary-hashes and source-hashes Nix attrset files.
- [`github_release_runner/`](generate-hashes/github_release_runner/) — fetches GitHub release assets, computes Nix SRI hashes.
- [`source_fetcher.py`](generate-hashes/source_fetcher.py) — fetches tagged source trees (with submodules) and writes source-hashes files.
- [`pkg_helpers.py`](generate-hashes/pkg_helpers.py) — shared header template and `pkg_hash_dirs` helper used by per-package scripts.

Shared binary wheel build logic: [`wheel-helpers.nix`](wheel-helpers.nix) (`buildBinWheel`).

## Retry wrappers

[`nix-retry-wrapper/`](nix-retry-wrapper/) contains wrapper infrastructure (currently not wired into the build pipeline — see comment in [`concretise/default.nix`](concretise/default.nix)).  To re-enable, follow the commented-out lines in `concretise/default.nix` and each `high-level.nix`; the injection helper is [`nix-retry-wrapper/inject-wrappers.nix`](nix-retry-wrapper/inject-wrappers.nix).
