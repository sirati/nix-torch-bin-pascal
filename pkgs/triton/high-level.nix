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
  # releases, so originType = "torch-website".  mkChangelog and mkOverlayInfo
  # are required for "torch-website" and must be provided explicitly here.
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

  # ── CUDA-agnostic flag ─────────────────────────────────────────────────────
  # Triton wheels are identical across all CUDA versions and torch versions.
  # This suppresses the cuda/torch/pascal dims from the store-path stamp so that
  # e.g. python3.13.11-torch-2.10.0-torch210-cu128-bin and
  # python3.13.11-torch-2.9.3-torch209-cu126-bin both depend on the same
  # python3.13.11-triton-3.6.0-bin derivation name.
  cudaAgnostic = true;

  # ── Identity fields ────────────────────────────────────────────────────────
  # pname and nixpkgsAttr are omitted (both equal packageName "triton");
  # hld-type.nix validate fills them in automatically.
  inherit srcOwner srcRepo mkChangelog mkOverlayInfo;

  # ── Binary availability ────────────────────────────────────────────────────
  # triton wheels are CUDA-agnostic; per-version files v{version}.nix cover all
  # CUDA versions.  getVersionsFromAnyVersionFiles scans for v{semver}.nix and
  # filters by pyVer, ignoring the cudaLabel entirely.
  getVersions = hldHelpers.getVersionsFromAnyVersionFiles ./binary-hashes;

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
      perVersionPath = ./binary-hashes + "/v${version}.nix";
      legacyAnyPath  = ./binary-hashes + "/any.nix";

      # Prefer the per-version file (new layout); fall back to the legacy
      # any.nix during the transition before gen-hashes has been re-run.
      versionHashes =
        if builtins.pathExists perVersionPath then import perVersionPath
        else if builtins.pathExists legacyAnyPath then
          (import legacyAnyPath).${version}
          or (throw "triton buildBin: version ${version} not found in binary-hashes/any.nix")
        else throw "triton buildBin: no binary hashes found for version ${version}";

      base = import ./overlay.nix {
        inherit pkgs cudaPackages versionHashes;
        tritonVersion = version;
      };
    in
    # (import ../../nix-retry-wrapper/inject-wrappers.nix wrappers) base  # re-enable wrappers
    base;

  # ── Build from source ──────────────────────────────────────────────────────
  buildSource = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    throw "triton/high-level.nix: buildSource is not yet implemented";
}
