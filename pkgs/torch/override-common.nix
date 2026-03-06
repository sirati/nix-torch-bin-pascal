# Generic torch override for pre-built CUDA wheels.
#
# This is the shared implementation called by torch/high-level.nix buildBin.
# It imports the appropriate binary-hashes/{cudaLabel}.nix plain attrset and
# fetches the matching pre-built wheel.
#
# Arguments:
#   pkgs          - nixpkgs package set (pkgs.python3 must be the target Python)
#   cudaPackages  - the CUDA package set to link against at runtime
#   torchVersion  - PyTorch version string, e.g. "2.10.0"
#   binaryHashes  - plain attrset imported from binary-hashes/{cudaLabel}.nix
#                   (keyed by version string)

{ pkgs, cudaPackages, torchVersion, binaryHashes, triton }:

let
  inherit (import ../../generate-hashes/lib.nix { inherit pkgs; })
    pyVer os arch;

  # Look up wheel data from the provided binary-hashes attrset
  versionData = binaryHashes.${torchVersion}
    or (throw "torch: no wheel for version ${torchVersion} in provided hashes");

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
# The same pre-built wheel works across regular and Pascal CUDA variants;
# the only runtime difference is which cuDNN / cuTENSOR libraries are present.
(pkgs.python3Packages.torch-bin.override {
  inherit cudaPackages triton;
}).overrideAttrs (old: {
  version = torchVersion;
  src     = pkgs.fetchurl wheelData;
})
