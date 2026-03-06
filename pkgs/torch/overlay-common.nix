# Generic torch overlay for pre-built CUDA wheels.
#
# This is the shared implementation called by torch/high-level.nix buildBin.
# It imports the appropriate binary-hashes/{cudaLabel}.nix plain attrset and
# fetches the matching pre-built wheel.
#
# Arguments:
#   pkgs          - nixpkgs package set (pkgs.python3 must be the target Python)
#   cudaPackages  - the CUDA package set to link against at runtime
#   cudaLabel     - canonical CUDA label string, e.g. "cu128"
#   torchVersion  - PyTorch version string, e.g. "2.10.0"
#   binaryHashes  - plain attrset imported from binary-hashes/{cudaLabel}.nix
#                   (keyed by version string)

{ pkgs, cudaPackages, cudaLabel, torchVersion, binaryHashes, triton }:

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

  # cuDNN version note:
  #   torch cu128 wheels are compiled against cuDNN 9.13.0 (matches nixpkgs).
  #   torch cu126 and cu130 wheels are compiled against cuDNN 9.15.1, which is
  #   not yet available in nixpkgs.  For those labels we substitute a custom
  #   cuDNN 9.15.1 derivation so that autoPatchelfHook resolves libcudnn.so.9
  #   against the correct version and torch's runtime version check passes.
  cudnn =
    if cudaLabel == "cu126" then
      import ./cudnn-9-15-1.nix { inherit pkgs; cudaVariant = "cuda12"; }
    else if cudaLabel == "cu130" then
      import ./cudnn-9-15-1.nix { inherit pkgs; cudaVariant = "cuda13"; }
    else
      cudaPackages.cudnn;

in
# Override cudaPackages and wheel source on the upstream torch-bin derivation.
# The same pre-built wheel works across regular and Pascal CUDA variants;
# the only runtime difference is which cuDNN / cuTENSOR libraries are present.
(pkgs.python3Packages.torch-bin.override {
  inherit cudaPackages triton;
}).overrideAttrs (old: {
  version = torchVersion;
  src     = pkgs.fetchurl wheelData;
  buildInputs = builtins.map
    (x: if (x.pname or "") == "cudnn" then cudnn else x)
    (old.buildInputs or []);
})
