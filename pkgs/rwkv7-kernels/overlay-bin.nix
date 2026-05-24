# rwkv7-kernels binary wheel derivation — thin wrapper around buildBinWheel.

{ overlayInfo
, cudaVersion ? "cu12"
, cxx11abi    ? "TRUE"
}:

let
  wheelHelpers = import ../../wheel-helpers.nix;
in
wheelHelpers.buildBinWheel {
  inherit overlayInfo cudaVersion cxx11abi;
  binaryHashesDir = ./binary-hashes;
  pythonImportsCheck = [ "rwkv7_kernels" ];
}
