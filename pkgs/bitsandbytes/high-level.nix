# High-level derivation for bitsandbytes.
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# bitsandbytes depends on torch at the high level.  When concretised, the
# resolved concrete torch derivation is available via resolvedDeps."torch".
#
# bitsandbytes is a SOURCE-ONLY package.  It does not ship CUDA-specific
# pre-built wheels — its PyPI wheels are py3-none-* with runtime CUDA
# detection, which is unsuitable for Nix.  The CUDA kernels must be compiled
# from source via CMake.
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     mlPackages = with pp; [ bitsandbytes ];  # torch is implied automatically
#     python   = "3.13";
#     cuda     = "12.8";
#     allowBuildingFromSource = true;  # required — no binary wheels available
#   };

{ torch, hldHelpers, packageName }:

assert hldHelpers.isHLD torch;

{
  # ── Origin type ────────────────────────────────────────────────────────────
  originType = "github-releases";

  # ── Identity fields ────────────────────────────────────────────────────────
  srcOwner = "bitsandbytes-foundation";
  srcRepo  = "bitsandbytes";

  # bitsandbytes uses bare version tags (e.g. "0.45.5") instead of v-prefixed
  # tags, so we override the default mkChangelog which would prepend "v".
  mkChangelog = v:
    "https://github.com/bitsandbytes-foundation/bitsandbytes/releases/tag/${v}";

  # ── Version availability ───────────────────────────────────────────────────
  # bitsandbytes has no pre-built CUDA wheels; version resolution is driven
  # entirely by source-hashes/ files.  getVersionsFromSourceFiles ignores
  # cudaLabel and pyVer (source builds work for any combination).
  getVersions = hldHelpers.getVersionsFromSourceFiles ./source-hashes;

  # ── Torch agnosticism ───────────────────────────────────────────────────────
  # bitsandbytes compiles CUDA kernels via CMake against cublas/cusparse/cudart
  # directly — it does NOT link against torch at the C++/ABI level.  Torch is
  # only a Python-level runtime dependency.  This means the compiled .so is
  # reusable across torch versions, so we skip the -torch{series} store-path
  # dimension to avoid unnecessary rebuilds.
  torchAgnostic = true;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = { inherit torch; };

  # ── ABI compatibility check ────────────────────────────────────────────────
  # No binary wheels → canBuildBin always returns false so concretise always
  # falls through to buildSource.
  canBuildBin = _: false;

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  # Not available — bitsandbytes does not distribute CUDA-compiled wheels.
  buildBin = { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    throw "bitsandbytes: no pre-built CUDA wheels available; use allowBuildingFromSource = true";

  # ── Build from source ──────────────────────────────────────────────────────
  buildSource = { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    import ./overlay-source.nix {
      overlayInfo = mkOverlayInfo { inherit pkgs cudaPackages version resolvedDeps; };
    };
}
