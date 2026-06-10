# apache-tvm-ffi binary wheel derivation.
#
# Hash lookup: binary-hashes/v{version}.nix with pyVer -> os -> arch leaves
# (abi3 wheels are expanded to explicit pyVer entries at generation time).
#
# Arguments:
#   overlayInfo  - common package context attrset from high-level.nix

{ overlayInfo }:

let
  pkgs = overlayInfo.pkgs;
  version = overlayInfo.version;
  changelog = overlayInfo.changelog or null;

  lib = pkgs.lib;

  inherit (import ../../generate-hashes/lib.nix { inherit pkgs; }) pyVer os arch;

  hashes = import (./binary-hashes + "/v${version}.nix");

  wheelData =
    hashes.${pyVer}.${os}.${arch} or (throw (
      "apache-tvm-ffi ${version}: no wheel for ${pyVer}/${os}/${arch}"
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

  # The bundled libtvm_ffi.so is dlopen'ed via ctypes before any other
  # native library is loaded, so its libstdc++ dependency must be resolvable
  # from the RPATH — patch it in (manylinux wheels carry no RPATH).
  nativeBuildInputs = [ pkgs.autoPatchelfHook ];
  buildInputs = [ pkgs.stdenv.cc.cc.lib ];

  dependencies = [ pkgs.python3Packages.typing-extensions ];

  doCheck = false;

  pythonImportsCheck = [ "tvm_ffi" ];

  meta = {
    description = "TVM FFI — minimal stable ABI/FFI runtime for ML systems (pre-built wheel)";
    homepage = "https://github.com/apache/tvm-ffi";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    broken = (overlayInfo.isBinBuildBroken or (_: false)) overlayInfo;
  }
  // lib.optionalAttrs (changelog != null) { inherit changelog; };
}
