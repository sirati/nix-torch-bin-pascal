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

`"origin-type"` allowed values: `"github-releases"`, `"torch-website"`.  Current packages: causal-conv1d, flash-attn, mamba-ssm use `"github-releases"`; torch and triton use `"torch-website"` (binaries from download.pytorch.org).  For `"torch-website"` packages, `mkChangelog` and `mkOverrideInfo` must be provided explicitly in the HLD (no auto-default); they typically still point at the GitHub repo for source coordinates.

[`pkgs/default.nix`](pkgs/default.nix) auto-discovers all `pkgs/<name>/high-level.nix` files, builds a fixed-point scope so HLDs can reference siblings by name, injects both `hldHelpers` and `packageName = name` into each HLD's call scope, validates each result through `hldType.validate`, and stamps `_isHighLevelDerivation = true`.

Each HLD's `let` block defines `srcOwner`, `srcRepo`, `mkChangelog` (via `hldHelpers."github-release-tag"`), and `mkOverrideInfo` (via `hldHelpers.mkOverrideInfo`), then exposes them via `inherit` in the returned attrset alongside `"origin-type"`. `pname` and `nixpkgsAttr` are omitted when they equal `packageName` (validate fills them in); otherwise they are declared in the `let` block and inherited into the attrset.

`buildBin` and `buildSource` call `mkOverlayInfo { inherit pkgs cudaPackages version resolvedDeps; }` to obtain the `overlayInfo` bundle passed to `overlay.nix` / `overlay-source.nix`.

Optional fields with static defaults also include `cudaAgnostic` (default `false`). When `true` (set on the triton HLD) the store-path stamp omits the cuda, torch, and pascal dims so that the same triton derivation name is produced regardless of the enclosing concretise call's CUDA/torch settings.

See [`pkgs/torch/high-level.nix`](pkgs/torch/high-level.nix), [`pkgs/triton/high-level.nix`](pkgs/triton/high-level.nix), [`pkgs/flash-attn/high-level.nix`](pkgs/flash-attn/high-level.nix), [`pkgs/causal-conv1d/high-level.nix`](pkgs/causal-conv1d/high-level.nix), [`pkgs/mamba-ssm/high-level.nix`](pkgs/mamba-ssm/high-level.nix).

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
- `mkOverlayInfo` — `{ pname, nixpkgsAttr, srcOwner, srcRepo, mkChangelog }: { pkgs, cudaPackages, version, resolvedDeps }:` → standard `overlayInfo` attrset (`pkgs`, `cudaPackages`, `pname`, `srcOwner`, `srcRepo`, `version`, `basePkg`, `changelog`, `torch`); used by all HLD files and as the default `mkOverlayInfo` for `"github-releases"` packages.

## Overlay files

`overlay.nix` (binary wheel install) and `overlay-source.nix` (source build) under each `pkgs/<name>/` receive a single `overlayInfo` attrset. They delegate to:

- [`wheel-helpers.nix`](wheel-helpers.nix) (`buildBinWheel`) for binary installs.
- [`concretise/source-build-helpers.nix`](concretise/source-build-helpers.nix) (`buildSourcePackage`) for source builds.

Both helpers unpack `overlayInfo` fields (`pkgs`, `cudaPackages`, `pname`, `srcOwner`, `srcRepo`, `version`, `basePkg`, `changelog`, `torch`) internally.

## Concretisation — store-path naming and duplicate-dep filtering

`buildAndStamp` (in `concretise/default.nix`) replaces the former `buildOne` + `addMarker` pair.  It builds the derivation (bin or source) and immediately stamps it with:

- `name = "python${basePython.version}-${pname}-${version}${suffix}"` — full Python patch version (e.g. `3.13.11`).  The suffix depends on the package:
  - Normal packages: `-torch${torchMM}-${cudaLabel}[-pascal][-bin]`
  - Torch itself (`packageName == "torch"`): `-${cudaLabel}[-pascal][-bin]` (torch dim omitted — it is already encoded in pname+version)
  - `cudaAgnostic = true` packages (triton): `-bin` only (cuda/torch/pascal dims all omitted since the wheel is identical across all CUDA and torch versions)
- `passthru.concretiseMarker` — opaque key for cross-call mixing detection.

`filterExtras` (used when building `env` and `extendEnv`) drops extra packages whose `pname`/`name` matches either a directly concretise-managed package (`concreteNameSet`) or a package directly propagated by one of those managed packages (`propagatedByConcreteSet`).  This prevents `buildEnv` conflicts when a concrete package propagates e.g. `einops` from `basePython.pkgs` while the user also passes `ps.einops` (from `augmentedPython.pkgs`) via `extraPythonPackages` — both are the same version but have different store paths because `augmentedPython` is a distinct derivation.

## Hash and wheel data generation

Binary wheel hashes: `pkgs/<pkg>/binary-hashes/`.  Source hashes: `pkgs/<pkg>/source-hashes/`.  Each package has its own `generate-hashes.py` entry point.

All generated hash files are self-identifying: binary-hash files carry `_version = "…"` (and torch files carry `_cudaLabel = "…"`); source-hash files carry `_version = "…"` as the first attribute. File names follow the `v{version}.nix` / `{cudaLabel}.nix` convention for generator bookkeeping, but no code should rely on the filename to determine identity.

`write_binary_hashes_per_version` accepts `skip_existing: bool`. When `True` (used on full-scan / no `--tag` runs) it skips files that already exist to avoid redundant regeneration. When `False` (used when `--tag` is explicit) it always overwrites. `run_source_hashes` applies the same logic: skip existing files unless `--tag` was given explicitly.

`generateHashesScript` is an optional HLD field (dynamic default: auto-detects `pkgs/<packageName>/generate-hashes.py` via `builtins.pathExists`; resolves to the store path if found, `null` otherwise).  HLDs never need to declare it explicitly.  `flake.nix` iterates `pytorchScope`, and for every HLD with a non-null `generateHashesScript` exposes a flake app at `apps.<system>.<packageName>.gen-hashes` built by `generate-hashes/lib.nix`'s `makeGenHashesApp`.  The wrapper adds `python3`, `git`, `nix-prefetch-github` to `PATH` and sets `PYTHONPATH=$PWD/generate-hashes` before exec-ing the script; `$PWD` must be the project root.  Usage: `nix run .#flash-attn.gen-hashes -- --tag v2.8.1`.

`binary-hashes/` layout variants:
- **Per-CUDA-label** (`{cudaLabel}.nix`, e.g. `cu128.nix`): used by torch where wheels differ per CUDA version.
- **CUDA-agnostic** (`any.nix`): used by triton and any future package whose wheels are identical across all CUDA versions.  `getVersionsFromCudaFiles` tries `{cudaLabel}.nix` first; if absent it falls back to `any.nix`.  The file carries `_cudaLabel = "*"` as a self-documenting sentinel.  All underscore-prefixed keys are filtered out during version enumeration.

Shared Python tooling in [`generate-hashes/`](generate-hashes/): `common/`, `nix_writer/`, `github_release_runner/`, `source_fetcher.py`, `pkg_helpers.py`.

## Triton HLD

Triton is a separate HLD (`pkgs/triton/`) with pre-built wheels from `https://download.pytorch.org/whl/triton/`. Wheels are CUDA-agnostic (same wheel for cu126/cu128/cu130). Triton has `highLevelDeps = {}` (leaf node). Torch declares `highLevelDeps = { inherit triton; }` so concretise automatically pulls it in and passes `resolvedDeps.triton` to `torch-bin.override { inherit triton; }`.

Binary hashes live in `pkgs/triton/binary-hashes/v{version}.nix` — one file per triton version, each containing the CUDA-agnostic hash data for that version (`pyVer → os → arch → wheelData`).  `getVersionsFromAnyVersionFiles` scans for `v{semver}.nix` files and ignores `cudaLabel` entirely.  During the transition from the old `any.nix` layout, both helpers fall back to `any.nix` if no per-version files exist yet; run `nix run .#default.triton.gen-hashes` to migrate and then delete `any.nix`.

`pkgs/triton/overlay.nix` extends the upstream `triton-bin` derivation with two NixOS compatibility fixes in `postFixup`:
1. **ldconfig patch**: `driver.py` calls `/sbin/ldconfig -p` directly; patched via `sed` to insert an `os.path.exists(cudaStubsDir)` early-return guard so triton finds `libcuda.so.1` via the CUDA stubs without invoking `/sbin/ldconfig` (which does not exist on NixOS).
2. **C compiler patch**: `triton/runtime/build.py` searches for `gcc`/`clang` on `PATH` to compile `driver.c` on first use; patched to fall back to the Nix-provided `gcc` so compilation works outside a build sandbox.

## Retry wrappers

[`nix-retry-wrapper/`](nix-retry-wrapper/) — currently not wired in. Re-enable via commented-out lines in `concretise/default.nix` and each `high-level.nix`.