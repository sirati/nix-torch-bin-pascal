# Refactor Implementation Notes

## Status: steps 1–7c complete + pkgs/ refactor complete + HLD type + hldHelpers injection complete + preferBin→allowBuildingFromSource + nvidia-container key naming + canBuildBin + causal-conv1d buildSource + devShell fix + wheel-helpers extraction + generate-hashes rename + source-hashes folder + combined binary+source generator + causal-conv1d build-system fix + source_fetcher batch-clone + _checkBinAvailable canBuildBin fix + versionConstraints in hld-type + buildSource hash-existence checks

---

## This session

### `_checkBinAvailable`: account for `canBuildBin` using pre-resolved versions

**Problem**: `_checkBinAvailable` checked only whether binary-hash versions exist
for a (cudaLabel, pyVer) pair.  It did not call `canBuildBin`, so if versions
existed but `canBuildBin` returned false (e.g. causal-conv1d 1.6.0 with
torch >= 2.9), the early check passed silently and the real error only fired
later inside `buildOne`.

**Fix in `concretise/default.nix`**:

1. Extracted `_selectVersion hld → { allVersions, constrainedVersions, version }`
   helper to avoid duplicating version-selection logic between `buildOne` and
   `_checkBinAvailable`.

2. Added `preResolvedVersions` — a fold over `sortedHLDs` (topological order)
   that builds a `{ pkgName → { version = "…"; } }` map.  Because only
   `.version` is read by `canBuildBin` implementations, a minimal stub is
   sufficient.  Torch's stub is computed first (dep order), so
   causal-conv1d's `canBuildBin` correctly sees the torch version when called
   from the pre-flight check.

3. `_checkBinAvailable` now calls `hld.canBuildBin { resolvedDeps =
   preResolvedVersions; … }` for each HLD.  The error message now says e.g.:
   ```
   version 1.6.0 is ABI-incompatible with torch 2.10.0
   ```
   instead of the old "no pre-built wheel available" phrasing.

4. `buildOne` refactored to use `_selectVersion` (no logic change, just
   deduplication).

Verified: evaluating the flake with `allowBuildingFromSource = false` and
`torch = "2.10"` + causal-conv1d now throws from `_checkBinAvailable` with the
specific torch version in the message.

### `buildSource` source-hash existence check

Both `pkgs/causal-conv1d/high-level.nix` and `pkgs/flash-attn/high-level.nix`
`buildSource` functions now call `builtins.pathExists` before importing the
source-hashes file.  If the file is absent they throw a clear message with the
exact `generate-hashes.py` command to run, rather than a cryptic
"file not found" Nix error.

Example:
```
flash-attn buildSource: source-hashes/v2.8.3.nix does not exist.
Run: nix-shell pkgs/flash-attn/generate-hashes.py -- --source-only --tag v2.8.3
```

Also fixed a wrong error-message in flash-attn `buildSource` (was saying
"add a source-hashes entry" when it should say "add a binary-hashes entry").

### `versionConstraints` added to `hld-type.nix` as a declared optional field

Previously `versionConstraints` was an undocumented free-form attribute read
via `hld.versionConstraints or {}` in `concretise/default.nix`.  It is now
listed in `hld-type.nix`'s `fieldSpecs` with a proper description and
`default = {}`, making it discoverable and validated like the other optional
fields (`canBuildBin`, `data`).

### `flake.nix` `pytorch-packages` output: fix outdated API example

The comment block in the `pytorch-packages` output was using old argument names
(`cudaVersion`, `isPascal`, `pythonVersion`).  Updated to the current API:
`cuda`, `pascal`, `python`, `torch`, `allowBuildingFromSource`.

---

## This session

### causal-conv1d `override-source.nix`: align with upstream nixpkgs

The source build was failing with:
```
ERROR Missing dependencies: torch, nvidia-cuda-cupti-cu12==12.8.90, ...
```

Root cause: without `torch` in `build-system`, the PEP-517 build backend falls
back to pip to satisfy the torch build-time requirement, which then tries to
resolve all of torch's transitive nvidia-* deps from PyPI — failing in the Nix
sandbox.

Fix applied to `pkgs/causal-conv1d/override-source.nix`:
- `torch` added to `build-system` (mirrors upstream nixpkgs causal-conv1d)
- `cuda_nvcc` moved from `build-system` to `buildInputs` (it is a native tool,
  not a Python build-time package; upstream puts it in buildInputs)

Note: flash-attn's `override-source.nix` already matched the upstream nixpkgs
flash-attn pattern (cuda_nvcc in build-system, torch NOT in build-system), so
no change was needed there.

### `source_fetcher.py`: batch-clone optimisation for submodule hashes

`fetch_github_source_hashes_with_submodules_batch` added to `source_fetcher.py`.

Old approach: `nix-prefetch-github --fetch-submodules` once per tag → full fresh
clone of the (potentially large) repository per tag (~59 clones for flash-attn).

New batch approach:
1. `git clone --filter=blob:none --no-checkout <https_url> <mirror>` once.
2. For each tag, in the mirror:
   a. `git checkout --force <tag>` — checks out main-repo files.
   b. `git submodule update --init --recursive` — fetches and checks out all
      submodules.  Submodule git objects are cached in `<mirror>/.git/modules/`;
      tags that share a submodule commit (very common, e.g. the cutlass pin in
      flash-attn) skip the network download for that submodule entirely.
   c. Copy tree to scratch dir, excluding every `.git` directory (helper
      `_copy_tree_without_git` using `shutil.copytree` + `ignore_patterns`).
   d. `nix hash path --sri --type sha256 <scratch>` — NAR format is content +
      permissions only, timestamps are not part of the serialisation, so no
      normalisation is needed.  Verified: produces the same hash as
      `nix-prefetch-github --fetch-submodules` for v2.8.3
      (`sha256-6I1O4E5K5IdbpzrXFHK06QVcOE8zuVkFE338ffk6N8M=`).
   e. Delete scratch; proceed to next tag.
3. Return `{tag: sri_hash}` dict.

No dependency on `nix-prefetch-git` — only `git` and `nix` are required.
The initial `nix-prefetch-git` design was abandoned because nixpkgs-unstable
(26.05pre) installs the binary as `nix-prefetch-git-26.05pre-git` rather than
`nix-prefetch-git`, and because the direct approach also gives better submodule
caching (objects reused between tags in the same mirror).

### `runner.py`: use batch variant automatically for multi-tag submodule fetches

`run_source_hashes` now partitions tags into already-cached vs needs-fetching
before deciding strategy:

- `with_submodules=True` AND `--tag` NOT supplied AND >1 tag to fetch → batch
- Otherwise (single-tag `--tag` mode, or `with_submodules=False`) → existing
  per-tag path unchanged (still uses `nix-prefetch-github` for single-tag case)

### flash-attn `generate-hashes.py` shebang

Updated from `python3 nix nix-prefetch-github` to
`python3 nix git nix-prefetch-github` so the batch path has `git` available.
`nix-prefetch-git` was added then removed once the implementation switched to
the direct `git checkout` + `nix hash path` approach.

### Flash-attn source hashes — COMPLETE

All flash-attn source hashes generated and staged:
- v2.8.3 verified via single-tag run: hash matches known reference
  `sha256-6I1O4E5K5IdbpzrXFHK06QVcOE8zuVkFE338ffk6N8M=`
- Full run via batch path produced 56 new entries (v1.0.2 through
  vfa4-v4.0.0.beta1), all staged.
- `source-hashes/` now covers v0.2.7 through v2.8.3 plus the fa4 betas.

---

## This session

### devShell fix: `python3` in PATH for test environments

Added `devShell` attribute to the `concretise` return value (`concretise/default.nix`):

```
devShell = pkgs.mkShell { packages = [ env ]; };
```

`pkgs.mkShell` adds `packages` as `nativeBuildInputs`, so `nix develop` on the
resulting shell puts `$out/bin/python3` (from the `withPackages` env) in PATH.

Restructured `flake.nix`: merged `packages` and `devShells` into a single
`perSystem = forAllSystems (...)` binding that computes all test results once
and exposes them under both outputs.  Avoids duplicating expensive let-bindings
(CUDA package sets, concretise calls) across separate `genAttrs` invocations.

New `devShells` entries:
- `test-torch-py313-cu128`
- `test-causal-conv1d-py313-cu128`
- `test-causal-conv1d-from-source-py313-cu128`
- `test-all-py313-cu128`

`nix develop .#devShells.x86_64-linux.test-causal-conv1d-py313-cu128` now has
`python3` in PATH.

### `wheel-helpers.nix`: shared binary-wheel build helper

Extracted the duplicated compat-key selection + wheel-fetch + `buildPythonPackage`
logic from `pkgs/causal-conv1d/override.nix` and `pkgs/flash-attn/override.nix`
into a new top-level `wheel-helpers.nix`.

`wheel-helpers.nix` exports a single function `buildBinWheel`:

```
buildBinWheel {
  pname            # Python package name
  version          # Package version string
  binaryHashesFile # Path to the v{version}.nix file
  torch            # Resolved torch derivation
  meta             # Nix meta attrset
  cudaVersion      ? "cu12"
  cxx11abi         ? "TRUE"
  extraDependencies ? []
  pythonImportsCheck ? null   # null → [ pname ]
}
```

It imports `generate-binary-hashes/lib.nix` for platform detection, performs
the compat-key selection (best key <= torchMajorMinor, descending), fetches the
wheel with `pkgs.fetchurl`, and calls `buildPythonPackage { format = "wheel"; }`.

Both override.nix files are now thin wrappers (~20 lines each) that just supply
the package-specific fields.  The maxCompat error message is now unified: both
packages get the "highest available compat key is X" hint in the throw.

### `generate-binary-hashes/` → `generate-hashes/` rename

Renamed the `generate-binary-hashes/` directory to `generate-hashes/` via
`git mv`.  The directory now holds shared code for generating both binary
hashes (pre-built wheels) and source hashes (GitHub fetchFromGitHub info),
so the old name was misleading.

Updated all references:
- `wheel-helpers.nix` — `import ./generate-hashes/lib.nix`
- `pkgs/torch/override-common.nix` — `import ../../generate-hashes/lib.nix`
- `pkgs/{causal-conv1d,flash-attn,torch}/generate-hashes.py` — `sys.path` insert
- `generate-hashes/lib.nix` — usage comment examples
- `generate-hashes/source_github.py` — directory comment + User-Agent strings
- `concretise/default.nix` — inline comment

### Source-hashes folder + combined binary+source generator

**Source-hashes format** — one file per version in a `source-hashes/` folder
(mirrors `binary-hashes/`).  Each file is minimal:

```
# WARNING: Auto-generated file. Do not edit manually!
{
  rev  = "v1.6.0";
  hash = "sha256-hFaF/…";
}
```

`owner` and `repo` are emitted only when non-empty (i.e. when they differ
from the package's well-known defaults).  The consuming Nix code supplies
the defaults:

```nix
srcInfo  = import (./source-hashes + "/v${causalConv1dVersion}.nix");
srcOwner = srcInfo.owner or "Dao-AILab";
srcRepo  = srcInfo.repo  or "causal-conv1d";
```

**`generate-hashes/source_fetcher.py`** — shared module:
- `SourceEntry(version, tag, hash, owner="", repo="")` dataclass
- `fetch_github_source_hash(owner, repo, tag) -> str`
  Runs `nix store prefetch-file --hash-type sha256 --unpack <github-tarball-url>`
  and returns the SRI NAR hash expected by `fetchFromGitHub { hash = …; }`.
- `source_hash_exists(output_dir, version) -> bool`
  Returns True when `source-hashes/v{version}.nix` already exists on disk
  (used to skip re-downloading).
- `write_source_hash_file(output_dir, entry)`
  Writes `v{version}.nix` into `output_dir` (creates dir if absent).

**`generate-hashes/source_github.py`** — added module-level helpers:
- `list_release_tags(repo, token=None, include_prereleases=False) -> list[str]`
  Queries `GET /repos/{owner}/{repo}/releases` with pagination, returns tag
  names newest-first.
- `_api_headers_for_token` / `_api_get` extracted from the class so both the
  class and `list_release_tags` share the same HTTP logic.

**`pkgs/causal-conv1d/generate-hashes.py`** — rewritten as combined generator:
- Default: fetches ALL releases via `list_release_tags`, processes each tag.
- `--tag v1.x.y`: process a single specific tag (for incremental updates).
- `--skip-source`: binary hashes only.
- `--prereleases`: include pre-releases in the all-releases fetch.
- Applies `deduplicate_post_versions` across ALL fetched wheel entries before
  writing binary-hashes files.
- `winning_tag_for_base_versions(tags)`: maps each base version to the
  highest-post-number tag (using `parse_version_post` from `common.py`).
- For each binary version without an existing source-hashes file, calls
  `fetch_github_source_hash` and writes the file.

**`pkgs/causal-conv1d/source-hashes/v1.6.0.nix`** — created with the known
1.6.0 hash (sourced from nixpkgs).

**Deleted**:
- `pkgs/causal-conv1d/source-hashes.nix` (flat file replaced by folder)
- `pkgs/causal-conv1d/generate-source-hashes.py` (merged into generate-hashes.py)

**`pkgs/causal-conv1d/override-source.nix`** updated:
- Loads from `./source-hashes + "/v${causalConv1dVersion}.nix"` (folder).
- Supplies `srcOwner`/`srcRepo` defaults with `or` fallback.

---

## This session

### `canBuildBin` optional HLD field + causal-conv1d `buildSource`

#### Problem

causal-conv1d 1.6.0 ships no pre-built wheels for torch >= 2.9.  The cu12
compat keys stop at `"2.8"`.  When torch 2.9.x or 2.10.x was resolved,
`concretise` still called `buildBin` (a binary version existed in the hash
files) and `override.nix` silently fell back to the `"2.8"` compat wheel —
ABI-broken at runtime (missing symbol
`c10::cuda::c10_cuda_check_implementation`).

#### Solution

Three coordinated changes:

**`pkgs/hld-type.nix`** — added `canBuildBin` as an optional field:
```
canBuildBin = { resolvedDeps, version, cudaLabel } -> bool
```
Default: `_: true` (always buildable from binary — existing packages unaffected).
When it returns `false`, `concretise` treats the package as having no usable
binary for the current combination.

**`concretise/default.nix` `buildOne`** — added `binCompatible` check:
- `binCompatible = version != null && hld.canBuildBin { inherit resolvedDeps version cudaLabel; }`
- If `binCompatible` → `buildBin` (existing path)
- Else if `allowBuildingFromSource` → `buildSource args` (version passed through, may be non-null)
- Else → throw with clear message distinguishing "no version found" vs "ABI-incompatible"

**`pkgs/causal-conv1d/high-level.nix`** — added `canBuildBin`:
- Extracts `torchMajorMinor` from `resolvedDeps."torch".version` via `builtins.match`
- Loads `binary-hashes/v${version}.nix` `.cu12`, reads compat keys, sorts with
  `builtins.compareVersions`, finds `maxCompat`
- Returns `builtins.compareVersions torchMajorMinor maxCompat <= 0`

**`pkgs/causal-conv1d/override.nix`** — kept the belt-and-suspenders guard
(throws if called directly with incompatible torch); updated message to
indicate it is a safety net and that `concretise` normally routes via
`canBuildBin` before `buildBin` is invoked.

#### causal-conv1d `buildSource` implementation

Two new files:

**`pkgs/causal-conv1d/source-hashes.nix`** — maps version string to
`fetchFromGitHub` arguments:
```
{ "1.6.0" = { owner = "Dao-AILab"; repo = "causal-conv1d";
               rev = "v1.6.0";
               hash = "sha256-hFaF/oMdScDpdq+zq8WppWe9GONWppEEx2pIcnaALiI="; }; }
```
Hash sourced from nixpkgs `pkgs/development/python-modules/causal-conv1d/default.nix`.

**`pkgs/causal-conv1d/override-source.nix`** — `buildPythonPackage` derivation:
- `src`: `fetchFromGitHub` via `source-hashes.nix`
- `build-system`: `setuptools`, `pkgs.ninja`, `torch` (our binary torch)
- `nativeBuildInputs`: `pkgs.which`, `cudaPackages.cuda_nvcc`, `wrappers`
- `buildInputs`: `cuda_cudart`, `cuda_cccl`, `libcusparse`, `libcusolver`, `libcublas`
- `env.CAUSAL_CONV1D_FORCE_BUILD = "TRUE"`
- `env.CUDA_HOME = lib.getDev cudaPackages.cuda_nvcc`
- `preConfigure`/`preBuild`: put `wrappers/bin` at front of PATH
- `dependencies = [ torch ]`

`high-level.nix` `buildSource` delegates to `override-source.nix`, passing
`pkgs`, `cudaPackages`, `wrappers`, `torch = resolvedDeps."torch"`,
`causalConv1dVersion = version` (throws if version is null).

#### flake.nix test updates

Tests that combined `torch = "2.10"` + causal-conv1d + `allowBuildingFromSource = false`
were silently broken before (built an ABI-incompatible binary).  Updated:

- `defaultResult` (cu126-pascal, all three packages) → `allowBuildingFromSource = true`
- `testCausalCu128Result` → `torch = "2.8"`, `allowBuildingFromSource = false`
  (explicitly tests the binary wheel path with the highest compatible torch series)
- `testAllCu128Result` → `allowBuildingFromSource = true`
- `testCausalCu128FromSourceResult` unchanged: `torch = "2.10"`,
  `allowBuildingFromSource = true` (tests source build path)

`nix flake check --no-build` passes with only the pre-existing warnings
(dirty tree, unknown `pytorch-packages` output, app `meta` missing).


---

## This session

### `preferBin` → mandatory `allowBuildingFromSource`

`concretise/default.nix` interface change: removed the optional `preferBin ?
true` argument and replaced it with mandatory `allowBuildingFromSource`.

Semantics:
- `allowBuildingFromSource = false` — fail at evaluation time if any package
  in the build has no pre-built wheel (after applying any `versionConstraints`);
  the error message names the package and, if constraints narrowed the version
  list, shows both the constrained and unconstrained sets.
- `allowBuildingFromSource = true` — fall back to `buildSource` when no
  pre-built wheel is available.  Currently all `buildSource` implementations
  throw "not yet implemented", so this only makes sense once buildSource lands.

Internal changes:
- `buildOne` now uses `version != null` (not `preferBin && version != null`) to
  decide between bin and source paths.
- `_checkBinAvailable` condition inverted to `allowBuildingFromSource || ...`.
- All four `concretise` call-sites in `flake.nix` updated with
  `allowBuildingFromSource = false`.

### NixOS module removed from flake.nix

The `nixosModules.default` block (options + config for `programs.torch-cuda`)
was removed.  System-level integration is out of scope for this project.

### `versionConstraints` mechanism added to `concretise/default.nix`

`allVersionConstraints` and `applyVersionConstraints` helpers were added to
`concretise/default.nix`.  They read `hld.versionConstraints or {}` from each
HLD in the build and merge constraints by package name (taking the stricter
bound when two HLDs constrain the same dep).  Constraints are applied inside
`buildOne` before version selection, and inside `_checkBinAvailable`.

`hld-type.nix` does **not** currently list `versionConstraints` in
`fieldSpecs` (the field was intentionally left out after review — see
immediate todos for rationale).  The concretise code reads `or {}` so it is
safe and dormant until a genuine use-case is identified.

### `normalize_torch_compat` + `sort_torch_compat_key` in common.py

Added to `generate-binary-hashes/common.py`:

- `normalize_torch_compat(s)` — detects NVIDIA container version strings in
  YY.MM format (major >= 20) and prefixes them with `"nvidia-container-"` so
  they are unambiguous vs real PyTorch version numbers.
- `sort_torch_compat_key(k)` — sort key that places regular PyTorch versions
  before nvidia-container versions; within each group, numeric ordering.

Detection heuristic: `^\d{2}\.\d{2}$` with the major component >= 20.  Real
PyTorch major versions will remain single-digit for the foreseeable future.

`pkgs/causal-conv1d/generate-hashes.py` updated to import and use both
functions: `normalize_torch_compat` is called on every parsed `torch_compat`
value; `sort_torch_compat_key` is used as the `DimSpec.sort_key` for the
`torchCompat` dimension.

### cu13 keys renamed in `binary-hashes/v1.6.0.nix`

All cu13 torch-compat keys in
`pkgs/causal-conv1d/binary-hashes/v1.6.0.nix` were renamed from bare YY.MM
strings (`"25.08"`, `"25.09"`, …, `"26.01"`) to
`"nvidia-container-25.08"` etc., matching the output the updated
`generate-hashes.py` would produce on a fresh run.  The section comment lines
were also updated accordingly.

---

## HLD type + hldHelpers injection (previous session)

`pkgs/hld-type.nix` (new file) exports `mkHLD`, a constructor/validator for
HLD attrsets.  Required fields: `packageName`, `highLevelDeps`, `getVersions`,
`buildBin`, `buildSource`.  Optional field: `data` (defaults to `{}`).
Throws a descriptive error on any missing or unknown field.  Automatically
stamps the result with `_isHighLevelDerivation = true` so HLD authors never
set it manually.

`concretise/hld-helpers.nix` gained an `isHLD` helper
(`x: x._isHighLevelDerivation or false`) alongside the existing
`getVersionsFrom*` functions.

`pkgs/default.nix` extended: a `utilities` attrset `{ hldHelpers, mkHLD }` is
merged into the internal fixed-point scope before the per-package entries.  The
exported scope still contains only the three HLD attrsets — utilities are not
leaked to consumers.

All three `pkgs/*/high-level.nix` files updated:
- Signature: `{ hldHelpers, mkHLD }:` (plus peer HLD names for deps)
- `let hldHelpers = import …;` block removed
- `assert torch._isHighLevelDerivation or false` → `assert hldHelpers.isHLD torch`
- Return value wrapped with `mkHLD { … }`; `_isHighLevelDerivation = true` removed

---

## pkgs/ refactor (previous session)

All three package directories moved under a new `pkgs/` subdirectory.
`pkgs/default.nix` auto-discovers every subdirectory that contains a
`high-level.nix` file and builds a lazily-resolved fixed-point scope using the
`lib.fix` + `builtins.functionArgs` pattern so inter-HLD dependencies are
wired automatically by name — no manual listing in `flake.nix`.

`flake.nix` reduced to:
```
pytorchScope = import ./pkgs;
pytorch-packages = pytorchScope // { concretise = import ./concretise; };
```

Adding a new package: create `pkgs/<name>/high-level.nix` as a function whose
argument names match peer HLD attribute names.  Auto-discovered on the next
evaluation.

All relative paths inside moved files updated (`../` → `../../` for every
cross-`pkgs/`-boundary import):
- `high-level.nix` files  → `../../concretise/hld-helpers.nix`
- `override*.nix` files   → `../../generate-binary-hashes/lib.nix`
- `concretise/default.nix` → `../pkgs/torch/cuda-packages-pascal.nix`
- `test-retry-wrappers.nix` → `./pkgs/torch/cuda-packages-pascal.nix`

---

## Step 7c – Cross-concretise mixing detection (COMPLETE)

Each concrete package is stamped with
`passthru.concretiseMarker = "cuda=…,pascal=…,python=…"` via a new `addMarker`
helper applied inside `buildOne`.

`checkedWithPackages` wraps `augmentedPython.withPackages`: it inspects every
requested package for a `concretiseMarker` and throws a clear diagnostic if any
marker differs from the current call's key.  Plain nixpkgs packages (no marker)
are silently accepted.  `result.python` is now `checkedPython` so callers
automatically get the mixing check.

**Known limitation:** the check only fires when the caller uses
`result.python.withPackages`.  A user who constructs a Python environment
manually (e.g. `basePython.withPackages`) bypasses it.

---

## Compiler-version validation (COMPLETE)

`concretise/default.nix` now asserts that `pkgs.gcc13.version` starts with
`"13."`.  Fails early with a clear message if `pkgs.gcc13` is absent or has an
unexpected major version.

---

## Settled decisions

### Folder names (step 1 ✓)
`torch-bin` → `torch`, `torch-bin-cu126` → `torch-cu126`, `torch-bin-cu128` → `torch-cu128`,
`flash-attn-bin` → `flash-attn`, `causal-conv1d-bin` → `causal-conv1d`.

Step 6 then merged `torch-cu126/` and `torch-cu128/` into `torch/` and deleted them.

### High-level derivations / HLD interface (steps 3–4 ✓, type/injection added later)
Each package folder has `high-level.nix` that is a **function** returning a
validated HLD attrset via `mkHLD`.  The function signature declares argument
names that are auto-injected by `pkgs/default.nix`:

- Peer HLD names (e.g. `torch`) — injected from the fixed-point scope
- `hldHelpers` — `{ isHLD, getVersionsFromCudaFiles, getVersionsFromVersionFiles }`
- `mkHLD` — constructor/validator (defined in `pkgs/hld-type.nix`)

`mkHLD` stamps the returned attrset with `_isHighLevelDerivation = true` and
fills in `data = {}` if omitted.  It throws at evaluation time if any required
field is missing or any unknown field is present.

HLD required fields (enforced by `mkHLD`):
- `packageName`    — string; must match the `pkgs/` subdirectory name
- `highLevelDeps`  — `{ name -> hld }` (may be `{}`)
- `getVersions`    — `cudaLabel -> pyVer -> [ versionString ]`; delegates to `hldHelpers`
- `buildBin`       — `{ pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version } -> drv`
- `buildSource`    — same args; throws "not yet implemented" in current packages

HLD optional fields:
- `data`           — arbitrary attrset for package-specific metadata; defaults to `{}`

`getVersions` reads directly from the package's `binary-hashes/` folder so versions are
never hardcoded in the HLD itself.  The scanning/filtering logic is **shared** in
`concretise/hld-helpers.nix`; each HLD picks the appropriate helper with one line.

### `concretise/` folder (step 6 ✓)
`concretise.nix` was promoted to a folder so shared HLD utilities live alongside the
main concretise function without polluting the project root.

```
concretise/
  default.nix       ← the concretise function (import ./concretise resolves here)
  hld-helpers.nix   ← getVersionsFromCudaFiles, getVersionsFromVersionFiles
```

`concretise/default.nix` interface – single attrset argument:
```
{ pkgs, packages, python, cuda, pascal ? false, preferBin ? true }
```
- `python`   – human string `"3.11"` … `"3.14"`
- `cuda`     – human string `"12.6"` or `"12.8"`
- `packages` – list of HLDs; transitive deps collected automatically via `highLevelDeps`
- Uses `lib.toposort` for ordering; cycle detection included
- Returns `{ python, packages, env }`

Version selection: calls `hld.getVersions cudaLabel`, sorts with `lib.versionOlder`, picks latest.

### `concretise/hld-helpers.nix` (step 6 ✓, isHLD added later)
Three helpers for working with HLDs and their binary-hashes layouts.
Injected into every `high-level.nix` as the `hldHelpers` argument by
`pkgs/default.nix`.

- `isHLD x`
  Returns `true` iff `x` carries `_isHighLevelDerivation = true` (i.e. was
  constructed via `mkHLD`).  Used in HLDs to assert peer dependencies.

- `getVersionsFromCudaFiles binaryHashesDir cudaLabel pyVer`
  For torch: reads `binaryHashesDir/{cudaLabel}.nix`, filters by `pyVer`.
  Returns `[]` if the file does not exist.

- `getVersionsFromVersionFiles binaryHashesDir cudaLabel pyVer`
  For flash-attn / causal-conv1d: scans `binaryHashesDir/` for `v*.nix` files,
  returns only versions whose file contains a key for `cudaLabel` (or the
  generic `"cu12"` fallback) and a wheel entry for `pyVer`.

### `pkgs/hld-type.nix` (added this session)
Exports the `mkHLD` constructor/validator function.  Validates required and
optional fields, stamps `_isHighLevelDerivation = true`, fills `data = {}`.
Injected into every `high-level.nix` as the `mkHLD` argument by
`pkgs/default.nix`.

### `flake.nix` `pytorch-packages` output (step 5 ✓)
```
pytorch-packages = { torch; "flash-attn"; "causal-conv1d"; concretise; }
```
No prefix/suffix on names.

### Binary-hashes file layout (step 6 ✓)
```
torch/
  binary-hashes/
    cu126.nix         plain attrset: version → pyVer → os → arch → wheelData
    cu128.nix         same
  cuda-packages-pascal.nix        shared implementation: { pkgs, cudaLabel, cudaPackages }
  cuda-packages-pascal-cu126.nix  5-line wrapper → cuda-packages-pascal.nix
  cuda-packages-pascal-cu128.nix  5-line wrapper → cuda-packages-pascal.nix
  manifests/
    cu126/cudnn/…
    cu126/libcutensor/…
    cu128/cudnn/…
    cu128/libcutensor/…
  generate-hashes.py   unified script; --cuda cu126|cu128 (defaults to all variants)
  override-common.nix  uses binaryHashes.${torchVersion} (plain attrset, not function call)
  high-level.nix

flash-attn/
  binary-hashes/
    v2.8.3.nix        plain attrset: cudaKey → torchCompat → pyVer → os → arch → wheelData
  override.nix        imports (./binary-hashes + "/v${version}.nix").${cudaVersion}
  high-level.nix      uses hldHelpers.getVersionsFromVersionFiles
  generate-hashes.py  uses write_binary_hashes_per_version; DIMENSIONS version-first

causal-conv1d/
  binary-hashes/
    v1.6.0.nix        same structure as flash-attn versioned file
  override.nix        same pattern as flash-attn
  high-level.nix      uses hldHelpers.getVersionsFromVersionFiles
  generate-hashes.py  same changes as flash-attn
```

`nix_writer.py` has `wrap_in_func` flag (default True → current behaviour;
False → plain `{ … }` attrset) and `write_binary_hashes_per_version` helper
that splits organized data by version key and writes one file per version.

### Deduplication decisions taken in step 6
- `torch/cuda-packages-pascal.nix` is the single source of truth for Pascal overrides;
  per-variant files are thin wrappers.  `flake.nix`, `test-retry-wrappers.nix`, and
  `concretise/default.nix` all call the shared file directly.
- `torch/generate-hashes.py` is a single script with `--cuda` flag; the plan's
  per-variant `generate-hashes-cu126.py` / `generate-hashes-cu128.py` were never created.
- `getVersions` logic is centralised in `concretise/hld-helpers.nix`; HLDs contain
  no scanning/filtering code of their own.

---

### Known limitations / follow-up work

### `buildSource` for torch intentionally unsupported
`torch/high-level.nix` throws from `buildSource`.  Building torch from source
is explicitly out of scope per `refactor_plan.md`.  causal-conv1d and
flash-attn both have working `buildSource` implementations with source-hash
existence checks (see above).

### 7c mixing check is best-effort
`checkedWithPackages` only fires when callers use `result.python.withPackages`.
A manually constructed Python environment (e.g. via `basePython.withPackages`)
bypasses the check.  Document this in user-facing docs when buildSource lands.