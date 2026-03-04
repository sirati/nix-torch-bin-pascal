# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/Dao-AILab/flash-attention/releases
# To regenerate: nix-shell pkgs/flash-attn/generate-hashes.py [-- --tag v2.8.2]
#
# Structure: cudaVersion -> torchCompat -> pyVer -> os -> arch
#
#   cudaVersion: CUDA major[minor] the wheel was compiled against (e.g. cu12, cu126).
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
  _version = "2.8.2";
  cu12 = {

    # ── torch 2.4 ─────────────────────────────────────────────────────────
    "2.4" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-1zVnb2byUkBdBJ87pFXYhN0KytmiAGwogqIHG2iqwm8=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-SmDtYXAb3Tn7WmkUgupFHgkgFYXVVaQbzuDDZuc3+oc=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-S4Ou9AIqoXT4CCMRu0+Hs6/y0fnYAlLa75LNnBfK9AU=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-RYGhTWxJUnB89708ExYW5nDCUdyVUHR5b84m1w70/8I=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-9pp3rZ5BHjqLsF6V1nX/K1JMPoKybDhnyPh9ZIeFpxQ=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-Ajfu5Bv4gn/u8Ip6iZtiyvLlFONmQgQ4iGtrrwzVHjQ=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-kdVMOBmfBwAzzb2kJ/HESqbNxJDhj4B5zBSlvABCqzU=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-4k5TLvJedej4qDV+q/SUp/uWaDj863rjbdt6+Wbe7/A=";
            };
          };
        };
      };
    };

    # ── torch 2.5 ─────────────────────────────────────────────────────────
    "2.5" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-hd41mOfEVw9LEU7F1v3L+UtUtvU0v/kwEUc1f/BDuZ8=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-n1QP4gujBtrzN9d9j0mGTcxUIjDVG1GZk/XZas/S6Xc=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-SXyWLUrYr3+8NV1YLJptQ/NO2YovKZPddNpcoP8RHkg=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-1stpDWHNLtng7TkcQxKs4MGSQjezYAeeyA0MHipVm7c=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-IrBMFIX8AnVlGry3xbh3q/2rWh6hlbrwJXXf1K1YxyI=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-z3lcr/CAC2e2BuncgcJK38QdFCPovMGkRkTpJffXI1c=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-yvqK1OQXefqy590sgu8x2IDPCEye/2H4ArZqBtB/bys=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-HM1BCM88iMbdt+XubQoysn8s8P7tFXZectuPulUZE/g=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-+G30b4q2ALPFTqkSXNUqaDd2dO6YOT25LUBa/SCD9M4=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-iRMHqFcDAmb1aZ6loVUIEObbVUkswpsNtN9JRpE14Gw=";
            };
          };
        };
      };
    };

    # ── torch 2.6 ─────────────────────────────────────────────────────────
    "2.6" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-wSpAxxmC1G78HaB9CgUxJgvM7+pZZHChMp+ezUWU/l8=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-veYLy0MSr+rZHqPvZJ7hsVZxONvxxrACEyZ5E1RGouw=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-N1eIrJT+hyZOH3clW8zLjUD7beOFoFVVZAdvBJ+MykM=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-tXsmkQe8Nuk0reb/8fxGgrzYF06rv+oQ+Evf0pXm3ws=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-fmv+MRo2TZ0eb7GhWx3xK295Rbx+CCBssJjHDx1yJ5Y=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-QiF01f9y5EwMMAodH5nmX+6wLNT5+8UyB1WofJniIz0=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-Bygig1ifmFv/T9egpifnlcZd75JXaFIp+fIQGWt15sI=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-IwViFH8Ld62HJRrM5HoYr8Ay9kb9g+mvJvr+ERXJPEM=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-PnWzzWjACm4jyUNLTvKtyMt5pJpBwjH6b3vX91CfLtI=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-FURT92kor0RHJjZkLhrCj06DMlJLn9q65Fp+fbdr1C0=";
            };
          };
        };
      };
    };

    # ── torch 2.7 ─────────────────────────────────────────────────────────
    "2.7" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-BQOXVzks5kCunHwKW4/kstIzOjsOVJ/G52WfSTmjQ+o=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-jTw8wuDyRSaPcCc7MU4/aJE48cZV21s+B0A2uDyiypM=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-c2X+tcXVSqODjqAvX8UsUeSW7A2wXkmQfW8cFSrU41I=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-NUlTEskQdNZjErlRoQY7CPWBW/8nG2gg2rTtBH+5GoY=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-v44gkaaZdRojEVhsCib0nm7m7TBauF0NUIc/dH4ny6s=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-wtIerwq3gi9HZm6NkTqK+Wg6L9KasOn1iHnS26nNaz8=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-nfRluVWs3BWMDKZjjUWJwyvirG4o2VBvnHQ5lJNkuV4=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-oBRGawHsresZhgUk7tM1XuLIbQNdBx47byuiRCpCCDo=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.2+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-cZF3p0sFqny3rSvE6W9WMESasmKpnsDvpB5frQe8dFg=";
            precx11abi = {
              name = "flash_attn-2.8.2+cu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.2/flash_attn-2.8.2%2Bcu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-D4QONs0+Q+EwBNCslXDbwz35YjC6fArseoYEEa/X4cs=";
            };
          };
        };
      };
    };
  };
}
