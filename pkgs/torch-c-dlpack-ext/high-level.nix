# High-level derivation for torch-c-dlpack-ext.
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# torch-c-dlpack-ext is a small C extension by the TVM FFI team (developed in
# the apache/tvm-ffi repository) that registers a fast C-level DLPack
# converter for torch tensors.  It is a leaf dependency of quack-kernels.
# Upstream publishes one manylinux wheel per CPython version that works
# across torch versions (torch is only a Python-level runtime dependency),
# so the store-path stamp omits the -torch{series} dimension.
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.

{ torch, hldHelpers, packageName }:

assert hldHelpers.isHLD torch;

{
  # ── Origin type ────────────────────────────────────────────────────────────
  originType = "pypi";

  # ── Identity fields ────────────────────────────────────────────────────────
  srcOwner = "apache";
  srcRepo  = "tvm-ffi";

  # ── Torch agnosticism ──────────────────────────────────────────────────────
  # Upstream ships generic per-CPython wheels (no per-torch builds): the
  # extension does not depend on the torch C++ ABI.
  torchAgnostic = true;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = { inherit torch; };

  # ── Version availability ───────────────────────────────────────────────────
  # Per-version files v{version}.nix with structure pyVer -> os -> arch.
  getVersions = hldHelpers.getVersionsFromAnyVersionFiles ./binary-hashes;

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  buildBin =
    { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    import ./overlay-bin.nix {
      overlayInfo = mkOverlayInfo { inherit pkgs cudaPackages version resolvedDeps; };
    };

  # ── Build from source ──────────────────────────────────────────────────────
  buildSource = _:
    throw "torch-c-dlpack-ext: source build not implemented — PyPI wheels cover all supported Pythons.";
}
