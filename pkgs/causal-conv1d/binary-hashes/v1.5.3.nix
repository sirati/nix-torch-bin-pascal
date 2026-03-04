# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/Dao-AILab/causal-conv1d/releases
# To regenerate: nix-shell pkgs/causal-conv1d/generate-hashes.py [-- --skip-source --tag v1.5.3]
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
  _version = "1.5.3";
  cu11 = {

    # ── torch 2.4 ─────────────────────────────────────────────────────────
    "2.4" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-7BQTVDii6ARVntgAsrJ+39PZxTFRsmDbvw6okLijLF4=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-tRRN/Zb1n4z+dZXZqce/XQ92Mb4BT7gf6Y3ii7l8LZQ=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-0aXpi74fdcYMmstclGna8aLi8Estvcvy7S3+e3oL9TA=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-c41+g9v+kv8sOMNfvuqAAFGiZiwT+oMkucqTj1dx94Q=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-yw2HeSPnd5+wCt5n0vT6Up+/b11MUCmy8/E5dao736o=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-WoRyF4d93YzaWGo0NWUUU8sRw/i7vuT25BJbMRUgVP4=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-sVALnRjgGJJ2HJWggS4mWKbUvERXRO2eudM23hWx31U=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-tMdBP2dtVYOTTB1t/Y7Tzy6ngUPJW6eeW8SgdFDS06o=";
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
            name = "causal_conv1d-1.5.3.post1+cu11torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-yzc6vrHKm95NwTggnxXZgQh/5tLDIi6IjsM8CZ6mGX4=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-lrYy6OeJgtqmGFcaMxl7uAmD3JFIwQHbRgu0Rf+513A=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-mCFPuHGPIL0HzcO0BgsmFuaSsGdDFUKUz+SyjW79fMA=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-sm681eVkJAomy4WExvM11Ql1m6WaDuajJIet+JyQiVw=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-QS6ucsI1Ug/eLXkq1KfbGCPGwNMztcY+FBfKX12QzS8=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-itBfDtuiXe/pDu8+UuSRSt/nSCOqx7MC25yINS7rC5w=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-YnxVK+wLQnm3Xx1bboEB+I0X+M60mbQLy/GXHxyCZFg=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-tBumXZwyFofpiHTaPlBn9X3zl4q9vXdLXI6hF+9k9lA=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-FQxKGi0tSSHt2ulXTj5Ox3J9QdriPinvIegJI+f0pKk=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-Qzou0OPVVJwOyjIpc0cyeu05InZiSsH/UrJJMRHGK+c=";
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
            name = "causal_conv1d-1.5.3.post1+cu11torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-0Ls4y1/OS6yFNJW/fXftHaI1uxM/KPERv7jtAfRJJJ0=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-+VR3frV+Hiz4c6S/1ZKW0F3Hb2hiB2kmJuAot6aLJjs=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-tvmohm57hcoig0+VpUw/hdiiGXlEhm8LI3W9fNDzJsE=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-gXrf1z7kYDJ+zt6WPvdyggkU6mrFHtOSqkYSah3/st8=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-KMaZOXpy/08/YAHhAktjcAynVj9DRrYDQnVGb84Dlv4=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-uBRN0N8ZBkVRcdYqm2ygtmBT48j/h6gknLr/2E9dv2Y=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-xJBx7SCVa96LQv/GXTjza1GDCYBJNJg0fvjSfrwRmgc=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-2lxmI3rwNx7ny5BXUB6C8eFX5R41u9+lpVDuCXNEOQg=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-OD8nlD5iX/rRSxwCc9s8W7f9+KE8NTFqLrnXK6G2WW4=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-cQ8UFuxoLQ8ssOG7TEiHahb73Sig/aDFKxP4cXHwSds=";
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
            name = "causal_conv1d-1.5.3.post1+cu11torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-mP8AP8hkV6SlwhQuhUD4C7UvHyr4CaGDcbS3MLupUCY=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-nlk0faxYOwWYIJ4TmROxgUnvP4J1zx5UFWfEl9DEZiE=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-DvilorXT0i7bZjAsTFFDTzP6eSsHY+uoNrNVKuOVDVY=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-Mp1BvMdaqxDaTg1pD+38/x4RGZx30lPUTGE7wuxZtXE=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-JSKo6bmgfGyTi3OMSY3oCOUYCTeyWap6JtMhgXLj2wU=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-eWdfsPIzuvwmcvvdmEcURqDm+pToIcEe4Wcjeli1hMU=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-JmIhTdZGIl6eMOqheCove7i9VbK9r+39JGaks5Z3Kiw=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-mBr0yTZIpWU9uQNOCQXroec6Ay5ezPy+O0WAvz7vB88=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-BFDG+ittGn7HdjXJeQwks0VqqjDddDlsFGuiSdCwo7E=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-JyvXylBzkMi1TTQv5rt2pVdU4OQ3LpBcuDo2uRb8Lrs=";
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
            name = "causal_conv1d-1.5.3.post1+cu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-7aF58+ctR+VFOBvRwZ8aO2IhH8GWeXqFeX5hOs7MZ/A=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-3XxbDXhXJ9ayqNIV+Oiv7p7ynVCwaBfX9NpvfmODM1g=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-8bb+HawNlRXjpDRGsiAXHRlEScL9aWdBnPNsWRYy6fw=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-9cMpqiyS4BHsz+b23usrBjcp80xsgsqsq41JyP0CKVI=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-h60ANPUUM7bBRKdFMkmrXq2nMU6O29bfLCzeTbu7VAM=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-oshESXtYbFi+dNBm4Fw249X8FuShYDGXf3kU03RRLdc=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-V7WfVaiaS3DoZWl+xB4gFwbIfndvi1hAlqaVUcL/eso=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-SWwqMJ9su0/a0i+IFrv1zOF/CITpRePagbYlbWvauzo=";
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
            name = "causal_conv1d-1.5.3.post1+cu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-FlH7D7hUA2x2iqEGYD8BHc8Etdn6vx+MXNaXQJzCTvA=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-bBHea7KlEHP/coZSSCmu2oufgw21Yq62xF6IzzPX7HM=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-M5DcRH3JhbtB7xeZ38dP37zbxP44AwQEm64QeWOV7k4=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-jtYJrHh1Vwsu9y23z8GRGwKlSyLjHZcGJU7IlxRm084=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-qbiwx9zExhZWZ2kAjl6xZmLuxVGqqLzBkCZPCzWYhtU=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-vJtuiNMV14xL3ghBjfjPR+skrYDMytw0+RV204HtEAM=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-FTKy9ROm2IOhuTVvTqkYu7LMZEGUWNwN/Fm6KIuqPw8=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-+ijFrEYW9y31kWdq4uuM1TfyEX6kMvjd9f9X0XcvNls=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-l9fFlV0U2JnpTLMhgqdGd+M2X7kqwg+vtM3xVuvfbGs=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-c/ZWcgtGh9ZjnZZAXF7/8ihow5Gwab39lcSciGRQLQk=";
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
            name = "causal_conv1d-1.5.3.post1+cu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-SZo9+mKzEYZ9t6jfEpz0WZKM7VEABXabHDdssCeRWuY=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-aom/KEgN/hIZtcBlTfffoDUavgo4YKslxcx6X5Z9A1c=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-XaM4mF4zUlDZUPEJQJEgrLpUKxB46cDWxRGFd/ZinK4=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-LWNFgYXAS1B3mxkyWDu7/GgK/YeprmI8Ec8bLyr2YsA=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-5+YN36dbVMI+OmfQE9wX7DEGyF1mC4PdMg2cvFtjW9Y=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-kHE7Sn2YVKVy+JRdiGzs9I4b1/ryMwXMFtR0PYsrEI0=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-BYyLjNtAhqLw3jaGa7HT8uOvfI3bEfzBtDi+nch5FOo=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-KcAxnKzh6khreQFGGlTvTderQKRmM2Rzza8TRXa3Ges=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-AaDUmESYDefEfI5vNV6LfypkfwrgLq9BNV6czznB4go=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-lFG5B5F+8uYqBAXZZ6tQJmkK46U0pw2+Aj5p8UiK2As=";
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
            name = "causal_conv1d-1.5.3.post1+cu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-a+6gHGHw1dkfmpLyKX0ROJ5RUIiudzrqgn8/wL6k81A=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-i9j0AaGkfv+kz6KZxnjBsKRHUZOVzyqCAPe3MjRSjZA=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-FBHj9Np9BZIqqRWNW7BWxgjWohsaJZWkfBMYL4Y76eM=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-J+s/WAmJMQVLxDiwrK/ON8soNohMUYUpAWEIcNrGTHc=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-DAcappUbideDdU6iDC63WebjAGaeg+hm2u6xp/IhFP0=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-lb1BG60Q2P+X+LSactF5CHmvSLDIoKRr21AT/PQpQ1Q=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-3lRQmW0voQw2+M2p1+dresfFwt4cyYy8W1m9RQXFKG4=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-+24aZTjwEOos611ZiM9wRG2JKTa0Zro2OAa3RV+HKtM=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-Bj/qAUR9hlqoqQgPzD0UYj7J4pKJoiJfokb9gB0Wx/A=";
            precx11abi = {
              name = "causal_conv1d-1.5.3.post1+cu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-w3qpBtyWDRIK3MfaH+jwIli4I5ndVYzlb++IsA979Ws=";
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
            name = "causal_conv1d-1.5.3.post1+cu12torch25.04cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch25.04cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-WOwFgih9h9HrkmfwvEQcBCmoNcMgrwS619+Zr0czcIA=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.05 ──────────────────────────────────────
    "nvidia-container-25.05" = {
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch25.05cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch25.05cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-pif9/cvC2ihaRmgctfw23l8YzYlVuyiHKpWFl8yy0Yc=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.06 ──────────────────────────────────────
    "nvidia-container-25.06" = {
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu12torch25.06cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu12torch25.06cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-EtlWDqUB4wT5dwqukDCwsH0qn0Z1nfPhfL7EWmqd0Ho=";
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
            name = "causal_conv1d-1.5.3.post1+cu13torch25.08cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu13torch25.08cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-uUFC/+lEnuL6pzbUtbnwrNZCvAo0nccLvUGbcK23270=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.09 ──────────────────────────────────────
    "nvidia-container-25.09" = {
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-QfmqmqqaU1bqxUWZKRwgcQd8AfU9DMQ8tuWLfphhjYE=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.10 ──────────────────────────────────────
    "nvidia-container-25.10" = {
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.5.3.post1+cu13torch25.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.5.3.post2/causal_conv1d-1.5.3.post1%2Bcu13torch25.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-Le87fe1SNu52a7Wx+qfGkOZwaXfipdjumXlzymzwuRI=";
          };
        };
      };
    };
  };
}
