# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://pypi.org/project/cuda-python/
# To regenerate: nix run .#default.nvidia-cutlass-dsl.gen-hashes -- --regen-cuda-deps
#
# Pinned cuda-python dependency chain for nvidia-cutlass-dsl (cu13).
# nixpkgs does not package cuda-python, so overlay-bin.nix installs these
# wheels alongside the CuTeDSL wheels.
#
# Structure:
#   cuda-python     = { name, url, hash }     (py3-none-any meta wheel)
#   cuda-pathfinder = { name, url, hash }     (py3-none-any wheel)
#   cuda-bindings   = pyVer -> os -> arch -> { name, url, hash }

{
  _cudaPythonVersion     = "13.0.3";
  _cudaBindingsVersion   = "13.0.3";
  _cudaPathfinderVersion = "1.5.5";
  cuda-python = {
    name = "cuda_python-13.0.3-py3-none-any.whl";
    url = "https://files.pythonhosted.org/packages/31/5f/beaa12a11b051027eec0b041df01c6690db4f02e3b2e8fadd5a0eeb4df52/cuda_python-13.0.3-py3-none-any.whl";
    hash = "sha256-kUzX4t0HW9BqLVEhwdnM3T0MlLA+paRNvZjSTY7ZO6s=";
  };
  cuda-pathfinder = {
    name = "cuda_pathfinder-1.5.5-py3-none-any.whl";
    url = "https://files.pythonhosted.org/packages/11/c8/26f2e4aae92f11522a96043892ba39a90eac610d5242523aa863212bc1c7/cuda_pathfinder-1.5.5-py3-none-any.whl";
    hash = "sha256-AijAI/ldFIDxQ+9ciSLSeiqwUgh6lC6B3Cicnrj5Fok=";
  };
  cuda-bindings = {
    py39 = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-13.0.3-cp39-cp39-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/58/e3/71a581c8e38a9a795c757f89e811f57397d8bf64c359c7cbe2cc68f2056a/cuda_bindings-13.0.3-cp39-cp39-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-q9hIFAD5WUhOSACCgbL/A0rGlziBkGr+4dNG4R8eGq4=";
        };
        x86_64 = {
          name = "cuda_bindings-13.0.3-cp39-cp39-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/17/72/f70f67a563562dea12beeb12e7700c94aceaa81fddaa547b8ffeb5940250/cuda_bindings-13.0.3-cp39-cp39-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-VHlZyHGFzn0KVHr6G3KLtwfJ8Ns4mU+LiUQvO9w3nXM=";
        };
      };
    };
    py310 = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-13.0.3-cp310-cp310-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/3b/98/0666ee759cd2e5306f911cbc95d2c6c814326906ed6b9c09e817a4b4a7c8/cuda_bindings-13.0.3-cp310-cp310-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-1W5GqemEu3VOVrnQYM8Cf+mfCKl2Uc5tiqHCAyR20B4=";
        };
        x86_64 = {
          name = "cuda_bindings-13.0.3-cp310-cp310-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/e1/36/2b2a43c8a6f8d8ff7a5ec7de1357ba3f1438ea69281c9deb90df29d55d56/cuda_bindings-13.0.3-cp310-cp310-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-xfeXzlNKMDUlJZvgrn7pz89PeHSyLx+bjoVVVQncy4M=";
        };
      };
    };
    py311 = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-13.0.3-cp311-cp311-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/dc/67/9e171ee6359d4aabf2d8202802c85487cae6c2eb52b9352bb7754583802f/cuda_bindings-13.0.3-cp311-cp311-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-39ZsJaEzNlxPk+M5bDjGSwRADMr9GMOoia4lGhv6uqE=";
        };
        x86_64 = {
          name = "cuda_bindings-13.0.3-cp311-cp311-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/3a/66/d7036d9e402e6b5b57877a7496aba3bf2a0090f4fa3f072743fce3373eba/cuda_bindings-13.0.3-cp311-cp311-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-mv7eWTdHSGSqeU61c5nb310rBUJ6rcrCdSCbCFdSimE=";
        };
      };
    };
    py312 = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-13.0.3-cp312-cp312-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/61/3c/c33fd3aa5fcc89aa1c135e477a0561f29142ab5fe028ca425fc87f7f0a74/cuda_bindings-13.0.3-cp312-cp312-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-uJnlpRPBHqoYZI+b9SZdjeKpP3bvZqa/ygoohzA5Zc0=";
        };
        x86_64 = {
          name = "cuda_bindings-13.0.3-cp312-cp312-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/21/ac/6b34452a3836c9fbabcd360689a353409d15f500dd9d9ced7f837549e383/cuda_bindings-13.0.3-cp312-cp312-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-z0HZ5pAZk5qhUpb6Zup9P9uNLGOD9yn0sRVsizeAigY=";
        };
      };
    };
    py313 = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-13.0.3-cp313-cp313-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/2f/36/41ccc303eb6be8ae82c5edd2ccae938876e8a794660e8bb96a193174a978/cuda_bindings-13.0.3-cp313-cp313-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-+xan92nJxnRprdeh2fbBTdRGN/aSHLa564LLUBWzXD0=";
        };
        x86_64 = {
          name = "cuda_bindings-13.0.3-cp313-cp313-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/ab/ac/699889100536f1b63779646291e74eefa818087a0974eb271314d850f5dc/cuda_bindings-13.0.3-cp313-cp313-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-US0NgDpeR6ikLVo0zgkygCv3L+lS/bEax5hxWjXG5cs=";
        };
      };
    };
    "py313-freethreaded" = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-13.0.3-cp313-cp313t-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/11/67/9656e003f18c5b32e1a2496998b24f4355ec978c5f3639b0eb9f6d0ff83f/cuda_bindings-13.0.3-cp313-cp313t-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-yFnjJsd2pH5mxQOGoQyE/jQpHrbnEWEMn9fMJ9RGM08=";
        };
        x86_64 = {
          name = "cuda_bindings-13.0.3-cp313-cp313t-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/18/d8/a83379caa7c1bed4195e704c24467a6c07fe8e29c7055ccd4f00c5702363/cuda_bindings-13.0.3-cp313-cp313t-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-5nXb0An7XmbWP9E6j/NfhJEg8BvMTa+tvO0wBGBcNYg=";
        };
      };
    };
    py314 = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-13.0.3-cp314-cp314-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/e8/99/0042dc5e98e3364480b1aaabc0f5c150d037825b264bba35ac7a883e46ee/cuda_bindings-13.0.3-cp314-cp314-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-fH5uic38mzTxagZcxq1sS6sZzl3O+No6zorRC9qJn6A=";
        };
        x86_64 = {
          name = "cuda_bindings-13.0.3-cp314-cp314-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/7a/c4/a931a90ce763bd7d587e18e73e4ce246b8547c78247c4f50ee24efc0e984/cuda_bindings-13.0.3-cp314-cp314-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-6ThmRl5/9Lfr33Ec+c1oBJnNh1+ZIFjGi+CNR3WsIz0=";
        };
      };
    };
    "py314-freethreaded" = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-13.0.3-cp314-cp314t-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/6f/2c/ec611e27ba48a9056f3b0610c5e27727e539f3905356cfe07acea18e772c/cuda_bindings-13.0.3-cp314-cp314t-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-7QbvNQe9Cu+w2jZ+PRVnaox0Q71oqI8phWLWC0EHjCA=";
        };
        x86_64 = {
          name = "cuda_bindings-13.0.3-cp314-cp314t-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/d4/2e/02cebf281ef5201b6bb9ea193b1a4d26e6233c46571cfb04c4a7dede12b9/cuda_bindings-13.0.3-cp314-cp314t-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-OrhFSHyiwUrM3LOTpVmjBwRp6ktZHQXm70OUcfR/PiQ=";
        };
      };
    };
  };
}
