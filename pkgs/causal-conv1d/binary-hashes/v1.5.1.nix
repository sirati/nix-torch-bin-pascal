# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/Dao-AILab/causal-conv1d/releases
# To regenerate: nix run .#default.causal-conv1d.gen-hashes [-- --skip-source --tag v1.5.1]
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
  _version = "1.5.1";
  cu11 = {

    # ── torch 2.4 ─────────────────────────────────────────────────────────
    "2.4" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-VWo2Jr6i8LoUAcSZWGbDmBq3/e1c1IbSZGCeeS7jT2o=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-+yyfWTse8SDe9bmGJWsC9Qvy3oVXujYg8uIxhPE5G3U=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-GHJ/ydJBclRspyGo7ZPN9sAiUoPdwKZ+kLDUMrpXg2Y=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-ck5gT/NlDFZXb3L2N2YbLPYbGwRINvAhsCROhy4emfg=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-q1uDRwmkzADc4tCRSx/yZMtgpUQGxylKrcLlnZv/nX8=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-JW6/MI/KLhvwCf7V9iZW4+VxWSXE3cbF2iKEtAeYVYA=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-y/Sc6PGyko4gR1SL6hXOczKirOeFENz+s4KHl3HmLVk=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-cdZ0Euno34H+UEwzQb3efV+iy05tfSQ4zKpVRNUei9w=";
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
            name = "causal_conv1d-1.5.1+cu11torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-8baJn7jzP+mOWohDkjDTUxnPIrVb1f8ScrSoSRJA5go=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-DwJajpl2z4hb7+FUqITYlKaBhItZm/eeJ2WNPTAqYCA=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-8FRtk84hXwcsrDGTEp6KnE8mDmnpl5gkaPJC1bJbXVg=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-ce8+HDrmblEq5LTAZiOXtiWOdnjY0tvGrM2shXdvTKs=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-Zo5gj+78tlR7InQNq7lrWLBAtjdv5kwufCt7iArZsu0=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-Kn2TWMdZYe4aVUtOeeQkG7ozRgOfKlmzHXxSNJaiNgY=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-5MX9sqzXd4mctDYVbuSYR6K0nLOLDsxQed/V8fYcLgk=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-I0iqffY2bHj3xe06WLsCirl2dWpYL4xXBWdN6hXtisA=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-Oo52+PXiMSa5vAokvnDQzPTVJxj1/+c3P8FIX387Qg4=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-xGs6A96zmpHLHk+rAkRjGqs/21SqxEwmFp6hXRgf26Q=";
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
            name = "causal_conv1d-1.5.1+cu11torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-CE7a9H4+3b4k3xcLQ9wNoPGnMI42JiwqJhIEIxHk6wM=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-/cK6BRS1/6/WY1QcSSTGeeQ2JaLgft/fjUS93drrIhw=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-N02PzRS6a2mj6qwUhQe//j3geIPIOJGO6Mnuy3X+SOc=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-IGXfOP7I6bvtc6scBhrpmhYqXcEu6ArJNng+QyyuXVQ=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-HWsbCK//WJp2JNMq4F22snma1WZOGaqiR1X+cf26lwg=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-HLZRMfqi3+AqGC8dIv6LgVu52b9adx5Vtpxy13XISSI=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-uU/GUZUcFrAZCUnpI86zaRqCa6dfSh3Lx4laYD8fh8o=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-8PS2C75nqMgNcgGF7qccDr2WRT9eYSQBAkD5Jf8XTmM=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-PJkM4yeXJGPplSTOnpKKZgKr3CrL+QYs6JOoDx/HhrQ=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-RZp19NqK+EgiQ8hwLfV4qeMhQBgEgFyvAzjE7r6kTOk=";
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
            name = "causal_conv1d-1.5.1+cu11torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-bq76L0o9Quk7MvF6TFYjUkBLqpY+UB6omk7AAf6Kz84=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-XU8x3CryWyjG024QArsUZN60iuMcjlqDBk5mdvmE+xs=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-DgwgjFADoK7UI6XFyt1anohSLpARaavl1rRqY0NwpJo=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-DFwNbZ5x0QQptZ7CrOls+aMWOXttuqKPp35+g8dFqXY=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-BJIoE2HQ+cFhbLNqDiwgrCmTuuuP21bipvxDCrBjeYY=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-5mHIpruLI8AneEe+v1vYdZAhS7hw2Wl/KqcWa8mev6g=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-ls5mSJWHmXBRxLUwvKgjYV54RB4tTk7yvVLvjUBVZno=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-eDvxMTU5A5Vjpiui6OwHENlZiMurOZWmsO9x9pr4wVE=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-y2qouMuug6GCFaTXqi83TW3vOvmRujsyWB1MyFU0He4=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-eOwnB554C6UTGKEjQyag0nXiasUF8M7JXvZd5HePzzI=";
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
            name = "causal_conv1d-1.5.1+cu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-85OEn174cPLFiGK7nZ6RJqMxfrTupZSggIBKzl2irMc=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-o03bKxMM4cFN00EjgpA24Fu5gVqAPqPxRSKrQIzFIc0=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-tuIUcIX//A3rRyEv6ITp5OtxniCCix1Zhak44050GI8=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-rMxhJki86kMxlC3bpKGE6DhVB4a09UwSxBzU2hnKBt0=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-8t6Za4cUmx7pK82TAtsVG2QqzQj1fF/HzEqTiGr/0YQ=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-s8qrAOFo5s/+nAr8BvWjLLveUkJVa28ngMvtiY3nqdo=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-KvVznDsUm7rC2EEXQhFli29HzmBDon6gcV8wtWdAxQQ=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-lH+nCp0WBcYDVpmH4mWG45CkSXhJxrAoqqJR2aX0dIE=";
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
            name = "causal_conv1d-1.5.1+cu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-YmbPf9atC7NnpYMXWbLfwnz4di+TVSqYmDXZUjkTP0U=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-CumasT6Sh4md1ILxiZqhcN6vn1TV1s6LBFDmLwzYWRw=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-4j6ENgzDAWdOlSrOhI7Nfj/pkQiYYudv7fcVYGQAclI=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-IRsJB5htxh8sEprxdI4eyl5oqUJOnsjKYRgEh95Hn5w=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-a0H3EDfXmZST/FyIR4QdZ+DFkP0LcaCIto7YJOUJblI=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-hbprn5I34KQRXSAyPo3gxx0Ml3HxaGlhfGwzkBZolH8=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-bxw/PAe3exvcYiRgMfzdJZOVS/7aP+29ElFxVMEawzY=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-NdsYokofar5VuuOfHv+EpFSqGgZbu2vBxRp0AQxg5mQ=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-KFRH/hibQ24mnVp8rPw8gY6jC12oyLNU0TzjImMkR0U=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-L5xg3V/HFPGLCPpfV3zqd1jrG+quRrNGkLiFiZvLOAY=";
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
            name = "causal_conv1d-1.5.1+cu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-gjYuDnJvDleJjpKxwg0zJcKLDXUNdqvPAcwpimGl03Y=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-+n61aoOX5Bo3VpHlb8RtaUeb1uqsgw5WAExhdgsJOpY=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-vdSJrpJYaRusRn4dNopFSWxqRKIiOjoXzoLQOxQeU/o=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-g70gBkYZXs/3DjotS7bE8nFe5fMVzuzDCa+Trm2tZ30=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-XhAlp/wYYfkFQn8DhD7PayIc6OvR/eAyXNfjL6snkWU=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-pVt2bcobcb5jGpnPl+hLcjp0LasOY7WuPbqXfPHaIpE=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-aGkMDo2R1OrWKPvz1LY8Nwgvcd6zSM518QaACgbaK8o=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-jDzs7oSwCvO7DZrzUBIPAP6dc5k8Rob0EGpvwQaQIr0=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-1zZcqA0n0/Vc3c8NIN3MIWgKggZoBTt7PFVvwZ3jtAU=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-R1CIYhnVIoURtQ+u6v5C+7PYM3BYL9u8N8UH2jRAzJ0=";
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
            name = "causal_conv1d-1.5.1+cu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-P6LJowI9KCegBGz5lnXAeqPqS6h9EC1lFtAyD/+tO3w=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-oNT3px230zQApSVWgKTJYGO8DcvB/b378d7xATbqgus=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-h3IFT9HJ5qfKEwIr0xFehxrxv+8bhBIqKH5qcmNU39s=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-rMRaxUemJHmYp5Oa/DhjlIEb3JM794B70fT4FIk62uk=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-lzNvas/4a0nB+/iVLjsTpaCCch2ygU82NLdI3G+7nYI=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-IoghX+7ZW/BiTQOoUgZw6r5bdCa1zzprtBv+qrW8a/M=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-QWwCLsvF8fnfe04OfVPzZP1XvRm8A91PVHQObs1Pw2A=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-X+RSoSe4KCFRPNdLVm5RSFzzlyvgq4G5HX1y1Z6u7u8=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.1+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-gWuCWmClAA1AhQmg+xHnDyaXEfmUUBxBpHhQsJubK+A=";
            precx11abi = {
              name = "causal_conv1d-1.5.1+cu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.1/causal_conv1d-1.5.1%2Bcu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-WqeBwlJY8hIAR26xuoQVocaTStCehG7Nl0CS6PG8Mlk=";
            };
          };
        };
      };
    };
  };
}
