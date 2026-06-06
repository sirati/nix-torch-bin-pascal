# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/Dao-AILab/causal-conv1d/releases
# To regenerate: nix run .#default.causal-conv1d.gen-hashes [-- --skip-source --tag v1.6.2]
#
# Structure: cudaVersion -> torchCompat -> pyVer -> os -> arch
#
#   cudaVersion: CUDA major[minor] the wheel was compiled against (e.g. cu11, cu12, cu13).
#   torchCompat: torch major.minor the wheel was compiled against.
#   pyVer:       py39, py310, …  (CPython only; no free-threaded variants).
#   os:          linux  (only Linux wheels provided as pre-built binaries)
#   arch:        x86_64, aarch64
#
# Each leaf node contains the TRUE cxx11abi (new ABI) wheel data:
#   { name, url, hash }
# When a FALSE cxx11abi (pre-cxx11 ABI) wheel also exists it is embedded as:
#   { name, url, hash, precx11abi = { name, url, hash }; }

{
  _version = "1.6.2";
  cu11 = {

    # ── torch 2.6 ─────────────────────────────────────────────────────────
    "2.6" = {
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-llyCEEwmtPmxP820Dvh5XJw5UL4W4mp3l00w2+26x10=";
            precx11abi = {
              name = "causal_conv1d-1.6.2.post1+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-Z1HVuBjpicvW+lB0obUDoFoHUbwB9h6K/nExObaIzpE=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-ydx5Gae4u+fqbrQ9jtXcRM9E+abBg/C82Hu729gQxu4=";
            precx11abi = {
              name = "causal_conv1d-1.6.2.post1+cu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-4/YrOa+vVOfcPjG/Dip+KFk8O0SpJEklGPh2CidFReU=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-x/RrjPlnUfoJ1qbqByz5XdRTLrGa8O9YGsyi+EK2Icc=";
            precx11abi = {
              name = "causal_conv1d-1.6.2.post1+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-4Le1sKZf/2rQOzxw0P7CgO8nyIFtLePurMqR8SyWpC8=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-bRlZaHvnh01kimrTux30NlGuE+abQIjKH+2tN9ESAH4=";
            precx11abi = {
              name = "causal_conv1d-1.6.2.post1+cu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-NLTZH2Rhv0RYLGrrkaTr1p0UuH9XRIuMWF8XDZB/LK0=";
            };
          };
        };
      };
    };

    # ── torch 2.7 ─────────────────────────────────────────────────────────
    "2.7" = {
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-Ap5XIr6V0rjqz7QdHmOVBj5nsk8Hwz00TVXViP5mj7Y=";
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-BFDThK8Yehar1TFL+UxSS/CwwjgSBQ7H2X/LmAxMQM0=";
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-jeYkW80qk83ihVlT1bml1mW7VEsdlfuH4cDD5RW4Juk=";
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-R5V8Y6IyohA8HJrECqN8DHiAVnre/a3Wd4Tpw2ehnhg=";
          };
        };
      };
    };
  };
  cu12 = {

    # ── torch 2.6 ─────────────────────────────────────────────────────────
    "2.6" = {
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-uyWJ61cLpEfirPMPZqFPec8LgAOZmc9h4mhMAfE5h+w=";
            precx11abi = {
              name = "causal_conv1d-1.6.2.post1+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-ANIUoWdZhlTc0Vvo0KIfr1yi4ADeIapoLlOZ5MQbKok=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-16DGr+JC2yHJqfMYecmIX53BF73C8EdwA+f8alrfFrg=";
            precx11abi = {
              name = "causal_conv1d-1.6.2.post1+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-Zz6nNDlW7U0X2CQ2qOswIOpmNcw25HFF8Pr+Nxp7Rq8=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-Hc2aKFaaPaUaecdsE7noEi9iWkJi6rg1ATggfP7n9AE=";
            precx11abi = {
              name = "causal_conv1d-1.6.2.post1+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-xTyl/rdMnlmNrkfKfRy6eGMAf0G1SoJeorJqJndtGBI=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-IAkIk0DE9qJ0CkE1lZobXHtYcawWXhCpvsltOjiLRQg=";
            precx11abi = {
              name = "causal_conv1d-1.6.2.post1+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-i8scZMpX3s9nNSbuGCOycviBm743icVJK3LHegKzFlc=";
            };
          };
        };
      };
    };

    # ── torch 2.7 ─────────────────────────────────────────────────────────
    "2.7" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-d6IWmWubhjkDGm6fhuY8bbSxKJcjeMuY5Mi5XcEAKog=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-5WaVr+WvNcymFKLzt2xtf70MnsDQLocMfn8pbVYSf04=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-yCKFhe7gNJ4qG7XSm8Yi18AkNE6rJDYzukA9Fdb8DMM=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-9gvdMtMeRY9NoVdyqLYdZIiTvARD7w17sponMG4qqmM=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-t+FUfHY8ccHi+n3d9gujEbm3UPmyfvM5ZbLmJVBTpG8=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-QlgqvHJkb8x70zcby3zee1y5x+eBgen5eDGPxdiYK8U=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-Y79mcJVk9UFD+5zvKPCEGYQHYqMhuIPjv0mCFYTUFkY=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-YP/dxRP58+Zme+Go1Oap+YbVzljAv0d3qVzG+2wyj8o=";
          };
        };
      };
    };

    # ── torch 2.8 ─────────────────────────────────────────────────────────
    "2.8" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-za4nkSqYAjsmiE/eqXsh+P2QmW82E3pm3mYTwGe7fGA=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-85msBfZDsyWh6WLjaxJs6gZCGWogdyAG5PLyMl0a2SA=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-fssvNKIHO9qKd+Z+5OF+3v5TPWI5JDLFDppYCuvNkDY=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-ygvKkSv5rTdh86kAgV0JQMHUV8HfJ6HAJLWuQ6DP1os=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-bxXlKBozouv/JGt1o5g69a+vvgkKYfYESXuao8FxIpo=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-7lqH68SouwRAjiDMlc24XpB0K5DAvN+xOEqIdY8u4kY=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.8cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-CwqJyhbacqQ4D5IqNniHmX5iilvMuMYmU5ql6a8LDvU=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-gfXgzfF/g4FNP8Mo7RVJr/2eYeBbCoEqb9t6JHlx8gY=";
          };
        };
      };
    };

    # ── torch 2.9 ─────────────────────────────────────────────────────────
    "2.9" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-WpZlm/sRxZxWtkeLmmiCaBxiPo/yvVWkKl/XpkNc++w=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-rA1AEkOUQepouWLa/g/V1Cs7CGIRt9ge0Kyty7EOLpU=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-/Fyqwq8YveCn0mnoSoD7LsiL+DYSV9190gGjS9le2sU=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-A0HrsUQCoA1XQ+HwrGK/z1qV9SqU5WLBfwreHg2dthY=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-10DNFt9abHG7ea3If1HZjZyKcm0KuTk8FkLn8TXK4q4=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-PQl4ml3ydgpZwgZMRXCkzNMDFZQ1gelVPrH0Es2eJaY=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-VSJXW4hKxR+aEiJxKKI9iO9c4NlQOt2oOEzPJ1uIrUA=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-oUew2eq+3lRMm5p5rhJX03WdgsYsiHVA3e8vQGg3+jk=";
          };
        };
      };
    };

    # ── torch 2.10 ────────────────────────────────────────────────────────
    "2.10" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-F6KOwMF2jLE2cP0zL6RQMq5/1sXkVmxaKwSpDZu+IjA=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-ZZuzmaeb/Kt3HnrzVd9kvcKUWMMIMh13EbQ2PAyok0U=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-CuDY3W0GjivONvDlaNA434MyqP51xSvUIRrdgJgAtw8=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-bvNmdmDvRAT5+DO7aYirRuUCSuwprw8FdcGV4wes9O0=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-UZFmnYEulDhMS72TVc75GhoWLeHVDzl5WFdCak5FtgU=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-wWwcSNT6Y0Fcx5fgLWn5ckjFfARifZnjlNW7DvJm4og=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-cqo44Kq5ngWAngDhz3sPHoRIPnXDVUqTmfK4nXFVxBY=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu12torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-UlTZH8UnI2iW1px1AZgC7j4r+sniMqsQ9g+IvBwk9rU=";
          };
        };
      };
    };
  };
  cu13 = {

    # ── torch 2.9 ─────────────────────────────────────────────────────────
    "2.9" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-B2m9bM8yj3RrlwQBZfJcrAVrnWjy878T3iICqEOBIjs=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-zLr24mbnXv3VhO4OmbD+/F3zWf17X0FV91Tch2iqv+g=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-2Y4RYyC1uuZCbz0i9wBqxtDpeumB5LDl+hFDOrrC3Fc=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-/xdzOisZ0MIbtFdgAQ+E0AfTWGo7HfQXyyJbk1D56WY=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-jSz4EcxT8iqmXctrXVcU5M+KExEYHJ7lr+piDzeJF+Y=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-4zFg+nLSceuJhbo2b4+pRKkmZJRuQTEKqWZ2GGeQT6Q=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-Scy0KatPg6+bA6W0svYP20yqz1M1seA8nCvgKh8FWbY=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-pI5mxRPYAfbLVBdQ3j0BVMcgOg/s2BIRHuaRFwDoCOI=";
          };
        };
      };
    };

    # ── torch 2.10 ────────────────────────────────────────────────────────
    "2.10" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-Ad0tBgKYXg02yHNX6wyHyX4lMYyFoUQKAJuDlsvMe7k=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-ojSM2HIcSYLWfIoc98c8QBT/u7COyifYitQkxThS9/w=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-zBvWeUjofIOad3Nlk1BBrQtfxVE/SGyb7sp3wcKI4Bg=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-u1NCXml2zPiLF6aYFj5UIcxd8QQ11UWeJLTmFHxIeOE=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-f9O10ux4b5ZMJQVdHkEQahVYSSg12avmYKiU9kzC/7c=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-xchctLwzNmu/+nTPIp2pCD/qAnDkH7uyqQ7TXaY58hE=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-ds3Ak8171r4WPwlAiKg2JBzvb3ccA+5xDi1CNKUsC/I=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-+JjVcjEV1LpEuoYEjPmRClhxr/0ZxGML0vo13dKGk78=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.11 ──────────────────────────────────────
    "nvidia-container-25.11" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch25.11cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-P3PZY3U8IbHs8OGvd6KP1Tg9YsRhHXgLNxxrhJlIIVI=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-aHAXbBiNaD8eDHwytNYLpqTkHnWEVRNT+lTB3KbhsZU=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.12 ──────────────────────────────────────
    "nvidia-container-25.12" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch25.12cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch25.12cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-9+ikG8cAR059BfraAk4W0T7rxbBfaijhnjNK7zOSkPg=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch25.12cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch25.12cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-7N6BBwUU7Qkx5NAgvzEGDksCThi5z9J//2m+b0DHK5Q=";
          };
        };
      };
    };

    # ── torch nvidia-container-26.01 ──────────────────────────────────────
    "nvidia-container-26.01" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch26.01cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch26.01cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-QiDxaN62LuIqFv8Iop1Pyw9xDLKH3bNcF4HMQ9Ijhxk=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch26.01cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch26.01cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-CQbBjo3Gaqqng0NdN5K/QQARc+qAhzjLaPiAJxwcT5s=";
          };
        };
      };
    };

    # ── torch nvidia-container-26.02 ──────────────────────────────────────
    "nvidia-container-26.02" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch26.02cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch26.02cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-P8HvAuBet437O3yVDceo2aPlagIgrFPx/fCuh9SABiA=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch26.02cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch26.02cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-QB/ZU2KpUTE/4H4yJRwrbNGd5bLSZv/esC20KHfDNF0=";
          };
        };
      };
    };

    # ── torch nvidia-container-26.03 ──────────────────────────────────────
    "nvidia-container-26.03" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch26.03cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch26.03cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-Bsihksc8HWjCxxuDz77Yla3QJ0Sv0D6QDDNc6md2f0o=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch26.03cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch26.03cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-ms/GPI/8L4qkXt8BHUU+SgOn3m5PcGImotnr/Fu/b/A=";
          };
        };
      };
    };

    # ── torch nvidia-container-26.04 ──────────────────────────────────────
    "nvidia-container-26.04" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch26.04cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch26.04cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-8vZftwgvMwvdtYqxZhMaGdkRtjBOtxXqEXHWYquU20w=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.2.post1+cu13torch26.04cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.2.post1/causal_conv1d-1.6.2.post1%2Bcu13torch26.04cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-TXkqH9snweFkyqbh6aRpvp0WsfFIDdywPBURfTu9yJg=";
          };
        };
      };
    };
  };
}
