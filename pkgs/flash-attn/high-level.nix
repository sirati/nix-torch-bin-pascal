# High-level derivation for flash-attention.
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# flash-attn depends on torch at the high level.  When concretised, the
# resolved concrete torch derivation is available via resolvedDeps."torch".
#
# hldHelpers and mkHLD are injected automatically by pkgs/default.nix.
# No manual import of hld-helpers.nix is needed here.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     mlPackages = with pp; [ flash-attn ];  # torch is implied automatically
#     python   = "3.13";
#     cuda     = "12.8";
#   };

{ torch, hldHelpers }:

# Fail early if the caller passed something other than a high-level derivation.
assert hldHelpers.isHLD torch;

let
  # ── Package identity ───────────────────────────────────────────────────────
  # Centralised here so override.nix and override-source.nix never hardcode
  # package-specific strings.

  # Python / PyPI package name (used as pname in derivations).
  # NOTE: differs from the HLD packageName "flash-attn".
  pname = "flash-attention";

  # GitHub source coordinates.  Provide defaults; override-source.nix reads
  # srcInfo.owner / srcInfo.repo first and falls back to these.
  srcOwner = "Dao-AILab";
  srcRepo  = "flash-attention";

  # Attribute name in pkgs.python3Packages for the upstream nixpkgs derivation.
  # NOTE: differs from pname — nixpkgs uses "flash-attn".
  nixpkgsAttr = "flash-attn";

  # Changelog URL template (receives the resolved version string).
  mkChangelog = v: "https://github.com/Dao-AILab/flash-attention/releases/tag/v${v}";

  # ── overrideInfo constructor ───────────────────────────────────────────────
  # Builds the common context attrset consumed by override.nix and
  # override-source.nix.  Called once per buildBin / buildSource invocation
  # with the concretise-supplied pkgs, cudaPackages, resolved version, and deps.
  mkOverrideInfo = { pkgs, cudaPackages, version, resolvedDeps }: {
    inherit pkgs cudaPackages pname srcOwner srcRepo version;
    basePkg   = pkgs.python3Packages.${nixpkgsAttr} or null;
    changelog = mkChangelog version;
    torch     = resolvedDeps.torch or null;
  };

in
{
  # ── Binary availability ────────────────────────────────────────────────────
  # flash-attn uses per-version files: binary-hashes/v{version}.nix
  # Each file is a plain attrset keyed by cudaVersion label.
  # The generic "cu12" key covers all CUDA 12.x variants.
  getVersions = hldHelpers.getVersionsFromVersionFiles ./binary-hashes;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = { inherit torch; };

  # ── ABI compatibility check ────────────────────────────────────────────────
  #
  # Returns false when the pre-built wheel for `version` is unlikely to be
  # ABI-compatible with the resolved torch.  We determine this by comparing
  # the resolved torch major.minor against the highest torch-compat key present
  # in the binary-hashes file (across all Python versions).  When torch is
  # strictly newer than the highest compat key we have wheels for, we fall back
  # to a source build.
  #
  # This ensures torch 2.10+ always triggers a source build, since the newest
  # flash-attn pre-built wheels only cover up to torch 2.9 compat.
  canBuildBin = hldHelpers.canBuildBinFromVersionFiles ./binary-hashes;

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  #
  # Received from concretise:
  #   { pkgs, cudaPackages, cudaLabel, resolvedDeps, version }
  #
  # flash-attn wheels are generic across CUDA 12.x, so we always use "cu12"
  # as the cudaVersion passed to override.nix regardless of cudaLabel.
  buildBin = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    import ./override.nix {
      overrideInfo = mkOverrideInfo { inherit pkgs cudaPackages version resolvedDeps; };
      cudaVersion  = "cu12";
      # cxx11abi defaults to "TRUE" in override.nix, matching standard pip wheels
    };

  # ── Build from source ──────────────────────────────────────────────────────
  #
  # Called by concretise when canBuildBin returns false (torch is newer than
  # the highest compat key in the binary-hashes file) and
  # allowBuildingFromSource = true.
  buildSource = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      v = hldHelpers.requireSourceHash
            "flash-attn" "pkgs/flash-attn" ./source-hashes
            { inherit version cudaLabel; };
    in
    # (import ../../nix-retry-wrapper/inject-wrappers.nix wrappers)  # re-enable wrappers
    import ./override-source.nix {
      overrideInfo = mkOverrideInfo { inherit pkgs cudaPackages resolvedDeps; version = v; };
    };
}
