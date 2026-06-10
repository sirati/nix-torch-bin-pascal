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

`originType` allowed values: `"github-releases"`, `"torch-website"`, `"pypi"`.  Current packages: causal-conv1d, flash-attn, mamba-ssm, bitsandbytes, rwkv7-kernels, quack-kernels, sonic-moe use `"github-releases"`; torch, triton, and torchao use `"torch-website"`; nvidia-cutlass-dsl, apache-tvm-ffi, torch-c-dlpack-ext use `"pypi"`.

For `"github-releases"` packages, `mkChangelog` and `mkOverlayInfo` are auto-derived by `hld-type.nix` validate — HDL files need only provide `srcOwner` and `srcRepo`. `buildBin`/`buildSource` receive `mkOverlayInfo` from concretise via args (injected from the validated HLD), so they do not need to close over it locally.

For `"pypi"` packages, `mkChangelog` defaults to the PyPI release page (`https://pypi.org/project/{pname}/{version}/`) and `mkOverlayInfo` to the standard factory.  Their generate-hashes modules define `run()` (dispatched like `"torch-website"` by `generate-hashes/main.py`) and use [`generate-hashes/source_pypi.py`](generate-hashes/source_pypi.py) (PyPI JSON API; sha256 digests come from the API, no downloads).

For `"torch-website"` packages, `mkChangelog` and `mkOverlayInfo` must be provided explicitly in the HLD. `buildBin`/`buildSource` accept `mkOverlayInfo` as an optional arg (`? null`) for API consistency.

[`pkgs/default.nix`](pkgs/default.nix) auto-discovers all `pkgs/<name>/high-level.nix` files, builds a fixed-point scope so HLDs can reference siblings by name, injects both `hldHelpers` and `packageName = name` into each HLD's call scope, validates each result through `hldType.validate`, and stamps `_isHighLevelDerivation = true`.

When `cudaAgnostic = true` (set on triton) the store-path stamp omits the cuda, torch, and pascal dims so that the same triton derivation name is produced regardless of the enclosing concretise call's CUDA/torch settings.

See [`pkgs/torch/high-level.nix`](pkgs/torch/high-level.nix), [`pkgs/triton/high-level.nix`](pkgs/triton/high-level.nix), [`pkgs/flash-attn/high-level.nix`](pkgs/flash-attn/high-level.nix), [`pkgs/causal-conv1d/high-level.nix`](pkgs/causal-conv1d/high-level.nix), [`pkgs/mamba-ssm/high-level.nix`](pkgs/mamba-ssm/high-level.nix), [`pkgs/bitsandbytes/high-level.nix`](pkgs/bitsandbytes/high-level.nix), [`pkgs/torchao/high-level.nix`](pkgs/torchao/high-level.nix).

## cudaPackages overrides

`pkgs/torch/` contains two `cudaPackages.overrideScope` helpers that are applied in `concretise/default.nix` before any package is built:

**[`pkgs/torch/cuda-packages-cudnn-fix.nix`](pkgs/torch/cuda-packages-cudnn-fix.nix)** — applied for `cu126` and `cu130`.  torch 2.10.0 wheels for those CUDA labels were compiled against cuDNN 9.15.1, while nixpkgs ships 9.13.0 for all package sets.  Reads `pkgs/torch/manifests/{cudaLabel}/cudnn/redistrib_9.15.1.json` and uses `prev.cudnn.overrideAttrs` to substitute the correct version.  `cudaVariant` is `"cuda13"` for cu130, `"cuda12"` for all others.

**[`pkgs/torch/cuda-packages-pascal.nix`](pkgs/torch/cuda-packages-pascal.nix)** — applied when `pascal = true`.  Overrides `cudnn` to 9.10.2 (last version supporting Pascal SM 6.x) and `libcutensor` to 2.1.0, reading from `pkgs/torch/manifests/{cudaLabel}/`.

The override chain in `concretise/default.nix`:
`baseCudaPackages` → `cudaPackagesWithCudnn` (cuDNN fix, cu126/cu130 only) → `cudaPackages` (pascal scope, pascal=true only).

Manifests are plain NVIDIA redistrib JSON files stored under `pkgs/torch/manifests/{cudaLabel}/{component}/redistrib_{version}.json`.  Currently cu126 and cu128 have cudnn 9.10.2 / 9.11.1; cu126 and cu130 have cudnn 9.15.1.

## Concretisation

[`concretise/default.nix`](concretise/default.nix) — single attrset argument: `{ pkgs, mlPackages, python, cuda, torch, pascal?, allowBuildingFromSource, extraPythonPackages?, pythonPackageOverrides? }`.  Returns `{ env, devShell, python, packages, extendEnv }`.

`pythonPackageOverrides` is an optional overlay (`self: super: { ... }`) applied to `basePython.pkgs` before any HLD packages are built. It allows pinning or overriding non-HLD Python dependencies (e.g. einops, transformers) that HLD overlay files reference via `pkgs.python3Packages.*`.

Supported CUDA versions: `"12.6"`, `"12.8"`, `"13.0"`.

Steps:
1. Validate inputs; resolve `cudaPackages` (with cuDNN fix and optional pascal overrides applied), `basePython` (with `pythonPackageOverrides` applied), `cudaLabel`.
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
- `getVersionsFromCudaFilesStableAbi` — torchao layout (per-CUDA-label files, stable ABI, no pyVer filtering).
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

`buildSourcePackage` accepts `cudaSupport ? true`; when `false` (pure-Python packages: quack-kernels, sonic-moe) it drops `cuda_nvcc` from build-system, the CUDA libs from buildInputs, and `CUDA_HOME` from env.

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
- **Per-CUDA-label** (`{cudaLabel}.nix`, e.g. `cu128.nix`): used by torch and torchao.
- **Per-version** (`v{version}.nix`): used by flash-attn, causal-conv1d, mamba-ssm.
- **CUDA-agnostic per-version** (`v{version}.nix`): used by triton. `getVersionsFromAnyVersionFiles` scans for `v{semver}.nix` files and ignores `cudaLabel` entirely.

Shared Python tooling in [`generate-hashes/`](generate-hashes/): `common/`, `nix_writer/`, `github_release_runner/`, `source_fetcher.py`, `pkg_helpers.py`.

## Triton HLD

Triton is a separate HLD (`pkgs/triton/`) with pre-built wheels from `https://download.pytorch.org/whl/triton/`. Wheels are CUDA-agnostic (same wheel for cu126/cu128/cu130). Triton has `highLevelDeps = {}` (leaf node). Torch declares `highLevelDeps = { inherit triton; }` so concretise automatically pulls it in.

`pkgs/triton/overlay-bin.nix` extends the upstream `triton-bin` derivation with two NixOS compatibility fixes in `postFixup`:
1. **ldconfig patch**: `driver.py` calls `/sbin/ldconfig -p` directly; patched to short-circuit via CUDA stubs dir.
2. **C compiler patch**: `triton/runtime/build.py` searches for `gcc`/`clang` on `PATH`; patched to fall back to Nix-provided `gcc`.

## torchao HLD

torchao (`pkgs/torchao/`) provides PyTorch-native quantization, sparsity, and optimization.  Wheels are distributed via `https://download.pytorch.org/whl/<cuVariant>/torchao/` (origin type `"torch-website"`).

Key properties:
- **Per-CUDA-variant** wheels (not cudaAgnostic): different wheels for cu126, cu128, cu130.
- **Stable ABI** (`cp310-abi3`): a single wheel per CUDA variant serves all Python 3.10+.  No per-pyVer dimension in hash files.
- **`torchAgnostic = true`**: CUDA kernels are compiled directly against CUDA libs, not against torch C++ ABI.  Store path omits the torch series dimension.
- **Has one submodule** (`third_party/cutlass`): source builds require `fetchSubmodules = true`.
- **Hash file layout**: `binary-hashes/{cudaLabel}.nix` with structure `version -> os -> arch -> {name, url, hash}`.

`getVersionsFromCudaFilesStableAbi` is used for version resolution (ignores pyVer parameter since stable ABI wheels work for all Python 3.10+).

`overlay-bin.nix` builds a `buildPythonPackage` directly (does not use `wheel-helpers.nix` `buildBinWheel`, since the hash structure lacks the torchCompat and pyVer dimensions that `buildBinWheel` expects).

`generate-hashes/source_torchao.py` provides the `TorchaoWheelSource` class (analogous to `TorchWheelSource` for torch and `TritonWheelSource` for triton).

## sonic-moe stack (sonic-moe, quack-kernels, nvidia-cutlass-dsl, apache-tvm-ffi, torch-c-dlpack-ext)

Dependency tree: sonic-moe → { torch, quack-kernels, nvidia-cutlass-dsl }; quack-kernels → { torch, nvidia-cutlass-dsl, apache-tvm-ffi, torch-c-dlpack-ext } (+ einops from nixpkgs).

- **sonic-moe** (`pkgs/sonic-moe/`): pure-Python, SOURCE-ONLY (bitsandbytes pattern), bare GitHub tags (`0.1.2`, custom `mkChangelog`).  `getVersions` gates Python >= 3.12.  `versionConstraints` pin torch 2.7.1–2.9.x, nvidia-cutlass-dsl 4.4.x and quack-kernels 0.3.11–0.4.x (quack 0.5.0 needs cutlass-dsl >= 4.5.2, conflicting with sonic-moe's `== 4.4.2` pin).  `torchAgnostic = true`.
- **quack-kernels** (`pkgs/quack-kernels/`): pure-Python, SOURCE-ONLY, v-prefixed tags (Dao-AILab/quack).  Import name is `quack`.  `torchAgnostic = true`.
- **nvidia-cutlass-dsl** (`pkgs/nvidia-cutlass-dsl/`): BIN-ONLY (`"pypi"`); wheels ship proprietary prebuilt MLIR/NVVM binaries.  PyPI splits it into a metadata-only meta wheel + `libs-base` (per-CPython manylinux) + `libs-cu13` (added for cu130).  overlay-bin.nix also installs the pinned cuda-python/cuda-bindings/cuda-pathfinder chain (absent from nixpkgs; pins in `binary-hashes/cuda-deps-cu1{2,3}.nix`, refresh with `--regen-cuda-deps`).  Hash files: `v{version}.nix` = `{ meta; base = pyVer->os->arch; cu13? }`, custom `getVersions` in the HLD.  libs-base uses a `.pth`-redirect layout, so the import check is a site-aware `postInstall` check, not `pythonImportsCheck`.  `torchAgnostic = true`.
- **apache-tvm-ffi** (`pkgs/apache-tvm-ffi/`): BIN-ONLY (`"pypi"`), `cudaAgnostic = true` (pure CPU lib, triton-style store stamp).  cp312-abi3 wheels are expanded to explicit pyVer entries at hash-generation time; layout matches `getVersionsFromAnyVersionFiles`.  Import name is `tvm_ffi`.
- **torch-c-dlpack-ext** (`pkgs/torch-c-dlpack-ext/`): BIN-ONLY (`"pypi"`), `torchAgnostic = true`, dep torch.  Developed in apache/tvm-ffi.

All three pypi overlays use `autoPatchelfHook` + `stdenv.cc.cc.lib` (standalone manylinux wheels dlopen/link libstdc++ without torch pre-loaded; `autoPatchelfIgnoreMissingDeps` where driver/torch libs resolve at runtime).

## Retry wrappers

[`nix-retry-wrapper/`](nix-retry-wrapper/) — currently not wired in.
