# FlashAttention 4 source build derivation.
#
# The FA4 Python project is in flash_attn/cute inside the flash-attention repo.
# It is a pure-Python package backed by CuTeDSL/QuACK runtime JIT kernels.

{ overlayInfo, nvidia-cutlass-dsl, apache-tvm-ffi, torch-c-dlpack-ext, quack-kernels }:

let
  buildSourcePackage =
    (import ../../concretise/source-build-helpers.nix).buildSourcePackage;

  inherit (overlayInfo) pkgs version;

  pep440Version =
    let
      m = builtins.match "fa4-v([0-9]+[.][0-9]+[.][0-9]+)[.]beta([0-9]+)" version;
    in
    if m == null then version else "${builtins.elemAt m 0}b${builtins.elemAt m 1}";
in
buildSourcePackage {
  inherit overlayInfo;
  sourceHashesDir = ./source-hashes;

  fetchSubmodules = true;
  cudaSupport = false;

  sourceSubdir = "flash_attn/cute";

  postPatch = ''
    substituteInPlace __init__.py \
      --replace-fail 'version("fa4")' 'version("flash-attn-4")'
  '';

  extraBuildSystemPackages = [
    pkgs.python3Packages.setuptools-scm
  ];

  extraDependencies = [
    nvidia-cutlass-dsl
    apache-tvm-ffi
    torch-c-dlpack-ext
    quack-kernels
    pkgs.python3Packages.einops
    pkgs.python3Packages.typing-extensions
  ];

  extraEnv = {
    SETUPTOOLS_SCM_PRETEND_VERSION = pep440Version;
  };

  pythonImportsCheck = [ "flash_attn.cute" ];
  siteAwareImportsCheck = true;
}
