# Step 6 – Binary-hashes restructure & torch folder merge

## Goal

- Merge `torch/`, `torch-cu126/`, `torch-cu128/` into a single `torch/`
- Give every package a `binary-hashes/` sub-folder
- torch files named `cu{cudaLabel}.nix` (plain attrsets, no function wrapper)
- flash-attn / causal-conv1d files named `v{version}.nix` (plain attrsets, version key removed)
- HLDs use `getVersions` reading from those files instead of hardcoded `binVersions`/`defaultVersion`
- `concretise` picks latest available version via `hld.getVersions cudaLabel`
- `nix_writer.py` updated so regeneration produces the new layout
- generate-hashes.py scripts updated for new paths and new writer API

---

## File structure after this step

```
torch/
  binary-hashes/
    cu126.nix                      plain attrset  version → pyVer → os → arch → wheelData
    cu128.nix                      same
  cuda-packages-pascal-cu126.nix   was torch-cu126/cuda-packages-pascal.nix  (manifest paths updated)
  cuda-packages-pascal-cu128.nix   was torch-cu128/cuda-packages-pascal.nix  (manifest paths updated)
  manifests/
    cu126/cudnn/redistrib_9.10.2.json
    cu126/cudnn/redistrib_9.11.1.json
    cu126/libcutensor/redistrib_2.1.0.json
    cu128/cudnn/redistrib_9.10.2.json
    cu128/cudnn/redistrib_9.11.1.json
    cu128/libcutensor/redistrib_2.1.0.json
  generate-hashes-cu126.py         was torch-cu126/generate-hashes.py
  generate-hashes-cu128.py         was torch-cu128/generate-hashes.py
  override-common.nix              change  binaryHashes torchVersion  →  binaryHashes.${torchVersion}
  high-level.nix                   rewrite (see below)

flash-attn/
  binary-hashes/
    v2.8.3.nix                     plain attrset  cudaKey → torchCompat → pyVer → os → arch → wheelData
  override.nix                     one-line change (see below)
  high-level.nix                   rewrite (see below)
  generate-hashes.py               update OUTPUT_PATH + writer call

causal-conv1d/
  binary-hashes/
    v1.6.0.nix                     same shape as flash-attn versioned file
  override.nix                     one-line change
  high-level.nix                   rewrite
  generate-hashes.py               update OUTPUT_PATH + writer call

generate-binary-hashes/
  nix_writer.py                    add wrap_in_func param + write_binary_hashes_per_version

concretise.nix                     replace binVersions/cudaKeyForBin with getVersions + version picker
test-retry-wrappers.nix            update pascal import path
flake.nix                          update pascal import paths
```

Folders to DELETE after migration:
- `torch-cu126/`
- `torch-cu128/`
- `flash-attn/binary-hashes.nix`   (old monolithic file)
- `causal-conv1d/binary-hashes.nix`

---

## Binary-hashes file transformations

### torch  cu126.nix / cu128.nix

Input (`torch-cu{X}/binary-hashes.nix`):
```
# header ...

version:
builtins.getAttr version {
  "2.10.0" = { ... };
  "2.9.1"  = { ... };
}
```

Output (`torch/binary-hashes/cu{X}.nix`):
```
# header (update "To regenerate" path) ...

{
  "2.10.0" = { ... };
  "2.9.1"  = { ... };
}
```

Transform: remove `version:` line; replace `builtins.getAttr version {` with `{`.
Update header "To regenerate" comment to `torch/generate-hashes-cu{X}.py`.

### flash-attn  v2.8.3.nix

Input (`flash-attn/binary-hashes.nix`):
```
cudaVersion:
builtins.getAttr cudaVersion {
  cu12 = {
    "2.8.3" = {
      "2.4" = { py39 = { ... }; };
      ...
    };
  };
}
```

Output (`flash-attn/binary-hashes/v2.8.3.nix`):
```
{
  cu12 = {
    "2.4" = { py39 = { ... }; };
    ...
  };
}
```

Transform algorithm (Python):
- Skip `cudaVersion:` line
- Replace `builtins.getAttr cudaVersion {` with `{`
- When a line matches exactly `    "2.8.3" = {` (4-space indent): skip it, enter version-block mode
- Inside version-block mode: strip 2 leading spaces from every line
- When a line in version-block mode is exactly `    };` (4-space indent, closes the version key): skip it, exit version-block mode
- Update header: remove `version ->` from Structure comment; update "To regenerate" path

### causal-conv1d  v1.6.0.nix

Same algorithm as flash-attn but three cuda blocks (cu11, cu12, cu13) each
containing a `"1.6.0" = { … };` wrapper. The algorithm handles multiple
version-block entries correctly because it re-enters version-block mode for
each `    "1.6.0" = {` it encounters.

---

## Nix file changes

### torch/override-common.nix

```
# Old:
versionData = binaryHashes torchVersion;

# New:
versionData = binaryHashes.${torchVersion}
  or (throw "torch: no wheel for version ${torchVersion} in provided hashes");
```

### torch/high-level.nix  (full rewrite)

Remove: `binVersions`, `defaultVersion`
Add:
```nix
getVersions = cudaLabel:
  let f = ./binary-hashes + "/${cudaLabel}.nix";
  in if builtins.pathExists f
     then builtins.attrNames (import f)
     else [];
```

Update `buildBin`:
```nix
buildBin = { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version }:
  let
    binaryHashes = import (./binary-hashes + "/${cudaLabel}.nix");
    base = import ./override-common.nix {
      inherit pkgs cudaPackages binaryHashes;
      torchVersion = version;
    };
  in
  base.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ wrappers ];
    preConfigure = ''export PATH="${wrappers}/bin:$PATH"
${old.preConfigure or ""}'';
    preBuild = ''export PATH="${wrappers}/bin:$PATH"
${old.preBuild or ""}'';
  });
```

### flash-attn/override.nix

```
# Old:
versionData = (import ./binary-hashes.nix cudaVersion).${flashAttnVersion};

# New:
versionData = (import (./binary-hashes + "/v${flashAttnVersion}.nix")).${cudaVersion};
```

### flash-attn/high-level.nix  (full rewrite)

Remove: `binVersions`, `defaultVersion`
Add:
```nix
getVersions = cudaLabel:
  let
    dir   = ./binary-hashes;
    files = builtins.readDir dir;
    vNames = builtins.filter
      (n: builtins.match "v[0-9]+\\.[0-9]+\\.[0-9]+\\.nix" n != null)
      (builtins.attrNames files);
    versions = map
      (n: builtins.substring 1 (builtins.stringLength n - 5) n)
      vNames;
  in
  builtins.filter (v:
    let h = import (dir + "/v${v}.nix");
    in builtins.hasAttr cudaLabel h || builtins.hasAttr "cu12" h
  ) versions;
```

`buildBin` unchanged in logic; remove the `cudaVersion = "cu12"` hardcode comment
(the override.nix still receives `"cu12"` since flash-attn wheels use that label).

### causal-conv1d/override.nix

```
# Old:
versionData = (import ./binary-hashes.nix cudaVersion).${causalConv1dVersion};

# New:
versionData = (import (./binary-hashes + "/v${causalConv1dVersion}.nix")).${cudaVersion};
```

### causal-conv1d/high-level.nix  (full rewrite)

Identical pattern to flash-attn/high-level.nix (same `getVersions` shape).

### concretise.nix

Replace:
```nix
cudaKeyForBin = hld: ...   # old binVersions lookup
```

With:
```nix
# In buildOne:
availableVersions = hld.getVersions cudaLabel;
sortedVersions    = lib.sort lib.versionOlder availableVersions;
version           = if sortedVersions != [] then lib.last sortedVersions else null;
useBin            = preferBin && version != null;
```

Remove the separate `cudaKeyForBin` helper entirely.
Pass `version` (or a placeholder) into `buildBin`/`buildSource` args.

### test-retry-wrappers.nix

```
# Old:
import ./torch-cu126/cuda-packages-pascal.nix

# New:
import ./torch/cuda-packages-pascal-cu126.nix
```

### flake.nix

```
# Old:
import ./torch-cu126/cuda-packages-pascal.nix
import ./torch-cu128/cuda-packages-pascal.nix

# New:
import ./torch/cuda-packages-pascal-cu126.nix
import ./torch/cuda-packages-pascal-cu128.nix
```

Also remove the `torch-cu126/override.nix` and `torch-cu128/override.nix` references
(they go away; the HLD's buildBin calls override-common.nix directly).

### torch/cuda-packages-pascal-cu126.nix  (was torch-cu126/cuda-packages-pascal.nix)

Update manifest paths:
```
# Old:
./manifests/cudnn/redistrib_9.10.2.json
./manifests/libcutensor/redistrib_2.1.0.json

# New:
./manifests/cu126/cudnn/redistrib_9.10.2.json
./manifests/cu126/libcutensor/redistrib_2.1.0.json
```

### torch/cuda-packages-pascal-cu128.nix  (was torch-cu128/cuda-packages-pascal.nix)

Same but with `cu128` in the paths.

---

## nix_writer.py changes

### Existing `write_binary_hashes_nix`

Add parameter `wrap_in_func: bool = True`.
When `False`: emit `{\n` instead of `{top_key_var}:\nbuiltins.getAttr {top_key_var} {\n`,
and close with `}\n` (already the case).
No other changes needed.

### New function `write_binary_hashes_per_version`

```python
def write_binary_hashes_per_version(
    output_dir: str,
    organized: dict,          # outer key is version string
    schema: list[DimSpec],    # schema WITHOUT the leading version DimSpec
    header_template: str,     # may contain {version} placeholder
    version_spec: DimSpec,    # the DimSpec that was the version level
) -> None:
    """
    Split organized data by its outermost key (version) and write one
    plain-attrset binary-hashes file per version into output_dir.

    File names: v{version}.nix
    Each file is a plain attrset (wrap_in_func=False).
    """
    os.makedirs(output_dir, exist_ok=True)
    for version, version_data in organized.items():
        path = os.path.join(output_dir, f"v{version}.nix")
        header = header_template.format(version=version)
        write_binary_hashes_nix(
            path,
            version_data,
            schema,
            header,
            wrap_in_func=False,
        )
        print(f"  wrote {path}")
```

---

## generate-hashes.py script changes

### torch/generate-hashes-cu126.py  (was torch-cu126/generate-hashes.py)

- Update docstring path references
- `OUTPUT_PATH` → `torch/binary-hashes/cu126.nix`
- `HEADER` "To regenerate" → `nix-shell torch/generate-hashes-cu126.py`
- `write_binary_hashes_nix(..., wrap_in_func=False)` (no function wrapper)
- `top_key_var` arg removed / ignored when `wrap_in_func=False`

Same changes for `generate-hashes-cu128.py`.

### flash-attn/generate-hashes.py

- `OUTPUT_PATH` replaced by `OUTPUT_DIR = flash-attn/binary-hashes/`
- `HEADER` updated (remove `version ->` from Structure, update "To regenerate")
- Remove `DimSpec("version", …)` from `SCHEMA`
- Remove `"version"` from `DIMENSIONS`
- Call `write_binary_hashes_per_version(OUTPUT_DIR, organized, SCHEMA, HEADER, version_spec)`
  where `version_spec` is the old version `DimSpec`
- The `organized` dict is still keyed `cudaVersion → version → …`; need to re-pivot to
  `version → cudaVersion → …` before calling per-version writer, OR restructure the
  `organize_wheels` call with dimensions reordered to `["version", "cudaVersion", ...]`.
  Easiest: reorder DIMENSIONS to put `version` first.

### causal-conv1d/generate-hashes.py

Same changes as flash-attn.

---

## Execution order

1. Run Python transformation scripts to produce the new binary-hashes files
2. Copy/move supporting files (pascal nix, manifests, generate scripts)
3. Edit Nix files (override-common, override.nix ×2, high-level.nix ×3, concretise, test, flake)
4. Delete old folders/files
5. Update nix_writer.py
6. Update generate-hashes.py scripts
7. `git add .` then `nix eval` to verify