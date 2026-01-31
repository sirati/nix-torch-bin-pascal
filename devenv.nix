{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Helper function to trace values with proper type handling (recursive)
  traceValue = name: value:
    let
      serializeValue = v:
        let vType = builtins.typeOf v;
        in
          if vType == "list" then builtins.toJSON (map serializeValue v)
          else if vType == "set" then
            if v ? outPath then toString v
            else if v ? pname then v.pname
            else if v ? name then v.name
            else builtins.toJSON (builtins.attrNames v)
          else if vType == "bool" then toString v
          else if vType == "null" then "null"
          else if vType == "int" then toString v
          else if vType == "string" then v
          else toString v;
      output = serializeValue value;
    in
      builtins.trace "${name}: ${output}";

  # Use the built-in languages.python.import function to load the Python project
  pythonEnv = config.languages.python.import ./. {};
in
{

  # https://devenv.sh/languages/
  languages = {
    python = {
      enable = true;
      version = "3.13";
    };
  };

  # Add the Python environment created by uv2nix along with CUDA packages
  packages =
    assert builtins.trace "=== Python Environment Debug ==="
           traceValue "pythonEnv" pythonEnv
           false;
    [ pythonEnv ] ++
  (with pkgs.cudaPackages_12_6; [
    #cudatoolkit
    cudnn

    #below taken from https://github.com/NixOS/nixpkgs/blob/nixos-25.11/pkgs/development/python-modules/torch/source/default.nix#L555
    cuda_cccl # <thrust/*>
    cuda_cudart # cuda_runtime.h and libraries
    cuda_cupti # For kineto
    cuda_nvcc # crt/host_config.h; even though we include this in nativeBuildInputs, it's needed here too
    cuda_nvml_dev # <nvml.h>
    cuda_nvrtc
    cuda_nvtx # -llibNVToolsExt
    libcublas
    libcufft
    libcufile
    libcurand
    libcusolver
    libcusparse
    libcusparse_lt
  ]) ++ (with pkgs; [

  ]);

  # Configure Cachix caches
  cachix = { # "devenv" is added by default and not overwritten by this assignment
    pull = [ "cuda-maintainers" "flox"];
    # "flox-cache-public" is not hosted on cachix? i.e. "https://cache.flox.dev"
  };

  # Set CUDA environment variables for the Pascal GPU (Compute Capability 6.1)
  env = {
    CUDA_PATH = "${pkgs.cudaPackages_12_6.cudatoolkit}";
    LD_LIBRARY_PATH = "${pkgs.cudaPackages_12_6.cudatoolkit}/lib:${pkgs.linuxPackages.nvidia_x11}/lib";
    # Force torch/flash-attention to recognize the 1080 Ti architecture if needed during JIT
    TORCH_CUDA_ARCH_LIST = "6.1";
  };

  enterShell = ''
    echo "Python ''${python --version} with CUDA 12.6 environment loaded."
    echo "Pascal GPU (1080 Ti) target: SM 6.1"
    echo "Using uv2nix for package management - dependencies defined in pyproject.toml"
  '';

  # See full reference at https://devenv.sh/reference/options/
}
