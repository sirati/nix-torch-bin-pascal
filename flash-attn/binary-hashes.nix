# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/Dao-AILab/flash-attention/releases
# To regenerate: nix-shell flash-attn-bin/generate-hashes.py [-- --tag v2.8.3]
#
# Structure: cudaVersion -> version -> torchCompat -> pyVer -> os -> arch
#
#   cudaVersion: CUDA major[minor] the wheel was compiled against (e.g. cu12, cu126).
#   version:     flash-attention release version.
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
  cu12 = {
    "2.8.3" = {

      # ── torch 2.4 ─────────────────────────────────────────────────────────
      "2.4" = {
        py39 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-Ew3Lp6hPNWvllKh/JsaasxEc046h+uDbd8JIazMGu7c=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
                hash = "sha256-7ZLX+9dKMoSQgsaMfiak/c0MJg4kYQpWm6xbFqdUqbg=";
              };
            };
          };
        };
        py310 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-zcL/vgOpjRTMQLVwqAVK0MamnEDc5kCXQemDP1H9QYg=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                hash = "sha256-9uLEFyyYqCJbRUJN2Hq0MiTfh4z7QUjWeeLJinp90k0=";
              };
            };
          };
        };
        py311 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-6cmctqYhTG8fkaiOirPxCTHj8LWrzOouc5lCmvFWXwA=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                hash = "sha256-jETo7GlO3Nnm63ExbRZKfvpBUeRaKlLyg19e9nP0BaA=";
              };
            };
          };
        };
        py312 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-ZRSE5Ap3Eq4JTiCr08SNySi9SBMVMY8E2zWlSpG4Fjc=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                hash = "sha256-7h+7fcnU9ulzaH4V4kVyfTnCtfWITHT6MNIb0YQYVK8=";
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
              name = "flash_attn-2.8.3+cu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-mJ6krxKdjXjttH5ovbqcm5/QlYjgwMSaBYUsTf3sLpc=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
                hash = "sha256-CxMQ9alcgnqGDJhdR9/H93C0hvRMScg0+Sg5a0YbQxw=";
              };
            };
          };
        };
        py310 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-hWHH1z5/2sygva+qeceaePP0yiqbbYKO2lEFIM8jTQw=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                hash = "sha256-xZvhj6k04TLlpAW8ymZzrx2dCaADap4IETO8e3/CmS4=";
              };
            };
          };
        };
        py311 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-SMZIpQ9TpHy3T7ju1j7+ocAS9uwTDjXv4di7MdqZIwI=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                hash = "sha256-ylpWFFMLrTvK+TaRfVOm1gyQV9EhgDDv48pYjLT067Y=";
              };
            };
          };
        };
        py312 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-bbx4kW2VDZcrCDLocU3+wKSlls1dVBX2NHEbk8t0ml0=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                hash = "sha256-UfZCKGHtlRuWhCityfp0BgJ/c/IUW+XhY4EN9vRZq+o=";
              };
            };
          };
        };
        py313 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-3iEVchz17nMWSjEOYC/vLf8/+DA78MocqPw0uJ6WBh4=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                hash = "sha256-nKH0iQQR+kRK2DP/TrCf7GJRIvpfxGvfasgP2TnZDKA=";
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
              name = "flash_attn-2.8.3+cu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-jZb+0TAJDM66j4BvigK/WV8qJowEaL22Bps8/JtX8sQ=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
                hash = "sha256-f5Mr8tGVUseoxMrv//t9JtcStc+IadPe4HThd9fw8h4=";
              };
            };
          };
        };
        py310 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-Cm0TsBgY/ydYvbnchzYscgFjA6fCbdT0l+noIAZ0Qgk=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                hash = "sha256-HI0vsIPt6jZHaI/NS7IdRkHrAfUDWdj6YgDs0JO6HFQ=";
              };
            };
          };
        };
        py311 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-xJ8Yz+Ts4wCJEv+ByHFx7TqGQ5AJI+b8pk/s6KPzaeI=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                hash = "sha256-Crxi0E8o8UD092q3z9HYziSmnGqwy6zo1KuZZAto3Ao=";
              };
            };
          };
        };
        py312 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-rjuLQCymSeCXTyCpuGQcxaciM3ImdM8Pe1JPvfc2/bc=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                hash = "sha256-URAEYIRLDLS9Wtw4r2DFat/4kEUIhhrrXvehwuQfUpo=";
              };
            };
          };
        };
        py313 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-0ONpuvtFVdNEBzWJrK/2vbq9bH2W7Dawyv2zCc8kbWQ=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                hash = "sha256-r/v2y+Ua+zqeTRS2imigneKcLEVRXf1tgxUXSmi0ZVA=";
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
              name = "flash_attn-2.8.3+cu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-aAN13dL6KpyV1VruimTtZL4/lLOJUgoaD6M4gMR1nRA=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
                hash = "sha256-OkK/2OAty252aKoJl0pzctUXmvzeLNfDZrZbgfTHOg0=";
              };
            };
          };
        };
        py310 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-zpHiRvIdYa1msadVU0DbqijkqobtzwDBjwg3Qik5tSk=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                hash = "sha256-ODkaxY2umxzehfXVDtKecLsmTI1OmnZTV8+gTLEpT9s=";
              };
            };
          };
        };
        py311 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-zRpF6/wXMaE+Va1o4MmtkjkN3/+6MG+SIr5nxtWoBa8=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                hash = "sha256-IAofOKT3g7ra3ePY2S0FTa5xLgVcTkgSDFLDENuohE0=";
              };
            };
          };
        };
        py312 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-yv1PcIcl4b6VSVqGy/QYz62gjnB8inl972FIiio8T3I=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                hash = "sha256-QlsQaM9bjJFtCcxO4hyaEC2bP4OFHPhVXLiqiSZaUt8=";
              };
            };
          };
        };
        py313 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-Ah1CVz4pTunX+slOH4Ist35J0m66W3N10AV+xoq73DI=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                hash = "sha256-9jbQH+0Lrea0oZLGmrhLEJ3q7qzpA8a8fsF7elIuCSE=";
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
              name = "flash_attn-2.8.3+cu12torch2.8cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.8cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-ICBNUvqeB3fVGpo4i3xzr6P5IMab7ZUgi+jmAujlLcs=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.8cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.8cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
                hash = "sha256-dpoRwEgVa9j1hB8FUz3PTPbUwYFDBdA2TIer+Osa0AI=";
              };
            };
          };
        };
        py310 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-dcUfNLuTxaRDjWt2dUfKbCKpv8aym1ZG3amOlDzXXZk=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.8cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.8cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
                hash = "sha256-eqQgoPan+wp109T2L346QbUdun8f7g3vrtBRxUZcyzI=";
              };
            };
          };
        };
        py311 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-PUGy/FV1P6p/RdZWjqc6lrlq+0i4KZSrm0m8vLbIdYg=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.8cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.8cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
                hash = "sha256-8anmy0370WR+ViNdgf1rVubNAcfqMkmWjKSqNsOJNxo=";
              };
            };
          };
        };
        py312 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-8l2hhleof8g9wb+4t3UbgiRunbNVUQImtnT9Q3w0tfs=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
                hash = "sha256-JgWyZT57nWYVu7FUiWrk0/C5XTEgr3pjdO6XCS5h3wI=";
              };
            };
          };
        };
        py313 = {
          linux = {
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-fdjGSkFBMMgtg6Ry9UmMG4mfujejDip5OnpNxd1hoGI=";
              precx11abi = {
                name = "flash_attn-2.8.3+cu12torch2.8cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.8cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
                hash = "sha256-yFDTdB9OsZpUi/U/I4U5uSuy/yz1Bf7Qirq8hdALRcw=";
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
              name = "flash_attn-2.8.3+cu12torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-24EIO8xXl1MUDGR/7PsIKRmwzOdG+cNVr0436WXpwiQ=";
            };
            x86_64 = {
              name = "flash_attn-2.8.3+cu12torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3%2Bcu12torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-Ti+eOTEyZrFUS2gTixW5HuYiHszxT3kCt8ZiA1E0CBA=";
            };
          };
        };
      };
    };
  };
}
