# High-level derivation for torchvision.
#
# torchvision wheels are distributed via download.pytorch.org per CUDA variant
# and per Python version (cp312-cp312, etc.) — exactly like torch.  This HLD
# therefore mirrors pkgs/torch/high-level.nix for the wheel layout
# (per-CUDA-label files, per-Python keying via getVersionsFromCudaFiles), and
# mirrors pkgs/torchao/high-level.nix for the torch dependency wiring
# (highLevelDeps = { inherit torch; }; torch passed through resolvedDeps).
#
# Unlike torchao, torchvision links against torch's C++ ABI, so it must be
# paired with the *matching* torch version.  torchAgnostic is therefore left at
# its default (false): the store-path stamp keeps the -torch{series} dimension,
# and canBuildBin enforces an exact torch-series match using the documented
# PyTorch compatibility mapping (torchvision minor = torch minor + 15, e.g.
# torchvision 0.25.x ↔ torch 2.10.x, torchvision 0.27.x ↔ torch 2.12.x).
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.

{ torch, hldHelpers, packageName }:

assert hldHelpers.isHLD torch;

let
  srcOwner    = "pytorch";
  srcRepo     = "vision";
  mkChangelog = hldHelpers."github-release-tag" srcOwner srcRepo;
  mkOverlayInfo = hldHelpers.mkOverlayInfo {
    pname       = packageName;
    nixpkgsAttr = packageName;
    inherit srcOwner srcRepo mkChangelog;
  };

  # ── torchvision ↔ torch version mapping ────────────────────────────────────
  # Documented PyTorch compatibility: torchvision's minor version tracks torch's
  # minor offset by +15 within the 0.x line (torch 2.7→0.22, 2.10→0.25,
  # 2.12→0.27).  The required torch major.minor for a torchvision version is
  # therefore "2.<torchvisionMinor - 15>".
  requiredTorchSeries = torchvisionVersion:
    let
      parts = builtins.splitVersion torchvisionVersion;  # e.g. [ "0" "27" "0" ]
      tvMinor = builtins.elemAt parts 1;                  # e.g. "27"
      torchMinor = (builtins.fromJSON tvMinor) - 15;      # e.g. 12
    in
    "2.${toString torchMinor}";

  # major.minor of a full version string, e.g. "2.12.0" -> "2.12".
  majorMinor = v:
    let parts = builtins.splitVersion v;
    in "${builtins.elemAt parts 0}.${builtins.elemAt parts 1}";

in
{
  originType = "torch-website";

  inherit srcOwner srcRepo mkChangelog mkOverlayInfo;

  # Per-CUDA-label hash files with per-Python keying (version -> pyVer -> os ->
  # arch).  getVersionsFromCudaFiles only returns a version when a wheel exists
  # for the requested Python interpreter.
  getVersions = hldHelpers.getVersionsFromCudaFiles ./binary-hashes;

  highLevelDeps = { inherit torch; };

  # A pre-built wheel is usable only when BOTH hold:
  #   1. a hash entry exists for the selected version under this cuda label, and
  #   2. the resolved torch's major.minor matches the series that this
  #      torchvision version was built against (exact ABI match required).
  canBuildBin = { cudaLabel, version, resolvedDeps, ... }:
    let
      f = ./binary-hashes + "/${cudaLabel}.nix";
      fileHasVersion = builtins.pathExists f && builtins.hasAttr version (import f);
      torchVersion = resolvedDeps."torch".version or null;
    in
    fileHasVersion
    && torchVersion != null
    && majorMinor torchVersion == requiredTorchSeries version;

  buildBin = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, mkOverlayInfo ? null, wrappers ? null }:
    let
      hashFile      = import (./binary-hashes + "/${cudaLabel}.nix");
      versionHashes = hashFile.${version};
    in
    import ./overlay-bin.nix {
      inherit pkgs cudaPackages versionHashes;
      torchvisionVersion = version;
      torch              = resolvedDeps."torch";
    };

  # torchvision is a binary-wheel package; no source build is implemented.
  buildSource = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, mkOverlayInfo ? null, wrappers ? null }:
    throw "torchvision/high-level.nix: buildSource is not implemented (binary wheels only)";
}
