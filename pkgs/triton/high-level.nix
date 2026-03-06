# High-level derivation for Triton.
#
# Triton wheels are distributed via download.pytorch.org (same as torch),
# and are CUDA-agnostic (same wheel for all CUDA versions — JIT-compiles at runtime).
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.
# No manual import of hld-helpers.nix is needed here.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     mlPackages = with pp; [ torch ];  # triton is pulled in automatically via torch deps
#     python   = "3.13";
#     cuda     = "12.8";
#   };

{ hldHelpers, packageName }:

let
  # ── Package identity ───────────────────────────────────────────────────────
  # pname and nixpkgsAttr both equal packageName ("triton") and are therefore
  # omitted from the returned attrset; hld-type.nix validate fills them in
  # automatically.
  # Triton binaries are distributed via download.pytorch.org, not GitHub
  # releases, so originType = "torch-website".  mkChangelog and mkOverrideInfo
  # are required for "torch-website" and must be provided explicitly here.
  srcOwner    = "pytorch";
  srcRepo     = "pytorch";
  mkChangelog = hldHelpers."github-release-tag" srcOwner srcRepo;
  mkOverrideInfo = hldHelpers.mkOverrideInfo {
    pname       = packageName;
    nixpkgsAttr = packageName;
    inherit srcOwner srcRepo mkChangelog;
  };

in
{
  # ── Origin type ────────────────────────────────────────────────────────────
  originType = "torch-website";

  # ── Identity fields ────────────────────────────────────────────────────────
  # pname and nixpkgsAttr are omitted (both equal packageName "triton");
  # hld-type.nix validate fills them in automatically.
  inherit srcOwner srcRepo mkChangelog mkOverrideInfo;

  # ── Binary availability ────────────────────────────────────────────────────
  # triton wheels are CUDA-agnostic; a single binary-hashes/any.nix covers all
  # CUDA versions.  getVersionsFromCudaFiles falls back to any.nix automatically
  # when no {cudaLabel}.nix is present in the directory.
  getVersions = hldHelpers.getVersionsFromCudaFiles ./binary-hashes;

  # ── High-level dependencies ────────────────────────────────────────────────
  # Triton has no high-level deps; it is a leaf dependency.
  highLevelDeps = {};

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  #
  # Received from concretise:
  #   { pkgs, cudaPackages, cudaLabel, resolvedDeps, version }
  #
  # triton does not use resolvedDeps (it has no deps).
  buildBin = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      # Triton wheels are CUDA-agnostic; any.nix covers all CUDA versions.
      binaryHashes = import ./binary-hashes/any.nix;
      base = import ./override.nix {
        inherit pkgs cudaPackages binaryHashes;
        tritonVersion = version;
      };
    in
    # (import ../../nix-retry-wrapper/inject-wrappers.nix wrappers) base  # re-enable wrappers
    base;

  # ── Build from source ──────────────────────────────────────────────────────
  buildSource = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    throw "triton/high-level.nix: buildSource is not yet implemented";
}
