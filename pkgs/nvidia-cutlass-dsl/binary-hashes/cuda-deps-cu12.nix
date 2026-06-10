# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://pypi.org/project/cuda-python/
# To regenerate: nix run .#default.nvidia-cutlass-dsl.gen-hashes -- --regen-cuda-deps
#
# Pinned cuda-python dependency chain for nvidia-cutlass-dsl (cu12).
# nixpkgs does not package cuda-python, so overlay-bin.nix installs these
# wheels alongside the CuTeDSL wheels.
#
# Structure:
#   cuda-python     = { name, url, hash }     (py3-none-any meta wheel)
#   cuda-pathfinder = { name, url, hash }     (py3-none-any wheel)
#   cuda-bindings   = pyVer -> os -> arch -> { name, url, hash }

{
  _cudaPythonVersion     = "12.9.7";
  _cudaBindingsVersion   = "12.9.7";
  _cudaPathfinderVersion = "1.5.5";
  cuda-python = {
    name = "cuda_python-12.9.7-py3-none-any.whl";
    url = "https://files.pythonhosted.org/packages/c1/9d/05e753afbaac3f92691059b3ba875589c98a425d69e5808cec32b31b580c/cuda_python-12.9.7-py3-none-any.whl";
    hash = "sha256-I6H8QG1JHu96fphQlXJct7IKBKe9m3pmQA5chuCC4Ko=";
  };
  cuda-pathfinder = {
    name = "cuda_pathfinder-1.5.5-py3-none-any.whl";
    url = "https://files.pythonhosted.org/packages/11/c8/26f2e4aae92f11522a96043892ba39a90eac610d5242523aa863212bc1c7/cuda_pathfinder-1.5.5-py3-none-any.whl";
    hash = "sha256-AijAI/ldFIDxQ+9ciSLSeiqwUgh6lC6B3Cicnrj5Fok=";
  };
  cuda-bindings = {
    py310 = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-12.9.7-cp310-cp310-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/cd/2e/b1b14be5884519917f9df4d9106d3e16575c19fa847d13a3f6e9d272b5cd/cuda_bindings-12.9.7-cp310-cp310-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-oxgHXvMnfKL9199dS/ZxOIaWtPK2XixEg/GFNRdpLjs=";
        };
        x86_64 = {
          name = "cuda_bindings-12.9.7-cp310-cp310-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/82/1f/0809c53f694693d703c9efee0379875089db17ab50196845e08f6c686fd4/cuda_bindings-12.9.7-cp310-cp310-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-+V3r0sVMXwh0YmaFEbyysSlbqjic1t6edoIS88qyu+I=";
        };
      };
    };
    py311 = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-12.9.7-cp311-cp311-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/40/f3/f9d1095f90d2a4df24cfcafe7487fd9444c6dacb94e3722be6fedd8ac26c/cuda_bindings-12.9.7-cp311-cp311-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-FgQ+9bFauI/plUxcIGGx2AB1kbJ/LJFjMQVt4OvGGH4=";
        };
        x86_64 = {
          name = "cuda_bindings-12.9.7-cp311-cp311-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/3a/8a/1251e1794b69865aacd5629936006b18ea0816a495de4ecea9a825556eb3/cuda_bindings-12.9.7-cp311-cp311-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-xklqiNhLEgnWZRsDcMGcJjGeFXwi9tAYv5o1jNgEkEE=";
        };
      };
    };
    py312 = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-12.9.7-cp312-cp312-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/32/45/557d4ed1fa54f0c7db8aee083229f624990d69f7d00f55477eed5c7e169a/cuda_bindings-12.9.7-cp312-cp312-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-BmbTwILvj0stZwlQWJNzVQ6fO/Vk1jXdiD8koLQEAv8=";
        };
        x86_64 = {
          name = "cuda_bindings-12.9.7-cp312-cp312-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/91/97/e3c6e58ece26a053419ba0a18444b5443cfc64451bbf37f84e8143b8bdca/cuda_bindings-12.9.7-cp312-cp312-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-TH70jF4TrpDzsuz7cvjpmsQ8j0xD5n4TJbiq4zFFNoc=";
        };
      };
    };
    py313 = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-12.9.7-cp313-cp313-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/eb/7b/f1575e41e1a17dc2f2a408b2e8e864c9324e41e3e23f6401e5efc54c152a/cuda_bindings-12.9.7-cp313-cp313-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-JmN55JQgUfVEqOfqGjDq2NfoGZtrMPzciRfK4r9hTmE=";
        };
        x86_64 = {
          name = "cuda_bindings-12.9.7-cp313-cp313-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/9d/dc/62d62eb4f91eb721bcf46da51b13e9872ccd8fa7e60eb8ba7b7baeac72c6/cuda_bindings-12.9.7-cp313-cp313-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-Wc9KN7DWYroVA3yc7r4aMG6/LAGoI1oJvhPNBwlP23Q=";
        };
      };
    };
    "py313-freethreaded" = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-12.9.7-cp313-cp313t-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/f9/77/94d9b85f26add6fe9c9cb7c4ec3b96bc598f7ea5cfbd7490cc0a36adf5be/cuda_bindings-12.9.7-cp313-cp313t-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-LbzUgBlU6zUI9NwvoNDI65PrP0Uyb9Yb4nMUGMNx56A=";
        };
        x86_64 = {
          name = "cuda_bindings-12.9.7-cp313-cp313t-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/04/dd/3ec34b569e1b990b11276feba306bf8f446656cc38e8ed0f49b5facfeffa/cuda_bindings-12.9.7-cp313-cp313t-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-N0fqEyZCQWeGqOMb8ikDLfOnhWkRrlQmp75T0DLfGD0=";
        };
      };
    };
    py314 = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-12.9.7-cp314-cp314-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/68/e4/075052d42872cf8162da53f14447a4b8abc004c3750e4b724ee502428da0/cuda_bindings-12.9.7-cp314-cp314-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-d1lgrJ5TBxfztI4WXMb2hoT6mkFBdk/ZI+TBqYIKzHM=";
        };
        x86_64 = {
          name = "cuda_bindings-12.9.7-cp314-cp314-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/ec/cd/3289c810a4d45e5364a3387a74b4c9b6f6f57ee96ae0e5b537cc61dec242/cuda_bindings-12.9.7-cp314-cp314-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-PEfsGnpEHZGqsyM5lR33ob5TRREhoSwJS7pRRncXo1o=";
        };
      };
    };
    "py314-freethreaded" = {
      linux = {
        aarch64 = {
          name = "cuda_bindings-12.9.7-cp314-cp314t-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/11/43/472a6281c3d94e71687e27c657a8f60718d3579b4d94c41deea503165f8a/cuda_bindings-12.9.7-cp314-cp314t-manylinux_2_24_aarch64.manylinux_2_28_aarch64.whl";
          hash = "sha256-AKgz05mzEHH6tM894pKYQK5GLcSEgRbu/wM9CSGecRY=";
        };
        x86_64 = {
          name = "cuda_bindings-12.9.7-cp314-cp314t-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/2b/13/10c1d0b32a9da65142d213e0733d748457fb3fd066aee4317335266f15c6/cuda_bindings-12.9.7-cp314-cp314t-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-Ea6vorM5lfiQCGs/sPBiB1F22Vbptqb+Gmmd3cQT9q0=";
        };
      };
    };
  };
}
