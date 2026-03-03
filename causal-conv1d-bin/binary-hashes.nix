# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/Dao-AILab/causal-conv1d/releases
# To regenerate: nix-shell causal-conv1d-bin/generate-hashes.py [-- --tag v1.6.0]
#
# Structure: cudaVersion -> version -> torchCompat -> pyVer -> os -> arch
#
#   cudaVersion: CUDA major[minor] the wheel was compiled against (e.g. cu11, cu12, cu13).
#   version:     causal-conv1d release version.
#   torchCompat: torch major.minor the wheel was compiled against.
#   pyVer:       py39, py310, …  (CPython only; no free-threaded variants).
#   os:          linux  (only Linux wheels provided as pre-built binaries)
#   arch:        x86_64, aarch64
#
# Each leaf node contains the TRUE cxx11abi (new ABI) wheel data:
#   { name, url, hash }
# When a FALSE cxx11abi (pre-cxx11 ABI) wheel also exists it is embedded as:
#   { name, url, hash, precx11abi = { name, url, hash }; }

cudaVersion:
builtins.getAttr cudaVersion {
  cu11 = {
    "1.6.0" = {

      # ── torch 2.5 ─────────────────────────────────────────────────────────
      "2.5" = {
        py310 = {
          linux = {
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-0k2Fio8uHZgyg3VvIDS2hoGhx8AbJk+8r0Yd3CtklzQ=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                hash = "sha256-+KBZ3OvdNsoyqBB4T3R6vd82nQuJPG/dNH0ZYcl/OdQ=";
              };
            };
          };
        };
        py311 = {
          linux = {
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-YTqJhZ9GnZR+pnDYbtwtDq+3FZnHXxd059BMjDm6YrU=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                hash = "sha256-SioVR7/LjNvQz1fZhE7/3dIpFKfULsL1WUVX6MDzEvY=";
              };
            };
          };
        };
        py312 = {
          linux = {
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-4vaitR26px/RS845d9PgsfVd806MMukZPCtJzumPP3s=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                hash = "sha256-jDrsNrnkVa4Ir82tZd/UYHE4vZLkRSRwZ/baAxHEut8=";
              };
            };
          };
        };
        py313 = {
          linux = {
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-raISqLXuVUEJL6q77iL66pNva7tNjeMZNPNPvxaH7dE=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                hash = "sha256-pBNkFYV1L/Q8FxswoocA4Bbm9c7hj2/FjrUP+MPFlQo=";
              };
            };
          };
        };
      };

      # ── torch 2.6 ─────────────────────────────────────────────────────────
      "2.6" = {
        py310 = {
          linux = {
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-p8cNq3mElWIm/dstuIq4Yuh5WbRx5GPVMa609ucQjp4=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                hash = "sha256-4xlL0oP25ZEEPeeuTDpvHMUDD9eu1k3dYTTReZz3K7Y=";
              };
            };
          };
        };
        py311 = {
          linux = {
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-kvFIdlbKIGXI3/e22K0cg+EWtmwLSdzqyvJtIsTF2sA=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                hash = "sha256-27KleajTr8Y1OB/6th8CHwUMZOsfPF3yJFWQr2mQdBI=";
              };
            };
          };
        };
        py312 = {
          linux = {
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-nNN41YrbEc64esFcPjhLcr6Ro47l0TWVC5fc1QBWchU=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                hash = "sha256-Ir0d0lILN20SXhvH1o9v+TH9hiRT0KIteNhRMK7m1uM=";
              };
            };
          };
        };
        py313 = {
          linux = {
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-oVwzTdv2Q3dzFj48K+vUIPtPG10h2sdbvMWqA1BacWs=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                hash = "sha256-a4xiXmnlzkzFo2ccILpEjDfO6KMwUX80lSmUk9Zbr+Q=";
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
              name = "causal_conv1d-1.6.0+cu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-XvfQb8MM4aqowNwmbfeOaXXKLNgH1ICOEPx2S9KfblA=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                hash = "sha256-2No2CjRF3Q9zzcBVNHckYttKn+e6W+4jkCPIyo563wc=";
              };
            };
          };
        };
        py311 = {
          linux = {
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-6XOt6PeOkcM6og2PBDG3ernHppA8gBjS3f/k3le0fBk=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                hash = "sha256-ytPrTJlQD8iJ/KyQRo0bj/z7S+fls9N2QGc3hetyftE=";
              };
            };
          };
        };
        py312 = {
          linux = {
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-6JUAD5Scc7Th97H2MOwuGXsbI1WK3CKzqRqAg9S5PRI=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                hash = "sha256-550altgoNEpXKsuUOSu+Owxg4i1hduIvfTeiRQr29g8=";
              };
            };
          };
        };
        py313 = {
          linux = {
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-ahUhM/YSzJtwbfpMHAgkYUf3bv7z8fbK0s4J2mMTPIs=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                hash = "sha256-zSbPSRVBSXY4cX/LpCeekq5K539e8ZwyMrpFfOMYLLI=";
              };
            };
          };
        };
      };
    };
  };
  cu12 = {
    "1.6.0" = {

      # ── torch 2.5 ─────────────────────────────────────────────────────────
      "2.5" = {
        py310 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
              hash = "sha256-mvvXsIJiD/EHDcXyyunJFwyMHdWTYxM+VcQGPWxcA48=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
                hash = "sha256-SziQ1ly84quXDggXN7Q2VlI0CDwkhqTZqfQcnEIDUa8=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-P6sCc/4MWqPsR4hVxYWRY7pV4/Y/r8en5JwfF8V+Vh8=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                hash = "sha256-xiBp6AYcA7FvtJNfztHgFhV4jfM6rE3EGfS8FDoQoI4=";
              };
            };
          };
        };
        py311 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
              hash = "sha256-oM5R6dWdoENZuoDSEXKHC4VC5y9rqIS6Prtc0tW13PM=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
                hash = "sha256-5bb7P6Vhsu/VF8IaLY9IBg/E/zeCNtStoXVGQtK506U=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-eWandFsAN8RfSq/JWUFUrPALdB62opptUVbtvZu5Z7Y=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                hash = "sha256-732PGdpoZz6aDvR035sQpR5/BVT2WJol7cwohtqHXrk=";
              };
            };
          };
        };
        py312 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-2mSEJjIA0nN3eW/leJ6B5CCQLEQR9btKCMihZ6XSHCc=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
                hash = "sha256-onMdHse7/An0fhv5kU4B4WbCzfAHq33/zMjX9WqOtAQ=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-IKTBN2/5PakbU+iwHsgbF7NQpwBlW6m2tVuKc4aiv+M=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                hash = "sha256-5YCiFuqCErAsSDB0F99FRdQUudZFE9V/d3HDs2x7SKo=";
              };
            };
          };
        };
        py313 = {
          linux = {
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-vbwkYr2SqSW/mQ2+11CpxE5V1sTvQ6ndSfCJJEZuHd4=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                hash = "sha256-DrRg+tsz0ACd3YEul6K4OIaHFXTi22dEl9gexJtuJSE=";
              };
            };
          };
        };
      };

      # ── torch 2.6 ─────────────────────────────────────────────────────────
      "2.6" = {
        py310 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
              hash = "sha256-v4gdxv1seGxibgPuyRyOi4QaK3znQWXzg4iLcpZvfk4=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
                hash = "sha256-igpc5Z3gdiHyLMm4t8erqhKpTkq0cOcvdLzbsGYuGDo=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-Ox67qTLBA9ywGu0RTiP6RLKuCv8yuoy7tWUTw2oQJTY=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                hash = "sha256-Pt7ygojrxuyrR2QhTsiE3aOVL92+DIEHs6F+7/MDvq4=";
              };
            };
          };
        };
        py311 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
              hash = "sha256-+sVdraAOLNJu4JeHzA52l3O5DlgH9NSJ8HPr5Ens094=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
                hash = "sha256-DS3iaSddg8Q1PmGLseZAE2xjttKbzuagqtmjAg8lSqI=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-ZDtmXqM1nd5UQ6j4+/GUjpMx+CfAQLS2sLiHpGZDIAU=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                hash = "sha256-TP9vxZW0BxE6AwgqTcdVga28OwXjgS+xRC2j9niJLtk=";
              };
            };
          };
        };
        py312 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-+Pk1SNCETCJjca4QDePERPPPhjTmEuLLoo4kBrUtSEQ=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
                hash = "sha256-GoU9sWf8m80SaOPLq0z2MtkRoooF3t5VJNQ8K3Ts0rg=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-78fZqGYKuCk5DXZguve6egYrSsKG56SDs5X/GATr6pw=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                hash = "sha256-3eKUhmOWAodgn976YCN4vNc3wg8job72o1/+nW5Vn4c=";
              };
            };
          };
        };
        py313 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
              hash = "sha256-qVYqLIE2o02bXfj6NvS8s+cGkYOJb7PCL5jT083EEC0=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_aarch64.whl";
                hash = "sha256-XDB/NUQKj6H7QNNcqR393eUpiPEEm2iAU9U9IwQGxm0=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-Fafok8WKJDq6DwheGncmaGuqWn5Kqb+3I7WgVNQF/EY=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                hash = "sha256-Xsn5M3Znzllf7cMt4cvEZGXTVrhBkYyPLXD7ug2nRsk=";
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
              name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
              hash = "sha256-BvxEyqUVBmVMQRqKb8G4MkIu8RHVj0iXMDTcHUKPO3I=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
                hash = "sha256-1UWOtgTakKf2Q185npu/mjU2VSmK7IRJCmRi5zs9qdE=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-E5pNWtWdm8dbsE80H83qrMUDKEEF3HGTirggclYkaXs=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                hash = "sha256-jtnv/NTW7d3pZUTLtoLAYnLyviAjTvVOGdSllFyk1dc=";
              };
            };
          };
        };
        py311 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
              hash = "sha256-2q6HJ4JqaTx4+5/V2ZvmXYK8hMATYg6bapf+JiV9amM=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
                hash = "sha256-w93g4vlNTAdkudomo4ASPVUeGH9h1tXSpeYByxmRIUM=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-mUKUg9K9PC9kI8mqPLek1N0aob6UhMMtLwbF9eKAbkc=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                hash = "sha256-Q+uPWuSyvIWVhg3rWaTid6/KzN+aNIMgj3KP8cSePUI=";
              };
            };
          };
        };
        py312 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-0vKNijZqYYXsRwEkM4KbhvApFHiB5oOalH+8to8PFMs=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
                hash = "sha256-zgnDDQ9tshkFMz7PAhIdrHZbCFCDS0yNuFd4ECOc/S0=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-eZYJAopTysBexjp4Ez733GN91SE2a3aWQVbWnRUj3u0=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                hash = "sha256-9CgxEQ5P3jBvw/B2ctVSt4kMlF4QClROcdldYzm5z2Q=";
              };
            };
          };
        };
        py313 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
              hash = "sha256-R3zkQOK0Zudh9c5Dwpw7Vex3xzIRhHACwcyLDiMsn7E=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiFALSE-cp313-cp313-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiFALSE-cp313-cp313-linux_aarch64.whl";
                hash = "sha256-BZF4rS/r99+iG0vulL9/v9HGNXrb1bYffnCcVyYHdBk=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-XQ+HPyLtKfeSeDi2VCnRkLOS67oWq+4/iXG9Je/DUWs=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                hash = "sha256-OOMuZ5NgCHMUH9n7WRCRBAwCBuWuvPlr8o9HBXV6we4=";
              };
            };
          };
        };
      };

      # ── torch 2.8 ─────────────────────────────────────────────────────────
      "2.8" = {
        py310 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
              hash = "sha256-hYQE04x2opnarWyHwlNjWy3bllRKHCw8wa30OOttSos=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
                hash = "sha256-LphaN0cdR4VJMXd6057G1YXcw918CIOYX2YTxxq66sA=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-1PjCueQgwqO8ldlATFW7iJLHspTJF9W/ZhuURtikCyk=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                hash = "sha256-CsCvsM709QmR4kX855gGFg9ezbHwmXlqIVLZuFz7iNs=";
              };
            };
          };
        };
        py311 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
              hash = "sha256-G3AZAf4HEzZobXjnSXFiWiOFW+1DpxL8bGxWkLeceew=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
                hash = "sha256-fT4MsuAajiqDGCH5wqhzu3k4NMa+czt0gZEjA/w7cLo=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-9M3x8yaACoxpKYz/U83xDoS7u9+6jsFEEk6c/UJdHCo=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                hash = "sha256-NilPTqXXAGr6UDLKwH+x6PBvg+YqOQ2rM7tMix2Alf8=";
              };
            };
          };
        };
        py312 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-5Gg+o0mAYy0lSslO93uUvLX0PpGdApNPNOdNDeRqdHc=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
                hash = "sha256-2okCgHE9lcmusGKDVOjl9DIMYGBkO+YQuYhi4Hl612Y=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-kluMM0hKJItcDjTftFURkARyw79ghwvuMdcPNone8tA=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                hash = "sha256-0Xm/ote++FxPEt6vVU/i/qGkovDHkL4TmyRjwnm9t3o=";
              };
            };
          };
        };
        py313 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
              hash = "sha256-sgiE/+afPEJTIfPfsF8SXxvs9TYmHBad2iJLgwCg/VQ=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiFALSE-cp313-cp313-linux_aarch64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiFALSE-cp313-cp313-linux_aarch64.whl";
                hash = "sha256-Zaz0Ewqe8OeX63DiZdVAD3BG5cBW8b69dPd03eola8M=";
              };
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-PXv1IxbFqdmtxP3IMv4rJdnC2aVlcWGy+RUiHLPEc9Q=";
              precx11abi = {
                name = "causal_conv1d-1.6.0+cu12torch2.8cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu12torch2.8cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                hash = "sha256-O7wiQ/cFFrAAyJOQ6aJQNATvS5tTtr1alMJT+crm1c4=";
              };
            };
          };
        };
      };
    };
  };
  cu13 = {
    "1.6.0" = {

      # ── torch 25.08 ───────────────────────────────────────────────────────
      "25.08" = {
        py312 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu13torch25.08cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu13torch25.08cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-oXDPIlalhfCAMUGJ4fgzg4Es8uzPucDEftFYFMI3QMc=";
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu13torch25.08cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu13torch25.08cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-DWICwJGZqxyoLKBLmGSDlDxcspSNGYHi0BirAOJtzTw=";
            };
          };
        };
      };

      # ── torch 25.09 ───────────────────────────────────────────────────────
      "25.09" = {
        py312 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu13torch25.09cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu13torch25.09cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-4kvZ7xz8ZDOo/cTM4DnDb7MyrCIXixtg0GkbrKYp6UM=";
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-6eh4BoGbDqQ6VSdHPamB9vnEXcZwfYMGnMJddGarYjs=";
            };
          };
        };
      };

      # ── torch 25.10 ───────────────────────────────────────────────────────
      "25.10" = {
        py312 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu13torch25.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu13torch25.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-O2jMBCqw/IHu64IUuEhZESKhClLAvqjjM9fK9IAvLQI=";
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu13torch25.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu13torch25.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-cjApS0RkuP8yJ23/hM88cvwE3XW512ecAAcf1omwMYs=";
            };
          };
        };
      };

      # ── torch 25.11 ───────────────────────────────────────────────────────
      "25.11" = {
        py312 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu13torch25.11cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-TmafsXn7ljkVYWd6zLhxqSSZAJDSUANj+ilN/xRfAR8=";
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-BD/4nmfuzUQhC0VVIDfB165wo4JFYqBG8zOiZl0drf8=";
            };
          };
        };
      };

      # ── torch 25.12 ───────────────────────────────────────────────────────
      "25.12" = {
        py312 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu13torch25.12cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu13torch25.12cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-TOLu8EzUzhCyocHioW8SX2Bu1QTsnmf0ZzhdMcl698Q=";
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu13torch25.12cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu13torch25.12cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-OFD3/ansTbe35YRG93r0G2CHhQcPW00KOHcnG6hv1vk=";
            };
          };
        };
      };

      # ── torch 26.01 ───────────────────────────────────────────────────────
      "26.01" = {
        py312 = {
          linux = {
            aarch64 = {
              name = "causal_conv1d-1.6.0+cu13torch26.01cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu13torch26.01cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-OneyipzoKqQzxDXUy3JpOfr+pcJpxaI1RSLZYvLiypw=";
            };
            x86_64 = {
              name = "causal_conv1d-1.6.0+cu13torch26.01cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.0/causal_conv1d-1.6.0%2Bcu13torch26.01cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-+SKOUVc3phLTp7SpStpmZ6EDZWMoxSp2JCBDoWg7T4I=";
            };
          };
        };
      };
    };
  };
}
