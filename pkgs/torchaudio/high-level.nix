# High-level derivation for torchaudio.
#
# torchaudio wheels are distributed via download.pytorch.org per CUDA variant
# and per Python version (cp312-cp312, etc.) — exactly like torch.  This HLD
# therefore mirrors pkgs/torch/high-level.nix for the wheel layout
# (per-CUDA-label files, per-Python keying via getVersionsFromCudaFiles), and
# mirrors pkgs/torchao/high-level.nix for the torch dependency wiring
# (highLevelDeps = { inherit torch; }; torch passed through resolvedDeps).
#
# Unlike torchao, torchaudio links against torch's C++ ABI, so it must be
# paired with the *matching* torch version.  torchAgnostic is therefore left at
# its default (false): the store-path stamp keeps the -torch{series} dimension,
# and canBuildBin enforces an exact torch-series match.  torchaudio shares
# torch's major.minor exactly (torchaudio 2.10.x ↔ torch 2.10.x).
#
# hldHelpers and packageName are injected automatically by pkgs/default.nix.

{ torch, hldHelpers, packageName }:

assert hldHelpers.isHLD torch;

let
  srcOwner    = "pytorch";
  srcRepo     = "audio";
  mkChangelog = hldHelpers."github-release-tag" srcOwner srcRepo;
  mkOverlayInfo = hldHelpers.mkOverlayInfo {
    pname       = packageName;
    nixpkgsAttr = packageName;
    inherit srcOwner srcRepo mkChangelog;
  };

  # ── torchaudio ↔ torch version mapping ─────────────────────────────────────
  # torchaudio shares torch's major.minor exactly (torch 2.10→torchaudio 2.10).
  # The required torch major.minor for a torchaudio version is therefore its own
  # major.minor.
  # major.minor of a full version string, e.g. "2.10.0" -> "2.10".
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

  # 1:1 torch-series mapping (torchaudio shares torch's major.minor) consumed
  # by concretise's _selectVersion so that version selection only considers
  # torchaudio versions built against the requested torch series.
  data = { requiredTorchSeries = majorMinor; };

  highLevelDeps = { inherit torch; };

  # A pre-built wheel is usable only when BOTH hold:
  #   1. a hash entry exists for the selected version under this cuda label, and
  #   2. the resolved torch's major.minor matches this torchaudio version's
  #      major.minor (exact ABI match required).
  canBuildBin = { cudaLabel, version, resolvedDeps, ... }:
    let
      f = ./binary-hashes + "/${cudaLabel}.nix";
      fileHasVersion = builtins.pathExists f && builtins.hasAttr version (import f);
      torchVersion = resolvedDeps."torch".version or null;
    in
    fileHasVersion
    && torchVersion != null
    && majorMinor torchVersion == majorMinor version;

  buildBin = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, mkOverlayInfo ? null, wrappers ? null }:
    let
      hashFile      = import (./binary-hashes + "/${cudaLabel}.nix");
      versionHashes = hashFile.${version};
    in
    import ./overlay-bin.nix {
      inherit pkgs cudaPackages versionHashes;
      torchaudioVersion = version;
      torch             = resolvedDeps."torch";
    };

  # torchaudio is a binary-wheel package; no source build is implemented.
  buildSource = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, mkOverlayInfo ? null, wrappers ? null }:
    throw "torchaudio/high-level.nix: buildSource is not implemented (binary wheels only)";
}
