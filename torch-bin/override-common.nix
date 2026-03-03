# Generic torch-bin override for pre-built CUDA wheels.
#
# This is the shared implementation used by torch-bin-cu126 and torch-bin-cu128.
# Each CUDA variant's override.nix calls this with its own binaryHashes set.
#
# Arguments:
#   pkgs          - nixpkgs package set (pkgs.python3 must be the target Python)
#   cudaPackages  - the CUDA package set to link against at runtime
#   torchVersion  - PyTorch version string, e.g. "2.10.0"
#   binaryHashes  - the imported binary-hashes.nix function (takes torchVersion)

{ pkgs, cudaPackages, torchVersion, binaryHashes }:

let
  inherit (import ../generate-binary-hashes/lib.nix { inherit pkgs; })
    pyVer os arch;

  # Look up wheel data from the provided binary-hashes function
  versionData = binaryHashes torchVersion;

  wheelData =
    if builtins.hasAttr pyVer versionData then
      let pyData = versionData.${pyVer}; in
      if builtins.hasAttr os pyData then
        let osData = pyData.${os}; in
        if builtins.hasAttr arch osData then
          osData.${arch}
        else throw "Unsupported architecture for torch ${torchVersion}: ${arch} (available: ${builtins.toString (builtins.attrNames osData)})"
      else throw "Unsupported OS for torch ${torchVersion}: ${os} (available: ${builtins.toString (builtins.attrNames pyData)})"
    else throw "Unsupported Python version for torch ${torchVersion}: ${pyVer} (available: ${builtins.toString (builtins.attrNames versionData)})";

in
# Override cudaPackages and wheel source on the upstream torch-bin derivation.
# The same pre-built wheel works for both regular and Pascal CUDA variants;
# the only runtime difference is which cuDNN / cuTENSOR libraries are present.
(pkgs.python3Packages.torch-bin.override {
  inherit cudaPackages;
}).overrideAttrs (old: {
  version = torchVersion;
  src     = pkgs.fetchurl wheelData;
})
