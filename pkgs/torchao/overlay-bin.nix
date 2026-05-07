# Binary wheel overlay for torchao.
#
# torchao uses the Python Stable ABI (cp310-abi3), so there is no
# per-Python-version dimension.  Hash lookup: os -> arch -> {name, url, hash}.
#
# Arguments:
#   pkgs            - nixpkgs package set
#   cudaPackages    - the CUDA package set
#   torchaoVersion  - version string, e.g. "0.16.0"
#   versionHashes   - attrset from binary-hashes/{cudaLabel}.nix for this version
#   torch           - resolved torch derivation (runtime dependency)

{ pkgs, cudaPackages, torchaoVersion, versionHashes, torch }:

let
  inherit (import ../../generate-hashes/lib.nix { inherit pkgs; })
    os arch;

  wheelData =
    if builtins.hasAttr os versionHashes then
      let osData = versionHashes.${os}; in
      if builtins.hasAttr arch osData then
        osData.${arch}
      else throw "torchao ${torchaoVersion}: unsupported arch ${arch} (available: ${builtins.toString (builtins.attrNames osData)})"
    else throw "torchao ${torchaoVersion}: unsupported OS ${os} (available: ${builtins.toString (builtins.attrNames versionHashes)})";

in
pkgs.python3Packages.buildPythonPackage {
  pname   = "torchao";
  version = torchaoVersion;
  format  = "wheel";

  src = pkgs.fetchurl {
    inherit (wheelData) url hash;
    name = wheelData.name;
  };

  build-system = [];
  buildInputs  = [];

  dependencies = [ torch ];

  doCheck = false;

  pythonImportsCheck = [ "torchao" ];

  meta = {
    description = "PyTorch-native quantization, sparsity, and optimization (pre-built wheel)";
    homepage    = "https://github.com/pytorch/ao";
    sourceProvenance = with pkgs.lib.sourceTypes; [ binaryNativeCode ];
  };
}
