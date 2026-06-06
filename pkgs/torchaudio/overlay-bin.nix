# Binary wheel overlay for torchaudio.
#
# torchaudio ships per-Python-version wheels (cp312-cp312, etc.), exactly
# like torch, so the hash lookup is version -> pyVer -> os -> arch (mirroring
# pkgs/torch/overlay-common.nix) rather than torchao's stable-ABI layout.
#
# torchaudio links against torch's C++ ABI, so it must be paired with the
# matching torch derivation (resolved via highLevelDeps in high-level.nix and
# passed in here as `torch`).
#
# Arguments:
#   pkgs              - nixpkgs package set (pkgs.python3 must be the target Python)
#   cudaPackages      - the CUDA package set
#   torchaudioVersion - version string, e.g. "2.10.0"
#   versionHashes     - attrset from binary-hashes/{cudaLabel}.nix for this version
#                       (structure: pyVer -> os -> arch -> {name, url, hash})
#   torch             - resolved torch derivation (matching runtime + ABI dep)

{ pkgs, cudaPackages, torchaudioVersion, versionHashes, torch }:

let
  inherit (import ../../generate-hashes/lib.nix { inherit pkgs; })
    pyVer os arch;

  wheelData =
    if builtins.hasAttr pyVer versionHashes then
      let pyData = versionHashes.${pyVer}; in
      if builtins.hasAttr os pyData then
        let osData = pyData.${os}; in
        if builtins.hasAttr arch osData then
          osData.${arch}
        else throw "torchaudio ${torchaudioVersion}: unsupported arch ${arch} (available: ${builtins.toString (builtins.attrNames osData)})"
      else throw "torchaudio ${torchaudioVersion}: unsupported OS ${os} (available: ${builtins.toString (builtins.attrNames pyData)})"
    else throw "torchaudio ${torchaudioVersion}: unsupported Python version ${pyVer} (available: ${builtins.toString (builtins.attrNames versionHashes)})";

in
pkgs.python3Packages.buildPythonPackage {
  pname   = "torchaudio";
  version = torchaudioVersion;
  format  = "wheel";

  src = pkgs.fetchurl {
    inherit (wheelData) url hash;
    name = wheelData.name;
  };

  build-system = [];
  buildInputs  = [];

  dependencies = [ torch ];

  doCheck = false;

  pythonImportsCheck = [ "torchaudio" ];

  meta = {
    description = "Audio I/O and signal processing for PyTorch (pre-built wheel)";
    homepage    = "https://github.com/pytorch/audio";
    sourceProvenance = with pkgs.lib.sourceTypes; [ binaryNativeCode ];
  };
}
