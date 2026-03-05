This file is AI generated, and only for consumption by AI. It is to be as brief as possible, without examples, and should instead refer to other files.

# Implementation Overview

## High-Level Derivations (HLDs)

Field contract declared in [`pkgs/hld-type.nix`](pkgs/hld-type.nix).

Required fields: `highLevelDeps`, `getVersions`, `buildBin`, `buildSource`, `"origin-type"`, `srcOwner`, `srcRepo`.

Optional fields with static defaults: `canBuildBin` (default `_: true`), `versionConstraints` (default `{}`), `data` (default `{}`).

Optional fields with dynamic defaults (computed from `packageName` at validate time): `pname` (defaults to `packageName`), `nixpkgsAttr` (defaults to `packageName`).

Optional fields with conditional defaults (depend on `origin-type`):
- `mkChangelog`: for `"github-releases"` defaults to `hldHelpers."github-release-tag" srcOwner srcRepo`; **required** for `"torch-website"`.
- `mkOverrideInfo`: for `"github-releases"` defaults to `hldHelpers.mkOverrideInfo { pname; nixpkgsAttr; srcOwner; srcRepo; mkChangelog; }`; **required** for `"torch-website"`.

`packageName` is injected from the directory name by `pkgs/default.nix`; HLD files never set it but may declare it in their argument list to use as a value (e.g. for `pname = packageName`).

`"origin-type"` allowed values: `"github-releases"`, `"torch-website"`.  Current packages: causal-conv1d, flash-attn, mamba-ssm use `"github-releases"`; torch uses `"torch-website"` (binaries from download.pytorch.org).  For `"torch-website"` packages, `mkChangelog` and `mkOverrideInfo` must be provided explicitly in the HLD (no auto-default); they typically still point at the GitHub repo for source coordinates.

[`pkgs/default.nix`](pkgs/default.nix) auto-discovers all `pkgs/<name>/high-level.nix` files, builds a fixed-point scope so HLDs can reference siblings by name, injects both `hldHelpers` and `packageName = name` into each HLD's call scope, validates each result through `hldType.validate`, and stamps `_isHighLevelDerivation = true`.

Each HLD's `let` block defines `srcOwner`, `srcRepo`, `mkChangelog` (via `hldHelpers."github-release-tag"`), and `mkOverrideInfo` (via `hldHelpers.mkOverrideInfo`), then exposes them via `inherit` in the returned attrset alongside `"origin-type"`. `pname` and `nixpkgsAttr` are omitted when they equal `packageName` (validate fills them in); otherwise they are declared in the `let` block and inherited into the attrset.

`buildBin` and `buildSource` call `mkOverrideInfo { inherit pkgs cudaPackages version resolvedDeps; }` to obtain the `overrideInfo` bundle passed to `override.nix` / `override-source.nix`.

See [`pkgs/torch/high-level.nix`](pkgs/torch/high-level.nix), [`pkgs/flash-attn/high-level.nix`](pkgs/flash-attn/high-level.nix), [`pkgs/causal-conv1d/high-level.nix`](pkgs/causal-conv1d/high-level.nix), [`pkgs/mamba-ssm/high-level.nix`](pkgs/mamba-ssm/high-level.nix).

## Concretisation

[`concretise/default.nix`](concretise/default.nix) — single attrset argument: `{ pkgs, packages, python, cuda, torch, pascal?, allowBuildingFromSource }`.  Returns `{ env, devShell, python, packages }`.

Steps:
1. Validate inputs; resolve `cudaPackages`, `basePython`, `cudaLabel`.
2. Collect all transitive HLDs via `highLevelDeps`; topological sort (cycle detection included).
3. Merge `versionConstraints` from all HLDs (stricter bound wins).
4. Pre-resolve versions in dependency order so `canBuildBin` can inspect sibling versions.
5. For each HLD: pick latest version satisfying constraints; call `canBuildBin`; dispatch to `buildBin` or `buildSource`; accumulate `resolvedDeps`.
6. Build Python environment with cross-concretise mixing detection via `checkedWithPackages`.

## hldHelpers

[`concretise/hld-helpers.nix`](concretise/hld-helpers.nix) provides:

- `isHLD` — predicate for validated HLDs.
- `getVersionsFromCudaFiles` — torch layout (one file per cuda label).
- `getVersionsFromVersionFiles` — flash-attn / causal-conv1d / mamba-ssm layout (one file per package version).
- `getVersionsFromSourceFiles` — source-hashes layout.
- `canBuildBinFromVersionFiles` — shared `canBuildBin` for version-file packages.
- `requireSourceHash` — shared `buildSource` pre-flight; validates version non-null and source-hashes file exists; returns validated version string or throws.
- `"github-release-tag"` — `owner: repo: v:` → standard GitHub releases changelog URL; used as default `mkChangelog` for `"github-releases"` packages.
- `mkOverrideInfo` — `{ pname, nixpkgsAttr, srcOwner, srcRepo, mkChangelog }: { pkgs, cudaPackages, version, resolvedDeps }:` → standard `overrideInfo` attrset (`pkgs`, `cudaPackages`, `pname`, `srcOwner`, `srcRepo`, `version`, `basePkg`, `changelog`, `torch`); used by all HLD files and as the default `mkOverrideInfo` for `"github-releases"` packages.

## Override files

`override.nix` (binary wheel install) and `override-source.nix` (source build) under each `pkgs/<name>/` receive a single `overrideInfo` attrset. They delegate to:

- [`wheel-helpers.nix`](wheel-helpers.nix) (`buildBinWheel`) for binary installs.
- [`concretise/source-build-helpers.nix`](concretise/source-build-helpers.nix) (`buildSourcePackage`) for source builds.

Both helpers unpack `overrideInfo` fields (`pkgs`, `cudaPackages`, `pname`, `srcOwner`, `srcRepo`, `version`, `basePkg`, `changelog`, `torch`) internally.

## Hash and wheel data generation

Binary wheel hashes: `pkgs/<pkg>/binary-hashes/`.  Source hashes: `pkgs/<pkg>/source-hashes/`.  Each package has its own `generate-hashes.py` entry point.

Shared Python tooling in [`generate-hashes/`](generate-hashes/): `common/`, `nix_writer/`, `github_release_runner/`, `source_fetcher.py`, `pkg_helpers.py`.

## Retry wrappers

[`nix-retry-wrapper/`](nix-retry-wrapper/) — currently not wired in. Re-enable via commented-out lines in `concretise/default.nix` and each `high-level.nix`.