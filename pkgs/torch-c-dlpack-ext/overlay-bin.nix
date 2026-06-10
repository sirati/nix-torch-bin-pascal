# torch-c-dlpack-ext binary wheel derivation.
#
# Hash lookup: binary-hashes/v{version}.nix with pyVer -> os -> arch leaves.
#
# Arguments:
#   overlayInfo  - common package context attrset from high-level.nix
#                  (torch is the resolved torch derivation)

{ overlayInfo }:

let
  pkgs = overlayInfo.pkgs;
  version = overlayInfo.version;
  torch = overlayInfo.torch;
  changelog = overlayInfo.changelog or null;

  lib = pkgs.lib;

  inherit (import ../../generate-hashes/lib.nix { inherit pkgs; }) pyVer os arch;

  hashes = import (./binary-hashes + "/v${version}.nix");

  wheelData =
    hashes.${pyVer}.${os}.${arch} or (throw (
      "torch-c-dlpack-ext ${version}: no wheel for ${pyVer}/${os}/${arch}"
    ));

in
pkgs.python3Packages.buildPythonPackage {
  pname = overlayInfo.pname;
  inherit version;
  format = "wheel";

  src = pkgs.fetchurl {
    inherit (wheelData) url hash;
    name = wheelData.name;
  };

  build-system = [ ];

  # Patch libstdc++ into the extension's RPATH.  torch's own libraries are
  # left unresolved: the package imports torch before loading the extension,
  # so their sonames are already in the process link map at load time.
  nativeBuildInputs = [ pkgs.autoPatchelfHook ];
  buildInputs = [ pkgs.stdenv.cc.cc.lib ];
  autoPatchelfIgnoreMissingDeps = true;

  dependencies = [
    torch
    # Undeclared upstream runtime dependency (core.py imports
    # packaging.version but the wheel metadata only lists torch).
    pkgs.python3Packages.packaging
  ];

  doCheck = false;

  pythonImportsCheck = [ "torch_c_dlpack_ext" ];

  meta = {
    description = "C-level DLPack converter extension for torch tensors (pre-built wheel)";
    homepage = "https://github.com/apache/tvm-ffi";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    broken = (overlayInfo.isBinBuildBroken or (_: false)) overlayInfo;
  }
  // lib.optionalAttrs (changelog != null) { inherit changelog; };
}
