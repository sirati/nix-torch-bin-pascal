This file is AI generated, and only for consumption by AI. It is to be as brief as possible, without examples, and should instead refer to other files.

# Implementation Overview

## High-Level Derivations (HLDs)

Field contract declared in [`pkgs/hld-type.nix`](pkgs/hld-type.nix).

Required fields: `highLevelDeps`, `getVersions`, `buildBin`, `buildSource`, `originType`, `srcOwner`, `srcRepo`.

Optional fields with static defaults: `canBuildBin` (default `_: true`), `versionConstraints` (default `{}`), `data` (default `{}`), `cudaAgnostic` (default `false`), `isBinBuildBroken` (default `_: false`), `isSourceBuildBroken` (default `_: false`).

Optional fields with dynamic defaults (computed from `packageName` at validate time): `pname` (defaults to `packageName`), `nixpkgsAttr` (defaults to `packageName`), `generateHashesScript` (auto-detects `pkgs/<packageName>/generate-hashes.py`).

Optional fields with conditional defaults (depend on `originType`):
- `mkChangelog`: for `"github-releases"` defaults to `hldHelpers."github-release-tag" srcOwner srcRepo`; **required** for `"torch-website"`.
- `mkOverlayInfo`: for `"github-releases"` defaults to `hldHelpers.mkOverlayInfo { pname; nixpkgsAttr; srcOwner; srcRepo; mkChangelog; }`; **required** for `"torch-website"`.

`packageName` is injected from the directory name by `pkgs/default.nix`; HLD files never set it but may declare it in their argument list to use as a value.

`originType` allowed values: `"github-releases"`, `"torch-website"`.  Current packages: causal-conv1d, flash-attn, mamba-ssm use `"github-releases"`; torch and triton use `"torch-website"`.

For `"github-releases"` packages, `mkChangelog` and `mkOverlayInfo` are auto-derived by `hld-type.nix` validate — HDL files need only provide `srcOwner` and `srcRepo`. `buildBin`/`buildSource` receive `mkOverlayInfo` from concretise via args (injected from the validated HLD), so they do not need to close over it locally.

For `"torch-website"` packages, `mkChangelog` and `mkOverlayInfo` must be provided explicitly in the HLD. `buildBin`/`buildSource` accept `mkOverlayInfo` as an optional arg (`? null`) for API consistency.

[`pkgs/default.nix`](pkgs/default.nix) auto-discovers all `pkgs/<name>/high-level.nix` files, builds a fixed-point scope so HLDs can reference siblings by name, injects both `hldHelpers` and `packageName = name` into each HLD's call scope, validates each result through `hldType.validate`, and stamps `_isHighLevelDerivation = true`.

When `cudaAgnostic = true` (set on triton) the store-path stamp omits the cuda, torch, and pascal dims so that the same triton derivation name is produced regardless of the enclosing concretise call's CUDA/torch settings.

See [`pkgs/torch/high-level.nix`](pkgs/torch/high-level.nix), [`pkgs/triton/high-level.nix`](pkgs/triton/high-level.nix), [`pkgs/flash-attn/high-level.nix`](pkgs/flash-attn/high-level.nix), [`pkgs/causal-conv1d/high-level.nix`](pkgs/causal-conv1d/high-level.nix), [`pkgs/mamba-ssm/high-level.nix`](pkgs/mamba-ssm/high-level.nix).

## Concretisation

[`concretise/default.nix`](concretise/default.nix) — single attrset argument: `{ pkgs, mlPackages, python, cuda, torch, pascal?, allowBuildingFromSource, extraPythonPackages?, pythonPackageOverrides? }`.  Returns `{ env, devShell, python, packages, extendEnv }`.

`pythonPackageOverrides` is an optional overlay (`self: super: { ... }`) applied to `basePython.pkgs` before any HLD packages are built. It allows pinning or overriding non-HLD Python dependencies (e.g. einops, transformers) that HLD overlay files reference via `pkgs.python3Packages.*`.

Supported CUDA versions: `"12.6"`, `"12.8"`, `"13.0"`.

Steps:
1. Validate inputs; resolve `cudaPackages`, `basePython` (with `pythonPackageOverrides` applied), `cudaLabel`.
2. Collect all transitive HLDs via `highLevelDeps`; topological sort (cycle detection included).
3. Merge `versionConstraints` from all HLDs (stricter bound wins).
4. Pre-resolve versions in dependency order so `canBuildBin` can inspect sibling versions.
5. For each HLD: pick latest version satisfying constraints; call `canBuildBin`; dispatch to `buildBin` or `buildSource` (passing `mkOverlayInfo` from the validated HLD); accumulate `resolvedDeps`.
6. Build Python environment with cross-concretise mixing detection via `checkedWithPackages`.

## hldHelpers

[`concretise/hld-helpers.nix`](concretise/hld-helpers.nix) provides:

- `isHLD` — predicate for validated HLDs.
- `getVersionsFromCudaFiles` — torch layout (one file per cuda label).
- `getVersionsFromVersionFiles` — flash-attn / causal-conv1d / mamba-ssm layout (one file per package version).
- `getVersionsFromAnyVersionFiles` — triton layout (per-version files, CUDA-agnostic).
- `getVersionsFromSourceFiles` — source-hashes layout.
- `canBuildBinFromVersionFiles` — shared `canBuildBin` for version-file packages.
- `requireSourceHash` — shared `buildSource` pre-flight; validates version non-null and source-hashes file exists; returns validated version string or throws.
- `"github-release-tag"` — `owner: repo: v:` → standard GitHub releases changelog URL; used as default `mkChangelog` for `"github-releases"` packages.
- `mkOverlayInfo` — `{ pname, nixpkgsAttr, srcOwner, srcRepo, mkChangelog }: { pkgs, cudaPackages, version, resolvedDeps }:` → standard `overlayInfo` attrset; used by all HLD files and as the default `mkOverlayInfo` for `"github-releases"` packages.

## Overlay files

`overlay-bin.nix` (binary wheel install) and `overlay-source.nix` (source build) under each `pkgs/<name>/` receive a single `overlayInfo` attrset. They delegate to:

- [`wheel-helpers.nix`](wheel-helpers.nix) (`buildBinWheel`) for binary installs.
- [`concretise/source-build-helpers.nix`](concretise/source-build-helpers.nix) (`buildSourcePackage`) for source builds.

Both helpers unpack `overlayInfo` fields (`pkgs`, `cudaPackages`, `pname`, `srcOwner`, `srcRepo`, `version`, `basePkg`, `changelog`, `torch`) internally.

## Concretisation — store-path naming and duplicate-dep filtering

`buildAndStamp` (in `concretise/default.nix`) builds the derivation (bin or source) and stamps it with:

- `name = "python${basePython.version}-${pname}-${version}${suffix}"` — full Python patch version (e.g. `3.13.11`).  The suffix depends on the package:
  - Normal packages: `-torch${torchMM}-${cudaLabel}[-pascal][-bin]`
  - Torch itself (`packageName == "torch"`): `-${cudaLabel}[-pascal][-bin]` (torch dim omitted)
  - `cudaAgnostic = true` packages (triton): `-bin` only (cuda/torch/pascal dims all omitted)
- `passthru.concretiseMarker` — opaque key for cross-call mixing detection.

`filterExtras` (used when building `env` and `extendEnv`) drops extra packages whose `pname`/`name` matches either a directly concretise-managed package (`concreteNameSet`) or a package directly propagated by one of those managed packages (`propagatedByConcreteSet`).  This prevents `buildEnv` conflicts when a concrete package propagates e.g. `einops` from `basePython.pkgs` while the user also passes `ps.einops` via `extraPythonPackages`.

## Hash and wheel data generation

Binary wheel hashes: `pkgs/<pkg>/binary-hashes/`.  Source hashes: `pkgs/<pkg>/source-hashes/`.  Each package has its own `generate-hashes.py` entry point.

All generated hash files are self-identifying: binary-hash files carry `_version = "…"` (and torch files carry `_cudaLabel = "…"`); source-hash files carry `_version = "…"` as the first attribute. File names follow the `v{version}.nix` / `{cudaLabel}.nix` convention for generator bookkeeping, but no code should rely on the filename to determine identity.

`write_binary_hashes_per_version` accepts `skip_existing: bool`. When `True` (used on full-scan / no `--tag` runs) it skips files that already exist. When `False` (used when `--tag` is explicit) it always overwrites. `run_source_hashes` applies the same logic.

`generateHashesScript` is an optional HLD field (dynamic default: auto-detects `pkgs/<packageName>/generate-hashes.py`).  `flake.nix` exposes a flake app at `apps.<system>.default.<packageName>.gen-hashes` for every HLD with a non-null `generateHashesScript`.

`binary-hashes/` layout variants:
- **Per-CUDA-label** (`{cudaLabel}.nix`, e.g. `cu128.nix`): used by torch.
- **Per-version** (`v{version}.nix`): used by flash-attn, causal-conv1d, mamba-ssm.
- **CUDA-agnostic per-version** (`v{version}.nix`): used by triton. `getVersionsFromAnyVersionFiles` scans for `v{semver}.nix` files and ignores `cudaLabel` entirely.

Shared Python tooling in [`generate-hashes/`](generate-hashes/): `common/`, `nix_writer/`, `github_release_runner/`, `source_fetcher.py`, `pkg_helpers.py`.

## Triton HLD

Triton is a separate HLD (`pkgs/triton/`) with pre-built wheels from `https://download.pytorch.org/whl/triton/`. Wheels are CUDA-agnostic (same wheel for cu126/cu128/cu130). Triton has `highLevelDeps = {}` (leaf node). Torch declares `highLevelDeps = { inherit triton; }` so concretise automatically pulls it in.

`pkgs/triton/overlay-bin.nix` extends the upstream `triton-bin` derivation with two NixOS compatibility fixes in `postFixup`:
1. **ldconfig patch**: `driver.py` calls `/sbin/ldconfig -p` directly; patched to short-circuit via CUDA stubs dir.
2. **C compiler patch**: `triton/runtime/build.py` searches for `gcc`/`clang` on `PATH`; patched to fall back to Nix-provided `gcc`.

## Retry wrappers

[`nix-retry-wrapper/`](nix-retry-wrapper/) — currently not wired in.
