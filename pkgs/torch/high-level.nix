# High-level derivation for PyTorch.
#
# torch depends on triton at the high level.  When concretised, the
# resolved concrete triton derivation is available via resolvedDeps."triton".
#
# getVersions is provided by the shared helper injected from pkgs/default.nix.
# torch uses the per-CUDA-label layout: binary-hashes/{cudaLabel}.nix
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
#     mlPackages = with pp; [ torch ];  # triton is pulled in automatically as a dep
#     python   = "3.13";
#     cuda     = "12.8";
#   };

{ triton, hldHelpers, packageName }:

# Fail early if the caller passed something other than a high-level derivation.
assert hldHelpers.isHLD triton;

let
  # ── Package identity ───────────────────────────────────────────────────────
  # pname and nixpkgsAttr both equal packageName ("torch") and are therefore
  # omitted from the returned attrset; hld-type.nix validate fills them in
  # automatically.
  # Torch binaries are distributed via download.pytorch.org, not GitHub
  # releases, so originType = "torch-website".  mkChangelog and mkOverlayInfo
  # are required for "torch-website" and must be provided explicitly here.
  # buildBin does not currently use them; they are available for future
  # buildSource use.
  srcOwner    = "pytorch";
  srcRepo     = "pytorch";
  mkChangelog = hldHelpers."github-release-tag" srcOwner srcRepo;
  mkOverlayInfo = hldHelpers.mkOverlayInfo {
    pname       = packageName;
    nixpkgsAttr = packageName;
    inherit srcOwner srcRepo mkChangelog;
  };

in
{
  # ── Origin type ────────────────────────────────────────────────────────────
  originType = "torch-website";

  # ── Identity fields ────────────────────────────────────────────────────────
  # pname and nixpkgsAttr are omitted (both equal packageName "torch");
  # hld-type.nix validate fills them in automatically.
  inherit srcOwner srcRepo mkChangelog mkOverlayInfo;

  # ── Binary availability ────────────────────────────────────────────────────
  # torch uses per-CUDA-label files: binary-hashes/{cudaLabel}.nix
  # Each file is a plain attrset keyed by version string.
  getVersions = hldHelpers.getVersionsFromCudaFiles ./binary-hashes;

  # ── High-level dependencies ────────────────────────────────────────────────
  # Torch depends on triton at the high level.  When concretised, the
  # resolved concrete triton derivation is available via resolvedDeps."triton".
  highLevelDeps = { inherit triton; };

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  #
  # Received from concretise:
  #   { pkgs, cudaPackages, cudaLabel, resolvedDeps, version }
  #
  # torch depends on triton; the resolved triton derivation is in resolvedDeps.
  buildBin = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      binaryHashes = import (./binary-hashes + "/${cudaLabel}.nix");
      base = import ./overlay-common.nix {
        inherit pkgs cudaPackages binaryHashes;
        torchVersion = version;
        triton = resolvedDeps.triton;
      };
    in
    # (import ../../nix-retry-wrapper/inject-wrappers.nix wrappers) base  # re-enable wrappers
    base;

  # ── Build from source ──────────────────────────────────────────────────────
  buildSource = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    throw "torch/high-level.nix: buildSource is not yet implemented";
}
