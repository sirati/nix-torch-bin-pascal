# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/state-spaces/mamba/releases
# To regenerate: nix run .#default.mamba-ssm.gen-hashes [-- --skip-source --tag v2.2.5]
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
  _version = "2.2.5";
  cu11 = {

    # ── torch 2.4 ─────────────────────────────────────────────────────────
    "2.4" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-oss8/ZzpTWFSlh6NQnNBSDaPQOuw++4LSDPMpzw1yP8=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-ZLR95RMN88j+SxS+CUgLhCuYC/HbmdwFQEJIEjx5Cog=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-c6Et2IhkMGLWIc99ypRaarhBF2yfEwSIPHH1ph3sTeQ=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-MnwOl1zOsYqBolRlGH5uMVc3BraicqlIng4FyVEZNrM=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-2gtO4T+/8tAz4ua3BjHqXCBfUfXj2rmAAFFi+5RwQOY=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-lyZdsub+g7wWL75mpyl+/nWbI9EWjoEtex9NK3DAtjc=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-GF6j1iRne2F4qUn7WBuquSkkfUuAote4l5HSmPxnjSM=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-wJe35fJYdbdIjtYVvMzDNgeJTnM4pdjxNJ4is1haZOA=";
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
            name = "mamba_ssm-2.2.5+cu11torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-ri/qSqw1ONg+Npv5n41jF/YWDcHwnMs4UWEBv+wwWMk=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-kbFLlh+PpvOmAk3nD4FEbqOJEaNYZyVPIi31cDV3JSk=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-BzUswNGI1LFHwajh09TrBABc2vNWWX7wrKEYlz7H6P8=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-wAXFteY3LZOpio45xb/2ClW+tYTzUI7J5w1Ksqh6pFU=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-meQVlQPGxu3ZOoY6MbYUCEzgmt+rikgOSaI+A7Ihx2I=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-YeBbqGAAEZCMthZMrGvXRrZIwU3jtfiPXRxn1Fp+RjU=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-0hE+GKj8GGUnpVanglN5r8VyrM2pKYoYVWGTDf+0Xlk=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-QmXthSi7yh1DEcVNypgQAu6clS5kOjHfpFW5TvM8Omk=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-QVZnC8ebKfuuK6dyJyTZ6EEnFf3+sQfhtDJWKy3425o=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-R1Hm9+a2lVGh/syGuIyl2Rmg38syt1F064rTWcxZW5Y=";
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
            name = "mamba_ssm-2.2.5+cu11torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-z5oa1Oe8EeM9qckT0f1Y5cFBCjtlMLiBIGfehd3k5p4=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-+VbEgJ0NrAz34CaZS1zwrt/QLYX1jPGydBe2Do09UhU=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-Kt3TNSzplwmaLaBwG7AAzL7zp0++Tm8u2XBdJs02qfg=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-NWCLD6w50fc3a3jYJB3TA1bkiVWL2qAb+OmiV7t5CTw=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-H9dscKVkoTtLTe31V3F0cEPSCLVCjvfb81wAAboLdXk=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-o2kM33wM5RHXjrMojS/bpDSMdOksKehcGvMhQsOK6HM=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-wqjFPKAtxHMrHl2qIEJqdkWeb02So8v85xToHngBUaI=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-nLmTWdtShkV9K2f7b9z9fA59KOBmG4GladH/0tKYVGQ=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-YaiVxfvdEtrFzpgxy3qfl+7uXZRioWaE9IxyjVUPNvc=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-X3EYMFOpT/8s12RHew1Et9f/IHhebNACcjXR/9S53NI=";
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
            name = "mamba_ssm-2.2.5+cu11torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-6cw6hxjAl8LGY/00LvAOwg/U6pK/+gNU/InQyuow3aU=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-P0Kfw1Xd9akueaH9B2PYkIfJPoWORHgVBN/7xKs1Lrw=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-/UAyQIAn7cSwGBfvB5Plrn1dnJ3uk7LjS4KrOcF9KUM=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-PwoZKGBhXVZrV7cnSA21nxzSAYD0sQIxsYHII3Sf9/Q=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-7lA86yJj7hwUXI3RnS7XoBbPWeVlL2jMvvbNyUDvgcc=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-MWSuiczt7tIr89+9G74CWNoDIt6GMhNB8E1sYTH4DCA=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-FEphM47V6U+asgg2PSFxSjDVzpu1tva7S2dbG3nc0Q0=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-xH783y+1Cf33Ft71zajCkbOcW6/8cvd+fc5gfvrGj04=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-XKCr/Tya24W368dVY7UWs9MxoXWbA0SlnlKYwirpk38=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-h9P92PFBSO49yFjPMc4LOYy5FNg1E8VrMsfjKiqAI6k=";
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
            name = "mamba_ssm-2.2.5+cu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-/5PpiXg7oAIMSFXHoIr7C6hGbzmIU6IkqWQ9jH5lsPE=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-0eInP04f7dPMANCDYbAAhGui9Ewc6Ml3fRszzJbtmHA=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-B2p3iqtAKOvF/L87rFzXttXMHZwKREjsthVJPUvkqNg=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-MRI31VRgxSZoqZ94rKDzduOtqvkFeUdRgqM7C1Giz5I=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-cq3XafzYfGAGzBv+VW4fi+VsmIT4rFsdoCiT3kDQn+w=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-XysS08C85LVWyUa47gIMRRhOxh0GtaxIEtOjGE7HXVo=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-8VnAdpxwNxCTKHLj/91YcKIfsywbO5/7DGyJLQIWZSY=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-sAeb3cZw4RRbQFnp3paM5oSW12UwyucC7bTf+ztm+00=";
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
            name = "mamba_ssm-2.2.5+cu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-Oq/JIkY2GK+Vfbrhqct0GcUBqoaapXucbEEwagssGHE=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-LBON8D++kzxHkhRduiGPbb40xFxuw0jKrQMMwA98HaY=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-kSElPL8Cz5YY1ZtDufttKQlln4iy69+mOFUuReH5Byk=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-7JpEFlO869cnLD2JASrYYw4/dgxDRRnKQsbO3h2TOFc=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-D27mInVLVPVLCUqXbNcrJtVLs3fDKEP7YFU4LmU/RsE=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-0oclQmU81OCinYIPtRCfalQ+uLptXN4lL/T58fSBWfU=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-w7BGKK5I1tnzkwzl7Sd8RobHr05ieIDcB0VwsAkqDRI=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-W0sgSoLI7olgbRr6AFcktc2k7kcol1EhL+mP/KlqjiY=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-DUQssx25dXAsBNjWBT+ya79AaunWN2/j+Tp+qOT2K9c=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-MWzPpLC+d1mFKyPLjiMH9zh/s1+bSUHh6qlgfJ0svWM=";
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
            name = "mamba_ssm-2.2.5+cu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-1GZAUzJGaqaTlkH+PExymhwXWxneyxsS5LEShF2xZ2I=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-JX2W6zcahbzBWfaqIljjEZqAnzL/11SWGCUotMqqejA=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-LGAm1W+zKScg7uCWIY54oE1+z8yAIrTbDU/Lgc9+Aos=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-/SBAKZxeZcbo3T3onKnMWnpR7yjHaW2FwMxg9lI4z5I=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-xZLDqo028iSNs2K/YiDjqGdbZk9IwOdAZC4lOYvqgdQ=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-yffjmCKyPcE4OVxGSRKaFD/YOy/rkDDHPk/Wy6hvg/8=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-k/Txnyup8WK1KWnkUe07M6jkrQmfqxq0W/40u/A/u/c=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-u2LkoqmRdh0OrYv+WOcXNUWep4l7ndUlHyju9mi8kOA=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-JaZFUnUAu7EwWGEgqEP6f17GfF3IS9QpDyhOVw1F6lI=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-dZnb+ryQabQOO01+iY+xrf+OX/wQsW9FROrL4sp45OA=";
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
            name = "mamba_ssm-2.2.5+cu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-gx/PQFXupdB/f8OVIK/gQx+kx0ixNp6EZ9dU+wBh6uU=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-sWd8oTy9gewZ9D1XNeTr7A3IveMpCTeX8wzEG8JfXXE=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-orRDTZm0tt6bAvCBiFBa12+zNPFsGwHqFvpZ1K4rZho=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-EEg5hyIU/AIG3+w6uf6xhYekxunB9EVbWCBBrqwr99M=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-JcgMsfrU2BH3wL7n6QV/alk+ORLAEglbUf7qbkvI6Fk=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-V1NiiOkpXx9NCQjslfhye5k540qKvxPuYBP0kBVy0HY=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-w2XLw1vvrZQhR9+eb94XSozd34I5a+5Z7ERm2sNRtBY=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-rC4okrTWRGpnIAfSSVH7TmaVsg1ibdWpqGXQgWmAHQo=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-A7rqU43NcMmZcuwtY1TSLrlaeM/mElTQAyA5X650t+0=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-hxc1q84t+ajddpwNCVEuvsYj2JhuYpDtxjIluBAONpY=";
            };
          };
        };
      };
    };

    # ── torch 2.8 ─────────────────────────────────────────────────────────
    "2.8" = {
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-wmhpzoQO/ZZUXqrDBjMETOE0kSXKEA55DZhb7k9VyhY=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.8cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.8cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-vJcaYAYbhLzkqlVyc2KvHDxEqBuhnNSxRhOc8npw8TE=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-K+Kyrosf+TaBtJ5Y3/n0b+fCix52ffiql0lGU/52ylo=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.8cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.8cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-Pc0UiFs5+y55rXILfh9q+wKdyCl1Jn7zWxgwyJvRPtw=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.5+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-yLZfyr+0mpRFbJlxYZAHIY5Ac/GahPtrOJTzPUO+5KE=";
            precx11abi = {
              name = "mamba_ssm-2.2.5+cu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.5/mamba_ssm-2.2.5%2Bcu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-pVE6bRnASYfkd9oJXlvyVL90ZBCeMxBYYzpnvJdBIcM=";
            };
          };
        };
      };
    };
  };
}
