# High-level derivation for mamba-ssm.
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# mamba-ssm depends on torch and causal-conv1d at the high level.  When
# concretised, the resolved concrete derivations are available via
# resolvedDeps."torch" and resolvedDeps."causal-conv1d".
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     packages = with pp; [ mamba-ssm ];  # torch and causal-conv1d implied
#     python   = "3.13";
#     cuda     = "12.8";
#   };

{ torch, causal-conv1d, hldHelpers, packageName }:

# Fail early if the caller passed something other than high-level derivations.
assert hldHelpers.isHLD torch;
assert hldHelpers.isHLD causal-conv1d;

let
  # ── Package identity ───────────────────────────────────────────────────────
  # pname and nixpkgsAttr both equal packageName ("mamba-ssm") and are
  # therefore omitted from the returned attrset; hld-type.nix validate fills
  # them in with packageName automatically.

  # GitHub source coordinates.  Provide defaults; override-source.nix reads
  # srcInfo.owner / srcInfo.repo first and falls back to these.
  srcOwner = "state-spaces";
  srcRepo  = "mamba";

  # Changelog URL template (receives the resolved version string).
  mkChangelog = hldHelpers."github-release-tag" srcOwner srcRepo;

  # ── overrideInfo constructor ───────────────────────────────────────────────
  # Standard implementation from hldHelpers.  Builds the common context attrset
  # consumed by override.nix and override-source.nix.  Called once per
  # buildBin / buildSource invocation with the concretise-supplied pkgs,
  # cudaPackages, resolved version, and deps.
  mkOverrideInfo = hldHelpers.mkOverrideInfo {
    pname       = packageName;
    nixpkgsAttr = packageName;
    inherit srcOwner srcRepo mkChangelog;
  };

in
{
  # ── Origin type ────────────────────────────────────────────────────────────
  "origin-type" = "github-releases";

  # ── Identity fields ────────────────────────────────────────────────────────
  # pname and nixpkgsAttr are omitted here (both equal packageName);
  # hld-type.nix validate fills them in automatically.
  inherit srcOwner srcRepo mkChangelog mkOverrideInfo;

  # ── Binary availability ────────────────────────────────────────────────────
  # mamba-ssm uses per-version files: binary-hashes/v{version}.nix
  # Each file is a plain attrset keyed by cudaVersion label.
  # The generic "cu12" key covers all CUDA 12.x variants.
  getVersions = hldHelpers.getVersionsFromVersionFiles ./binary-hashes;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = {
    inherit torch causal-conv1d;
  };

  # ── ABI compatibility check ────────────────────────────────────────────────
  #
  # Returns false when the pre-built wheel for `version` is unlikely to be
  # ABI-compatible with the resolved torch.  We determine this by comparing
  # the resolved torch major.minor against the highest torch-compat key present
  # in the binary-hashes file (across all Python versions).  When torch is
  # strictly newer than the highest compat key we have wheels for, we fall back
  # to a source build.
  canBuildBin = hldHelpers.canBuildBinFromVersionFiles ./binary-hashes;

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  #
  # Received from concretise:
  #   { pkgs, cudaPackages, cudaLabel, resolvedDeps, version }
  #
  # mamba-ssm wheels are generic across CUDA 12.x, so we always use "cu12"
  # as the cudaVersion passed to override.nix regardless of cudaLabel.
  buildBin = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    import ./override.nix {
      overrideInfo  = mkOverrideInfo { inherit pkgs cudaPackages version resolvedDeps; };
      causal-conv1d = resolvedDeps."causal-conv1d";
      cudaVersion   = "cu12";
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
            "mamba-ssm" "pkgs/mamba-ssm" ./source-hashes
            { inherit version cudaLabel; };
    in
    # (import ../../nix-retry-wrapper/inject-wrappers.nix wrappers)  # re-enable wrappers
    import ./override-source.nix {
      overrideInfo  = mkOverrideInfo { inherit pkgs cudaPackages resolvedDeps; version = v; };
      causal-conv1d = resolvedDeps."causal-conv1d";
    };
}
