# Source build overlay for torchao.
#
# torchao has one git submodule (cutlass at third_party/cutlass).
# Build system: setuptools + wheel with C++/CUDA extensions.

{ overlayInfo }:

let
  buildSourcePackage = (import ../../concretise/source-build-helpers.nix).buildSourcePackage;
in
buildSourcePackage {
  inherit overlayInfo;
  sourceHashesDir = ./source-hashes;

  fetchSubmodules = true;

  # torch is declared as a build dependency in pyproject.toml but we
  # provide it via the overlay; strip it to avoid circular deps.
  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail '"torch"' "" || true
  '';

  forceBuildEnvVar = "USE_CPP";
}
