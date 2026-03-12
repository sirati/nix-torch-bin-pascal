# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/Dao-AILab/flash-attention/releases
# To regenerate: nix run .#default.flash-attn.gen-hashes [-- --skip-source --tag v2.8.1]
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
  _version = "2.8.1";
  cu12 = {

    # ── torch 2.4 ─────────────────────────────────────────────────────────
    "2.4" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-kJZK9L5//+iDh8k36boAKitFFaJ0/ztpjLRI/ZakCHs=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-XfKZSsYB8o4IHCwfBxrT0LnnEglU90ckvGoHodCsIzs=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-TJLwApU4EVQ6nZqBTaRTGtcFYDd7jpyWXpcwTYniNQ8=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-LMwPfa896zb6ldJEzDxySL9kisCvHdjI+UVmF77mmb0=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-RI4+n9winGVsWBzyVjEBuN6H1HsVTyvneT5o+3tbGKU=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-o+Z47BPRdmaSMrNKU2Nq6ORTe34ARtFZj0oxaOA1NZQ=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-2dte8JFpgHj5ea/GyesBt0tBpZZnBtxtq/XWCdz4SVk=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-zNncVQfCRrRpn+saFiUscEJkfT9bt6pjqWhR8FzEPxA=";
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
            name = "flash_attn-2.8.1+cu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-XNIOmnbHpvompNLnBxlsAkqIewvpB4UY8yeAtBCieYs=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-vH/LQp1nZD/LG2wLTeyJBdOTZU7gY/lnvFi1vJlJ9xU=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-5tjc77DkNYFDz2pJzYB/4MqtpuF6tpqmqBw0j6oC5PI=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-9JE1TwLc+GII/UOuyqWIj9f7wr0daA8PPk40FJqb+lE=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-JPdf58ThBLoFZoaasNJMu/+Y6ZzNIyR2Dq8R1RlbpSI=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-5/DEtaBoXBXkSaPbf27+JblV1rFT0azcMgixNnOFE6M=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-S0lFmhhsRp7OOLVvIKiYEYs/R8UyyMSwnT9y+ZwA3Sc=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-2+1hkwoxWvGl4tEM8tW5bnAzM8njW2VKVs7oqDOBhgE=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-g/X4vYK4U9cHIdJnfBY3JxYozxJeS00yBrocHRerNik=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-LbArCZY2yowRKroyJaQXHWyJWtPY2iKQnz8WzpJBYvg=";
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
            name = "flash_attn-2.8.1+cu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-yOtnIUhmbBMqYfm6MOVg43WybxeHAx++rFQw3lE/ke8=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-qMU+NysenjmCbkn/BIGyTJYQP7zqckCrJfHk+UGUkJs=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-cg3b67H19LbGBteLnA7IjV7cFix/dQE13Jm0Dxlqko0=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-3d1XvSW41VigblNXmfWifYoCHN49ZGiJm7Iqp1l48Os=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-cP8KZCKRCb3Rul3dpUK3l0c4S2+gv2+aWjUx7TuX2bQ=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-WjMOUDisqiMJVQEQcxulgJU/dtRFoC2bDYiQbZeDHbE=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-hDjjq1D865ECXnfKPy7NI982nU5dzyPqvrnQ4Zzeh+w=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-R8VWB++6ds5p5a9y3sMF4xD2arxneQes+ehhNMKbzAY=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-jt/JrK3xn8dFAzyanAu5buQVmdt9OQqsVKvDc1VZgko=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-xpuIvizsWDu3ZIgTtDPVlToMYVpH8DmltWq0blJf6rk=";
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
            name = "flash_attn-2.8.1+cu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-IqJylSbxsuVCFt3vg/1+eXauBN807t8X3C8mTI5WdtY=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-j9t0gyT00PfJBy9P0oZRdMDnHIPB4g3vqKrDmZF6Liw=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-TicIGln9XebOHZxbVCiKj1kQryRTtsC+HDq/4F7PfpI=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-K2B6xQP1kT9K7NYkCNB0WtWvbsxZ1PlvkMMNP+ep6d0=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-J6bHl2cN35ch/5u0zracNxPg0lrv9xY16/419dxSAp8=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-2lqkqJj+Idq+yzdyLSYNU9xcWYWwOuBjRKBGhF3RSec=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-TY+EGlQp8bCGDwQQIqbrBuOY7XuSbgF5S8v/iBpGHKM=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-S7AEwXQht3s0sU94ZxDG5FGOP9NWjHVAcoZRe09Q3jQ=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-gpiSuo+qRknkvsfCyAL2mD6H1yZTDFnNIduHYNmscZA=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-wUttWVpzmpP9IAY0b+1KcX3S5sye+MptZK/3K4R0z1k=";
            };
          };
        };
      };
    };

    # ── torch 2.8 ─────────────────────────────────────────────────────────
    "2.8" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "flash_attn-2.8.1+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-56I88+zH1+BrT2m4O+3muz6e+NxfXolGcYIqteAYgDo=";
          };
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-VTMdeXFxlzyLq/K15fzl94hZsc0pjVShNuiZQUf+npU=";
            precx11abi = {
              name = "flash_attn-2.8.1+cu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-FdtbtlJNy/KSw8EWqkwvqCO4Cr/w61vFhFQQe8oboMI=";
            };
          };
        };
      };
    };

    # ── torch 2.9 ─────────────────────────────────────────────────────────
    "2.9" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "flash_attn-2.8.1+cu12torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-mdrD00K7ZRrOdfSY1vXy0MoOgCz04CZp8cw/2YbFYwg=";
          };
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-iOpQ2XIAsbC3TxAMVSWujhgnquX9QbSI9Pp0iXJbTlY=";
          };
        };
      };
    };

    # ── torch 2.10 ────────────────────────────────────────────────────────
    "2.10" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "flash_attn-2.8.1+cu12torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-960PqcbMF5T5TgQFAA4DwlMR+4pCy0gK+0Ow5kpaUtc=";
          };
          x86_64 = {
            name = "flash_attn-2.8.1+cu12torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu12torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-9HNhrw6+En24AEDLculH46Lvl8WdZB3wwWfFtIyv3Cg=";
          };
        };
      };
    };
  };
  cu13 = {

    # ── torch 2.9 ─────────────────────────────────────────────────────────
    "2.9" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "flash_attn-2.8.1+cu13torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu13torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-KCC50NZTqWmea/5TE7y6dBuI5FCXNBZGpeNfsCULNTs=";
          };
          x86_64 = {
            name = "flash_attn-2.8.1+cu13torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.1/flash_attn-2.8.1%2Bcu13torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-/Fo2geMh0JLvWK0xViBZkYUGs72qv3BtkL3ANbldI8c=";
          };
        };
      };
    };
  };
}
