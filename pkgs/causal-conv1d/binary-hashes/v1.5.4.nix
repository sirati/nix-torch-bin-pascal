# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/Dao-AILab/causal-conv1d/releases
# To regenerate: nix-shell pkgs/causal-conv1d/generate-hashes.py [-- --skip-source --tag v1.5.4]
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
  _version = "1.5.4";
  cu11 = {

    # ── torch 2.4 ─────────────────────────────────────────────────────────
    "2.4" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-XnhqK0Wt2DeUCOFjYp8FFZNUllIUJLeiaQDrQiiwpHE=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-/UjzmQdihiqmIqKKelErICQ4x5Bkb9BASZRfYAd8YBM=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-NTenqB4zHVJ8yILCls6cuAmq+Q6suJqSKCbCk1DCvzw=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-aRHLptRGu6YJmmCNaZ0FCtgwqfIBLRl4Q7KHODP9p2k=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-JOL/aUJxqVFpdsacgDoYv5y5NTiwGFWOas/v1Me6JPU=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-lrnoguRtjQxHeo7xwE0toIx/77mLVeMMqwckk8xsMCk=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-AFHQk5Rk+6F4dONXE3R+m4oxvXwI+k5icah6llpct5Q=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-EkeHkVnQ9o2ktirJFoy0ntKtwfhGwpAqhYgGB7Jys14=";
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
            name = "causal_conv1d-1.5.4+cu11torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-6oiQE/eSgYVVkpUc/7j91MBMeYCkJqSllK7p4/5ndOY=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-EF2iZiXEFwF1HXUL73teyXc7ZQkolYBj5vl9aDNfHXM=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-z/xDHjAfUCjorH2V84W0ivTDsanXq87//970TkwpZCw=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-Q95aE4C0ke+ttWEQKBmCp3yZb6WVVGrnW5TmiOGYA7U=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-JDR1RRCJAPaZpksEso5BMGqxkHtQuhVtKGiStA911Xc=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-dmnJAmG4RQHyOdQhzyu0me9by2WzO7Cb3X+81h+S2UI=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-NMV1wIVKnytQIlqKcuLOngKzCcfYXK4STT2Q/czvkSU=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-3D5kWze6NXQNvnftE5rYFqMxe6jsfw/xOenkct2MfIw=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-j91WQkGkbnBWBQW16RuI/VeKbtZfC5cfHmLNguEpPao=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-tfy1phFioMHQaXtXDRN/PzyM5caw+fyRygxXNiboBMo=";
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
            name = "causal_conv1d-1.5.4+cu11torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-UEqyAAbxXHYddUPASGQpAstZjON7BI94UaskKvCjVKE=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-MSt6HFIMzgx/G7EGkkIfubYj3E5eWRlbMdAiTNYjTbE=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-3fZ8+rXVmW/7BxcJ6SfBSns01bhdd8ajitcqQLiyObI=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-Lnxy8hlBkw9+sO4G8QNbVM1GYJHFm2RPo19hOMBvV/E=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-nsmTWUUHm6oLkulVnZp2GLwIlutP7A2c3bTBu/83Ti0=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-D6S0is4wFqBsdwwAJePLTJc8TEyAZypvhlOhfrLODr4=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-mJrAiinesZVUb9rxIP/t6CmXcnHbcpBz05im/4lyoFI=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-y5agEibdTpV7sagP1TMXzXa11K6mWqqa64ySibbO6e0=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-Qr8A3n/vPzP5gz90R05vw7NwJURZPJUlEKWwjb7jrqo=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-nwtB8Hshgy3tn0SfgNz23q2sM3Lo5OIwWNsb7OK95fY=";
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
            name = "causal_conv1d-1.5.4+cu11torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-RTnstG/X0jvUE3XtPbuhY+KO27LoQWYqfLEZddV9LfY=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-qfZglUA1bE99KRI8gDnJIwWgKy2VteakYDnhCT7Wd5M=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-WDbQ7CQ7fR2quVLhcHxTeNPGve7BRPGimBMeJnE1Cjs=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-4e4OkWaEtX/dRmiqEv7wNEsAg5id0GPVB5nTc2i76hI=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-+g9ECRjQFlF87Q+VhkjDc8FHycANF9Jx7x/1wnmtGAg=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-WyY6+2iId7E3pRE93zewAYf51o8/bCiRk7S+Rj6fQec=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-r9aFsfSLF68vCpwrUK6EBw45a9xMtOfZRbGFGAafk/s=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-oB1MJYFw2NlbQ69PRF20D544XwSGtGEY738NNHx0JAk=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-jgS4y7m01HNX/Lb7W58TeJ3wW0KlwZsa6ipH27IULGo=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-hHYTKlrCbypjZDgApAH0CAbBRQnvbyuWBThKrGn1Z04=";
            };
          };
        };
      };
    };
  };
  cu12 = {

    # ── torch 2.4 ─────────────────────────────────────────────────────────
    "2.4" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-bww/+1LgjDY7IE69vnhU5RpDZuoIcrD7cqm0QFN4VDA=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-4siS/boPpfnUe8HEcwkfrp5rGJshohJY10p60rhLIlc=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-1r9NDqXmEKG1J0+4TEvBK4pDzycSAhzXxsVGjOF7e/g=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-lHaCfkM0oIoaVl51z+RG5VSGkDkRQiqyC0KbIiQaWjE=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-60xMwWnFuHZM1HF/uVIskwDCBPK9UM/aBr5ff7pnVeg=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-SwqBghFzW3wH9fxBMW9kfXQuvr1ETreDs/s9Qh218y4=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-GYQJ/jOZ1j7vtZl+QE8AwBs79mlEG16gxCyrttFyUio=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-pBhlaMBtFccV+n/ZPE+ObzKHLztJiCi2YdCl6ma1GCU=";
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
            name = "causal_conv1d-1.5.4+cu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-EtKfZWqdy/qmmVaCEEuu0KDQIpe79RAQyIYyXXNCRnA=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-xTrz20sTv9PEvp3CzmY8SxwA5A8seIcPPPC2+YJDPkc=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-VBxI7eVwlThQgitMtv4Imr7TqAPKlVClVRvdqrfw78k=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-eALn09ECVPOJIA75vc9t+5ECAFbK0627TQ1JyhgfsHw=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-+JMEVGicr9qquvOnwo9lpJZYA6PwmvJ/qkPCJDR0m8Y=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-pmDBTog7cJaRcXwJweUrMtl8nv3ywuU/jcfa65SnmhU=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-zWLXzVwGmKnbH8jDm111NXm7oW9OcgvClp+Pzex4YZw=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-jTrSQyZPyRxa4+0hVb37DQGhlMHy/XxfyaQim2V+F78=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-FDTf1JHahqfRnKWO1wOQuIXyPRGcgD2x6iBxM56BXKs=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-7hN8PGE7nUN4yhr213ImG5GHiYHzPKcQP8qCZKaADus=";
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
            name = "causal_conv1d-1.5.4+cu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-zAsCitt4LOWdtOdv1zC8ZqLVlfApNUTCVRnRVthVI5I=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-sgxhkoBb8NFLO6rIjgSlversVshbcHsd/DtN6323MvA=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-d2OBxxmqyAsW72WYuSMZASP67WWYUowvGW5llsq5qfY=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-c8o7OAEQGMb3fkqt/yuO44JfhS9N2JMHY1ZFitd5Z+M=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-5EPIyeO4/hZ85hbLqA9iSv70tJFErU8NL8V6DntD7b8=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-mEArNFqpnWawJuApdCi5dq49c0Y27p64AI5KNNIKbgA=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-TIb10j6O4pwj7r4fLK0XAsyTMsWROP5BmHtK/B7MA3c=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-U7CjLTqQYqw8XIWhwSX9kxvM40IP0eGYOsbkEphunzc=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-k56aR0mWj+vNFOEi0dbav3IiKAjTeVB7FqwOuh8XdJg=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-TFCWX/Pyq4aPXSox+9Q6cFxw+zeF1Mf6OAFfl1x5Gac=";
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
            name = "causal_conv1d-1.5.4+cu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-4UWkqWKniqVOBH1HRg8HwAOjgXmIqMKeVv//d+ihJ1o=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-Ysk8cTnOG5Wu2vuxgSk9aU4/PdbGtJQ25gYJiMIKdb4=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-fBAin29R9YrNnxY6rAixlHxfECLI6ce5a/60IxobnWE=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-3i1r60KVGrYvsEWTPxET+P+POZHMJUy33x9EW+kI2H4=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-mWLfnt2w4jmsmbe0eRwW7SCBWG28AmwcwK+FEpgGuMo=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-z49oqiY36027U+Av/Gy1RffW4Vdj9tQDeXZ2ODqRuxc=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-DjuWWs4Mso2qQdaNj8qr1ydH55vPek/NNRRgHqeEA8g=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-2ym0PrJsBTtUqaIkvHLrO1p19zwzvT8Yz/+UFVd+S20=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-zPxa9fz35/LYaZTQAHc56d/hBebD4EjdaN+jJKtqPMw=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-vDQ07w1hsncBdq8iwszZjytjRwihEPnvBh9T5LRiwAY=";
            };
          };
        };
      };
    };

    # ── torch 2.8 ─────────────────────────────────────────────────────────
    "2.8" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.8cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.8cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-WNYjAurSuqdKFvbe/maz0Sk4UKwmnhHhRThlDdMcS5g=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.8cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.8cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-A/nxleIs1j+mv1a8KBEPuBAUsA8bJlCwoRTdVXMN2ko=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-tDDtVec50XXWkwuoEbrBXnAB9GXD0FK8U1Hw3xYssj4=";
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-fzq6DygaKegj/N9KTv4Sjod10fLOspbkz4ndgO2nJmY=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.8cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.8cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-v8cxTRCsjNNnEDzg9VWrMm8wa256wyJGve8gNP/sEmE=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-xiM4+bOpFNeTJuD1wSc2HW1/it2H6JbQG+uCkclap0U=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-6tTN6CC2S8k3F8vMfmstGny47hgRkOr5onoCqfBpBzI=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-x7Kx9IVtJ3Z5Kq9sL8b1Qlstu9lnkw4T2rBUuIludzw=";
            precx11abi = {
              name = "causal_conv1d-1.5.4+cu12torch2.8cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch2.8cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-unnao3IRjEJfu7KJQXJoOXLLtRlc8BZf5Gn60SO3K9o=";
            };
          };
        };
      };
    };

    # ── torch nvidia-container-25.04 ──────────────────────────────────────
    "nvidia-container-25.04" = {
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch25.04cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch25.04cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-ISaJE9O9jYh9wVdhouscZOikVHXqdhX+4vn9naKES94=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.05 ──────────────────────────────────────
    "nvidia-container-25.05" = {
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch25.05cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch25.05cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-GGRDBaHIfbIvxDO+OSt4U0zbiFQ/23iZ8GFaHZxoXAo=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.06 ──────────────────────────────────────
    "nvidia-container-25.06" = {
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu12torch25.06cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu12torch25.06cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-wL6pgJ8/YKRHXCN0vvReSYDFQ+XuD+xX+xyk7U7fEh4=";
          };
        };
      };
    };
  };
  cu13 = {

    # ── torch nvidia-container-25.08 ──────────────────────────────────────
    "nvidia-container-25.08" = {
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu13torch25.08cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu13torch25.08cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-eMYzEP6KwjWB61W7AG58dNbEufiezPM9RF7ZbqmqELM=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.09 ──────────────────────────────────────
    "nvidia-container-25.09" = {
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.4+cu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.4/causal_conv1d-1.5.4%2Bcu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-/sR6EtmWIF/zOmPuTLQYosBYCN8GWeya0wRofPOET+c=";
          };
        };
      };
    };
  };
}
