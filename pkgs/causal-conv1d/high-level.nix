# High-level derivation for causal-conv1d.
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# causal-conv1d depends on torch at the high level.  When concretised, the
# resolved concrete torch derivation is available via resolvedDeps."torch".
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.
# No manual import of hld-helpers.nix is needed here.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     mlPackages = with pp; [ causal-conv1d ];  # torch is implied automatically
#     python   = "3.13";
#     cuda     = "12.8";
#   };

{ torch, hldHelpers, packageName }:

# Fail early if the caller passed something other than a high-level derivation.
assert hldHelpers.isHLD torch;

let
  # ── Package identity ───────────────────────────────────────────────────────
  # pname and nixpkgsAttr both equal packageName ("causal-conv1d") and are
  # therefore omitted from the returned attrset; hld-type.nix validate fills
  # them in with packageName automatically.

  # GitHub source coordinates.  Provide defaults; override-source.nix reads
  # srcInfo.owner / srcInfo.repo first and falls back to these.
  srcOwner = "Dao-AILab";
  srcRepo  = "causal-conv1d";

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
  # causal-conv1d uses per-version files: binary-hashes/v{version}.nix
  # Each file is a plain attrset keyed by cudaVersion label.
  # The generic "cu12" key covers all CUDA 12.x variants.
  getVersions = hldHelpers.getVersionsFromVersionFiles ./binary-hashes;

  # ── High-level dependencies ────────────────────────────────────────────────
  highLevelDeps = { inherit torch; };

  # ── ABI compatibility check ────────────────────────────────────────────────
  #
  # Returns false when the pre-built wheel for `version` cannot be used with the
  # resolved torch.  causal-conv1d wheels are compiled against a specific torch
  # major.minor ABI; wheels built against torch <= 2.8 are broken at runtime
  # against torch >= 2.9 (missing symbol c10::cuda::c10_cuda_check_implementation).
  #
  # When this returns false, concretise falls back to buildSource (if
  # allowBuildingFromSource = true) or throws with a clear message.
  canBuildBin = hldHelpers.canBuildBinFromVersionFiles ./binary-hashes;

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  #
  # Received from concretise:
  #   { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version }
  #
  # causal-conv1d wheels are generic across CUDA 12.x, so we always use "cu12"
  # as the cudaVersion passed to override.nix regardless of cudaLabel.
  buildBin = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    import ./override.nix {
      overrideInfo = mkOverrideInfo { inherit pkgs cudaPackages version resolvedDeps; };
      cudaVersion  = "cu12";
      # cxx11abi defaults to "TRUE" in override.nix, matching standard pip wheels
    };

  # ── Build from source ──────────────────────────────────────────────────────
  #
  # Called by concretise when canBuildBin returns false (pre-built wheel is
  # ABI-incompatible with the resolved torch) and allowBuildingFromSource = true.
  # Also called when no binary version exists at all (version may be non-null
  # when the binary is ABI-incompatible, or null if no hash file exists).
  buildSource = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      v = hldHelpers.requireSourceHash
            "causal-conv1d" "pkgs/causal-conv1d" ./source-hashes
            { inherit version cudaLabel; };
    in
    # (import ../../nix-retry-wrapper/inject-wrappers.nix wrappers)  # re-enable wrappers
    import ./override-source.nix {
      overrideInfo = mkOverrideInfo { inherit pkgs cudaPackages resolvedDeps; version = v; };
    };
}
