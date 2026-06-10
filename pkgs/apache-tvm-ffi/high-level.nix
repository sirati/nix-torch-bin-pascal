# High-level derivation for apache-tvm-ffi.
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# apache-tvm-ffi is the TVM FFI runtime library — a pure C++/Python CPU
# library with no torch or CUDA linkage.  It is a leaf dependency of
# quack-kernels.  PyPI ships manylinux wheels for every supported Python
# (cp312-abi3 covers 3.12+; cp310/cp311 have dedicated wheels), which the
# hash generator expands to explicit per-pyVer entries.
#
# A source build (cmake + C++17, no CUDA) would be possible from the
# apache/tvm-ffi repository but is not implemented while upstream wheels
# cover all supported Pythons.
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.

{ hldHelpers, packageName }:

{
  # ── Origin type ────────────────────────────────────────────────────────────
  originType = "pypi";

  # ── Identity fields ────────────────────────────────────────────────────────
  srcOwner = "apache";
  srcRepo  = "tvm-ffi";

  # ── CUDA/torch agnosticism ─────────────────────────────────────────────────
  # Pure CPU library: identical wheel for every CUDA and torch version.  The
  # store-path stamp omits the cuda/torch/pascal dims (like triton).
  cudaAgnostic = true;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = { };

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
    throw "apache-tvm-ffi: source build (cmake/C++17) not implemented — PyPI wheels cover all supported Pythons.";
}
