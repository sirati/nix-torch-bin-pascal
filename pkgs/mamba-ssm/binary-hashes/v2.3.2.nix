# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/state-spaces/mamba/releases
# To regenerate: nix run .#default.mamba-ssm.gen-hashes [-- --skip-source --tag v2.3.2]
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
  _version = "2.3.2";
  cu11 = {

    # ── torch 2.6 ─────────────────────────────────────────────────────────
    "2.6" = {
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-4J0Bja3sM7utfEwTJPnqMb+I67W78i/hjC93QPnc8VE=";
            precx11abi = {
              name = "mamba_ssm-2.3.2.post1+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-7hRA3I6kx/oLdZ3WMIKZK3RM1u0Tv9U15zc4dtvIUfw=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-MVbUjZ8dlY+MMjXzTsuxgysLpbCs6UNsWy8FG0uff6U=";
            precx11abi = {
              name = "mamba_ssm-2.3.2.post1+cu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-tiMI6TCAg5kEt4ZGBXyXtDdnzboBuGFlUzffKHOY4ws=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-MVra21akFgxV+RNWyXIgY+OtBoYJCTTOSjEOuw9oFW4=";
            precx11abi = {
              name = "mamba_ssm-2.3.2.post1+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-++8IkmdVvCMq5uDSZIdsOW646TblAK5uCsbK1EuGmZs=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-CMUGlu0YIQJL4xrKc0NquE4XSNRSVPuBIkYGCb7Du90=";
            precx11abi = {
              name = "mamba_ssm-2.3.2.post1+cu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-rPaGTvvNdJ38t/1mycxdSnNi2MJFekSuGBb6uQx7RL8=";
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
            name = "mamba_ssm-2.3.2.post1+cu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-6VNk/MWOx4qciikXLqGMmVwAP081buYcGiwkUDGl+TI=";
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-i9KojWemaVM2ob9RyQr6xaQIOjiRxuw0Lb1CyjrR9Tc=";
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-+P1hlcOB1GqSm0Y2T1nNA4LEH3JILMCSplD0ml9PgMw=";
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-HhYgy8lVKpXOZzFZ7goInk+cwQiWK5n70o2VIJxBZ+I=";
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
            name = "mamba_ssm-2.3.2.post1+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-CRe/Kk95ppfuMGrMg6rfCwdigkLkXmq9I/muQCN70Vg=";
            precx11abi = {
              name = "mamba_ssm-2.3.2.post1+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-sbTKXA6m7+uqK/QVBAwJbTsK3VgHdrVDhXQZpL8tovk=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-CQh4UytCS9fiXPDZbHFuqQOZjBm9rsFjYOfo922fn2s=";
            precx11abi = {
              name = "mamba_ssm-2.3.2.post1+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-K144u2VdgE+s4U1TimMwP5HgOqYwy0mYxwfdsfXu1oE=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-pRY4Hex5sDLJ9kR28GGJuEvbiGWh954TboM99bxthmY=";
            precx11abi = {
              name = "mamba_ssm-2.3.2.post1+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-rzWrD/Z+NFyaIdGhXaAgSKv0vzBB8qjL4RYR1+3jRHA=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-yHvtMjNbF9aRGrU2lzZ6217evyfnUxx6L8fYlLgVHsQ=";
            precx11abi = {
              name = "mamba_ssm-2.3.2.post1+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-jHc51lv2R3Yx/rX2mmyv4geqi2mEEcc1lN5BaFAsFtI=";
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
            name = "mamba_ssm-2.3.2.post1+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-HZvGtAPpUzLEgV+hcY4ZdlodHGgnGHVcvUKtgr4Mbdo=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-ggQaT6BFNsoGq9BapFB6NyK32fwc/BoXo4c0Qj3i0Zc=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-czUEWIQcekruK6IyMNDEkkeeXqIgXAfr9dkK/Bja/bM=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-YvBG7II2JFBAZrB3l2cwRB157KsAReRv0GFnM0Qho9E=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-l//wrMWbJCrdvtim9LGq+sZ1612kecbu2oAgCzMguiM=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-dOvn5CFOQetfGXXOIuomHPKfUU5wJesBpXIBvitML1s=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-LxRgGYVJGRaFPiHciEKkDIxZfZOeoKg9Wgd3dtr+8OQ=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-KFuGcDoxk5akNAobYyUARJ6rR61SFMPlq20qSN0I3PU=";
          };
        };
      };
    };

    # ── torch 2.8 ─────────────────────────────────────────────────────────
    "2.8" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-IiQ6nZGYBC58tydpPyuyiZSenOHjrlopCKJrZlPx7dM=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-n1sWb4DRcyXjg/eU1053xWhdgs8HSLaawaP7i5+OoHc=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-kYG0dTGZLrGQ2QEzppq+tLua38n+3URCsqnIK/tWONo=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-QTvaF9pCIv2jUT5WgUqYqQJrzxvpUZG63bhzWzaIp4g=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-4Kah6Y6h1sJV3Xb0VJGpCKTebAfdULk4mezB7cmk4t4=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-6r0r+t7ajuq2sUvetEhsys1BF0wC/8G1J4CNPit+Gew=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.8cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-1cBzF3uf/KT5r2bPIpW2hukuFAGhQyOS7Jz12DuHO7I=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-m682Ma3t5nJ9JaeBgEOUcFKXeugWY7ZJ7/gcLDo/lbU=";
          };
        };
      };
    };

    # ── torch 2.9 ─────────────────────────────────────────────────────────
    "2.9" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-nndfPoq1LxMVxUXM3chTWJrNgLuzGPPuUOGonYL5U6s=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-yqBlKSKboQq0YNlB4KUG31Ih1jjJH1rpOqm+qEUsBz4=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-pODwGv9Xs6sbKmGkG7h0vT3ye57JXXKq2Y9RsvfgacM=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-qlRgyWB1dbUPpmv5xW/g9OyUR6zWn5JsxcijzjGnD6g=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-FZ9EvxgHRD+anTnuRsHFdbDdVlGx8jqcbUoAfQ4Rz2o=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-j9IQhdZoo727H3kDyB9kQ01+0sdjJA+DKKRlpCNwp7Y=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-D3kmKSYC2O/DW5GIjUCCi30hMq1ENfvsBqTQQUmPsRU=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-cgGEkUb7O1F+Gol0HEBCWWZS3qJPRKlOSoPmJGNT9J4=";
          };
        };
      };
    };

    # ── torch 2.10 ────────────────────────────────────────────────────────
    "2.10" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-iny/SZXH4I/8mKO1WeRgbKyUTAnUcbu+zvFnZyWYrvw=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-t59eYMX4mWkChrjftT/uW/QTCY5h2VmIrEsKO2xWtgw=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-nhQJ5JmOwBbAubP5gVtRL9wFcYrphCtyratfH8A/YyU=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-WdLv0LsW+cIrDYzH+g9v7wRr74+aLGqMii/CIYoyGKU=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-n9gNbnXRMndPlJ/7SIMsi9jGN6x8mMnmJqOZ4tHXur8=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-emcHDB5+mclavRMZYj8EToobP7Rvd0v96pSfCk/Hljg=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-52Dv47UG502z8KWvUJOvmvy0uAVSpUevwcspZTWsOew=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu12torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu12torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-0FjxaYPXaLrstr1l9GoY8o8nMHnCcazDxJVfRXuucT4=";
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
            name = "mamba_ssm-2.3.2.post1+cu13torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-Y3qVuzZ1sWzAGNy9ViWMMVj1fHnD2j33sMmiBk8cozw=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-RE+u7nA9a1WHexHdzStYc6ShnfDTIr/avJ8SoNG9vPI=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-eD9S0xFMIMxwVXJZW37DA6zZlwMKC/JY9BR9DVIG/5Y=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-F6hmJfAh3slS4oKVvrB23yvSwtUkJ9MlXSDY7DJfj/8=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-YU0BJozSuWk158No+6PTYzGERE/Q1KWrcotjps517qA=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-0P4oxUGCfKo9PwH5yMVVN97hveyoFdmylqviRDsdP70=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-WJcB4tMOWWaufkNLWnAI1vOER8MlU38/bdQUOmq1xoo=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-PWi94+IzaFxqZSCWUNuUcKkpqDovT3lN2PK5q+IDyIY=";
          };
        };
      };
    };

    # ── torch 2.10 ────────────────────────────────────────────────────────
    "2.10" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-jtcibfFW8U9DDrHnxuZEjDk2VTepEjsFkClOtfSzAeg=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-ctu7jQyiTVlMFPi0inAT1Al9iGjb9q9fAgTb4XZuGa0=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-l2X3tNr+rtazhBDqG4sPFgvng99LJBn4TkPcAHWFHQQ=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-e6zZ3s81nhIv3WExw1kbpdgfzoZgJzL6XjBCYnSweYM=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-ky23q2loS6uATLj8AknWrHJyltU6FA1x9D4sCX/xCOQ=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-AcsW92PVgkyLjU6qCtYHRR9SAJafG1EpbsiP639FHwU=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-ILpBhquV76ADnsjiK5iulmVImh2wOmKKipa9UOtg93E=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-esKkunumJHhimMa6GEzE22zgJwg/LBTBQppKLAyyxM0=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.11 ──────────────────────────────────────
    "nvidia-container-25.11" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch25.11cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-JRGNCZvf0Kjq+IQPi2Azw9Y5BH2juJWVaZTVD/SMb7M=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-n9ijmBSaYkwev8c3AuDpdfM2oxXmoPyVFhkvASEoKDs=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.12 ──────────────────────────────────────
    "nvidia-container-25.12" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch25.12cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch25.12cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-/ef+0B7rLAZCI8/JuTnfhZLopUcqAgL8LjqOBlGKLDw=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch25.12cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch25.12cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-aYR5jJfpEQr2QwxdDsBvsJTL5i+xMXkGGL+/5dYFTx8=";
          };
        };
      };
    };

    # ── torch nvidia-container-26.01 ──────────────────────────────────────
    "nvidia-container-26.01" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch26.01cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch26.01cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-aSGi2NTnwVR1iOmhqFmoOBeZN3ZvHVVm7Tlw5KiM6bc=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch26.01cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch26.01cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-wKROvtJ2wm3Lyi2pLM6RXIk33BbrL1GG1LP14DFn6cg=";
          };
        };
      };
    };

    # ── torch nvidia-container-26.02 ──────────────────────────────────────
    "nvidia-container-26.02" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch26.02cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch26.02cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-AI4x9MPvSLycVT2L5wdLAjpmdKCka//DCq7rQWbEqNk=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch26.02cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch26.02cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-9k5eHzfjNk0dG7puiC/bogiUTVUOsxcfI5qsBxqjzF0=";
          };
        };
      };
    };

    # ── torch nvidia-container-26.03 ──────────────────────────────────────
    "nvidia-container-26.03" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch26.03cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch26.03cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-JHBEQ4F+VZnbPhM1qsgiIw5sZ1U8t/QXiP6OqGY6w2o=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch26.03cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch26.03cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-aQ4ONG3xY7STey50pV2NhDuT48PVITP+cp8dPoD2z+o=";
          };
        };
      };
    };

    # ── torch nvidia-container-26.04 ──────────────────────────────────────
    "nvidia-container-26.04" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch26.04cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch26.04cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-Qd+pmyaUHvhDDk01ZpPbzdRFCA0s0mCqHnNIZ0GFjjA=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.2.post1+cu13torch26.04cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.2.post1/mamba_ssm-2.3.2.post1%2Bcu13torch26.04cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-MxZb9WhbhmtMd1aqHwFWM8ylYyBlTEXZKcuA0Rhtxfc=";
          };
        };
      };
    };
  };
}
