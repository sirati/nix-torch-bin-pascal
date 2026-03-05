# High-level derivation for PyTorch.
#
# getVersions is provided by the shared helper injected from pkgs/default.nix.
# torch uses the per-CUDA-label layout: binary-hashes/{cudaLabel}.nix
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# hldHelpers and mkHLD are injected automatically by pkgs/default.nix.
# No manual import of hld-helpers.nix is needed here.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     mlPackages = with pp; [ torch ];
#     python   = "3.13";
#     cuda     = "12.8";
#   };

{ hldHelpers, packageName }:

let
  # ── Package identity ───────────────────────────────────────────────────────
  # pname and nixpkgsAttr both equal packageName ("torch") and are therefore
  # omitted from the returned attrset; hld-type.nix validate fills them in
  # automatically.
  # Torch binaries are distributed via download.pytorch.org, not GitHub
  # releases, so origin-type = "torch-website".  mkChangelog and mkOverrideInfo
  # are required for "torch-website" and must be provided explicitly here.
  # buildBin does not currently use them; they are available for future
  # buildSource use.
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
  "origin-type" = "torch-website";

  # ── Identity fields ────────────────────────────────────────────────────────
  # pname and nixpkgsAttr are omitted (both equal packageName "torch");
  # hld-type.nix validate fills them in automatically.
  inherit srcOwner srcRepo mkChangelog mkOverrideInfo;

  # ── Binary availability ────────────────────────────────────────────────────
  # torch uses per-CUDA-label files: binary-hashes/{cudaLabel}.nix
  # Each file is a plain attrset keyed by version string.
  getVersions = hldHelpers.getVersionsFromCudaFiles ./binary-hashes;

  # ── High-level dependencies ────────────────────────────────────────────────
  # Torch has no high-level deps; other packages depend on it.
  highLevelDeps = {};

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  #
  # Received from concretise:
  #   { pkgs, cudaPackages, cudaLabel, resolvedDeps, version }
  #
  # torch does not use resolvedDeps (it has no deps).
  buildBin = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      binaryHashes = import (./binary-hashes + "/${cudaLabel}.nix");
      base = import ./override-common.nix {
        inherit pkgs cudaPackages binaryHashes;
        torchVersion = version;
      };
    in
    # (import ../../nix-retry-wrapper/inject-wrappers.nix wrappers) base  # re-enable wrappers
    base;

  # ── Build from source ──────────────────────────────────────────────────────
  buildSource = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    throw "torch/high-level.nix: buildSource is not yet implemented";
}
