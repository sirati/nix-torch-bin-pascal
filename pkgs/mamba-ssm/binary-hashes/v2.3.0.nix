# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/state-spaces/mamba/releases
# To regenerate: nix-shell pkgs/mamba-ssm/generate-hashes.py [-- --skip-source --tag v2.3.0]
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
  _version = "2.3.0";
  cu11 = {

    # ── torch 2.4 ─────────────────────────────────────────────────────────
    "2.4" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-3s4chdP4B5POwmhK9x30XnjkZBB0ldcC8IiIfQbPKzY=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-32l9NxjBqcBkEUXi3aXNZIWU38uT69BnMF9AFEBDXBg=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-h9aRNXKSMBty0Gud8WEQynGwVCGczX+PjJr/Ki5+EaE=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-hzvxNp8xMR3FgJFcbTa9pjbuIFGLtIOsM9v9Prtc2e0=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-PTye2WoQjJ7V98bITitcR5EJAgJRiTugxgPUsVDMG7U=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-UoukYMOnSk6lldhtBqc0JHNfmU9QCULrnfzjcO9Z1tY=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-NmqRiNf9d/r5oNVMKkT1SP6NU4KMY6T2Fr0y9sykaxE=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-RRhgbNXmwR3SCiypBawLfpEBM9Lf8lhZzFytQfs+skM=";
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
            name = "mamba_ssm-2.3.0+cu11torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-l0d9GGPFILqS6fxTU5ugvMw/5KH19Znei9V3FyVVahM=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-MfPsRw0kX1kjHYCSuHXJI5MHHR7zVQfxsuwAYEVRkyo=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-20Zpdv3wokibLzofOfXBHeV8r05RJjcVGRhK0yXQLl8=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-bjIed264tmo/Kh74gfd6tJpuySYi7BN5bTGgs6X+9n0=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-qi0fLzsDzGntzy5HxCDgYtSC7dQkFqTu2ZOaixqFcHw=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-qb9ShM+7XgUQHW6qmb9SYau64CYd4+T39p23rfJDcB8=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-ucvnGgKtp0QgEF2ICyUr3HISGllUJYuA/nDN7cbmeic=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-W2Bm4rLaXl7t0bcDH4yaYAK6fpXwkvJPADDgeIT4IC0=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-Te6K3qWYK76gw5g0DcHBbWxnJt/Ak2DozCHfNVnU4JM=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-KIlmT8BSgv+JWsesX/MR51BoeFa6u66JgVQwOA8KVas=";
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
            name = "mamba_ssm-2.3.0+cu11torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-FpnlrV9Wi0TWnor2nOgYYiPuCR+KVomt3Dl8FQ6/apI=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-fIPETn1MjqrKWVB8DJNIVBexDTPWsHmRpfgslmUWrlE=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-P4cmaZJIPJ+HGoM3Vup98PpbYAvMEd4zCvj8OEDEzzI=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-qXNQtA/5TRGqCPjhIRWijGE9jgVKRHYL1WpbjHk+ElY=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-JHbxNWSfzq2QNf+hRkSBtqjAnmpzaM+13RZ0GCbD9Cc=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-UibRwTCL9OprIGTCxldU6AUzXj+4jTnbWaZwie2fiMI=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-exkEkAo6n/33l8wmh0rKG5+BG/aT1n8PvVSpfcN5KH8=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-8k2EmuAzY3uy4BcOqBaVrbs+eb/07At00xzeV/7aFko=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-H8JoedAzLY3N2bvYGS5r50H08nTnGnJLfV6OzLx5Js0=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-Q0xPh82K9XxeNNDolFkRV0Ke3Kdq8nSAhKPebwI3+yk=";
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
            name = "mamba_ssm-2.3.0+cu11torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-KmGD4toXBqRNPEu0u7/Pdfq+shCdy+rY4/l5sVPiU8c=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-fVeUNbkf4B9mN6PLhoRUtAeASGJ+cVJ83JggcdB9qGU=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-+Sjdjyist3K7MVodDhlrYpv9odK722ado6FlOW1VJTs=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-XmhXxI015n7QhnPvvm8zLjZcN0nGihl1i+AHvsuTi+Y=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-Ylwubr/NWcKU7C1VjkhUmoF/xs00ZJuppY8gWpjWR44=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-du6svL/y1WNUKuqbhtMnYFDGkpAr8eFxW2jqvlDGXWo=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-04XeY8vkLufiQVoIpkLzl7nCs2BUd7y8NAiQfkcFN9s=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-l7DYjjHeGZ5LTMYnUO8giU+f5l1fN5Dz/j1gSSJ7eW0=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-AY6MWkbx0GUIK4vwxgOhxhFZYGRrJUoD7sbFJ2ehe/U=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-uw5cb6EwtZdVcZKb4QIFLEroOXQeKbCTnB5L5+1ignE=";
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
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiTRUE-cp39-cp39-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiTRUE-cp39-cp39-linux_aarch64.whl";
            hash = "sha256-nfusEtH/27rmfP0UpnqtvKz4PRAJ3V0XioFgTfkX6Uk=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiFALSE-cp39-cp39-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiFALSE-cp39-cp39-linux_aarch64.whl";
              hash = "sha256-QCZsyiQZA2jdFHMhCLM+VQLLOgGgK5f0AioT3lF5IGg=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-2ZXCeGDWaJ6kfKSt1dOSfSLpFAcwWxQVWCgHsY9U3Co=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-0CqW2FVyic2DaGsXMIbEnZneImuKG+dpDWoKo+YfyYU=";
            };
          };
        };
      };
      py310 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-u++DVhVVTw9BcfP4MQe0UuXzJPtGiUR8Al9TkRaXUxI=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
              hash = "sha256-OVqsXSIFLVpesDYalXoSffeO8zvM0bemj10NahZ8RpI=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-OHPTSGp1uXad1y16cKk/eD+Fjr3txFOYxWaXCFi8+O8=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-uMvbtxDvFqlCp44/5j0bXAPAzw7XVG4ieZrf9ZCdc9s=";
            };
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-W3qBCxZRHgg2mvUubWARPueYYXK3c46OjKGjipPbaTM=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
              hash = "sha256-ZNJIphS8EL4VqICQ5dM92tfQXFcphqg+Pqt/vKoSY5c=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-GKjtcqklc1Xl1daFjzgGT1CAkM17ZMOfWmkS7yCaU+U=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-4A1itGrxeDiHMUUN5LmBg+ID5T9akfakEfrHKAx15bw=";
            };
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-jwhw9nr92UT9mfLUO5P6fzjqCwj3uysJ15YINQD/gPY=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-O5uebGIOdYnW2dMvuwQkHLYUbx335U4HdePyYCzTn7I=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-pm/E30pGVaueAR44q/pksIF/gg+DM+fec8LSX+lH5jc=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-6nWeYx7YSKXUA6q1uYX+v8+kRblbFYZJ/doU9rZyb+I=";
            };
          };
        };
      };
    };

    # ── torch 2.5 ─────────────────────────────────────────────────────────
    "2.5" = {
      py39 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiTRUE-cp39-cp39-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiTRUE-cp39-cp39-linux_aarch64.whl";
            hash = "sha256-d/uTZY9oKNTIQFqIQ2EGwfwlGqI9Pqnl1ccYn0G3PAw=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiFALSE-cp39-cp39-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiFALSE-cp39-cp39-linux_aarch64.whl";
              hash = "sha256-J5pcxrTxeB0aN79IMGSYwR7/E4Km/0fVRfyHbZaL7o0=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-djcbHX5Rakpje5LySDvH2nxxggS2NTrsxWwIqka+Il8=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-OVLI0xm+l24TgHxrWMP+Vtk/0pETQdsdz3cb/1m7EfU=";
            };
          };
        };
      };
      py310 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-L4eD2pdaTSy5yKew7hOPEbiqUc+2scvQkVW9h/Ot4zA=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
              hash = "sha256-lkmBNsfkk6emQBhFDeL3nii2NvyOwe4gkoXopzkAs+w=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-T9YMIRG4VuafXtzEySQuN7DubPxccR56t+jLhX8/lJk=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-bksAArW2wCXbHC6BdgAKmRKdr4tcD1TvHd140dysB5c=";
            };
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-snfnqsJrqPwJgIDo/p8+mN4lFKxYIJxSobqoL1xYCKk=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
              hash = "sha256-/cWN5MXaxzunt0bkzPfZ4j9loebIZr/5MtmcXhsupL4=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-jcgVpgybp7XHdZONQ/A6RE93EVf0O5BFwr4TWBsr0ik=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-uZ0TosATcjtknHfBq9S7S2Ov2tIi4e2YIF3tbeJTGuY=";
            };
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-6xf2HU71k5CtGeoHtMmwXqaKo/DPLFREUbjXCpRVGWI=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-9ivMd698g2kKIdHN+1+ymIXG6WjeIolwv4ZFVzICzr0=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-24MbqJsbbNpGrAMEyoOJP20RaPmkGLHzMDr9a/gYeqo=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-WlWsJER+83L4nb3/Abi/3y/QQmF/fOEC8jz4mp27Rs8=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-JIZXpnl0y5lFEtXVIApIZ1ER4A3v6ZcDqb6DN5Q252c=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-W3Pbhi6tqY8BwDbuZfUoA15quMOKzpjXPKNEOD+gO0Q=";
            };
          };
        };
      };
    };

    # ── torch 2.6 ─────────────────────────────────────────────────────────
    "2.6" = {
      py39 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiTRUE-cp39-cp39-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiTRUE-cp39-cp39-linux_aarch64.whl";
            hash = "sha256-mLof13W1GclwASMaxXrFfCsLNMKiUENMD5pOTGzfpXM=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiFALSE-cp39-cp39-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiFALSE-cp39-cp39-linux_aarch64.whl";
              hash = "sha256-u1fOzmSxAT6Z3KURT42EZ83yXFr1V750zWLVpY5Mm+g=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-g+8qlQ9DJfVDrir4H6O5aqW5qq+xbtOl3YVagvjfMrM=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-ndsrvoyytHucv7x7mxvkZFzcM9KWr1UQHR81vkWibAg=";
            };
          };
        };
      };
      py310 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-GyJ217Hsq/TEzSCkAyTZwj6UKeu9zL0kgcBpXu/FO/Y=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
              hash = "sha256-mk8u0mKUaPTwlMO+SsUPvPwls29GS7j99qkXJF+Jhgg=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-Ukb+3tJe1ghToM2xeOyZf9PRcnC0xBhmkeagDQ0F7Eo=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-bi/7F1QNKkA0TEpRzI9idK8sg8IBHwg2qt+iy1XRaZo=";
            };
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-UCHKFfBjo+oWWICaBoXNphpQqAt/MjgjeYTH7P+sdXM=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
              hash = "sha256-bPYEATuKb3MjYHrjZ5KAubbTuOTwlxUvBMH83mch+a4=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-udSzBXAY3c0nzo1u+mN8Uhfs2Sfo9gxxaDusq5f79E0=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-Ai3mcfVPTVRTB82jOitPnNKQtH+et27xAZg+xedaLa0=";
            };
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-1Gd4sehwmga8RwEOI+Ra382hpuNx42XgMPJqNk1z9d4=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-EYvLfQl30xAM1jaWBX+DEa5oHaHj3OpUuDARlAqtne8=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-iUtZTtTJnLUCp1ZQR395chXtL8H4B55Vxn5Xxd0vnls=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-pi4uZa20XEPV/t5umyfecGqx2xu6SqyFdMg3+LW++g8=";
            };
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-FE6L1kh2DrB3LSsBDl5Nu3kiGVuGft4jVfYsuTfJmI8=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_aarch64.whl";
              hash = "sha256-WGTNnKtY6pI+ln+2Xc8d3D2w9mseg1gClQgd/iDXOBQ=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-qTXVDhg+tQsrihVKcbcbitklM+8YmabfBM5NLBa2QXE=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-nMxakdudr7ItxsJN2KW7yK/yu3+LiFbjKflqxX39bAE=";
            };
          };
        };
      };
    };

    # ── torch 2.7 ─────────────────────────────────────────────────────────
    "2.7" = {
      py39 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiTRUE-cp39-cp39-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiTRUE-cp39-cp39-linux_aarch64.whl";
            hash = "sha256-suqoT7anSffUSXNSiJ5df5PaEhYp4SnaBaroahbUFSA=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiFALSE-cp39-cp39-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiFALSE-cp39-cp39-linux_aarch64.whl";
              hash = "sha256-sT/2egw/0rch5IcrsMyJJK4LzXh9D4S5MvWN/hPY1EM=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-KiU3D7o07Id54GyppBLfYjC4cmpmSa3WrocTa+NiAZM=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-VMEmpq01As3woakKyeHVcZwOa2BTxV7FmWLKoC72f/E=";
            };
          };
        };
      };
      py310 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-6xLNtqih+g3G5fLdh0Ss1A2BiVvaRdoiclOZJcUK678=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_aarch64.whl";
              hash = "sha256-V/uWsv2Orz0QBHBBLFCXL16gCH+E8iqp6d3FRn+uA9g=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-AhoEhvGy+aNYtS1tWkE2Op8ANbKbZqSf89/Uz+es4xA=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-MlOU07S7R5Bk7pwpUMJ/6aRmf4FZLi/tjM+/XG2vXYQ=";
            };
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-Cq9QGis8QxQTXPfdPGfJq4skcfyz/ugFC+As9BuLcVA=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_aarch64.whl";
              hash = "sha256-SxpBNWH3ePdUbpZQrT+8wiByuKodLRnx7RIIvgJPd8k=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-/vyqfS53m8hXxPh7DMBEOs3H3TcMvoxzn1E8a+NKlFc=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-53i5yeodK4RTzk5ONbbEf4slAT/4S4RczorplaJ1PBw=";
            };
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-kfS04ahZoa5GFE/XhqQgYWSWss0e/TXMTrv394x5MI8=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_aarch64.whl";
              hash = "sha256-L+l8AT5UicmykfWJn0rtthPPvENS9tqcoxF2dMBoCsI=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-f5v9bB1sey/Wci9GFtdLrcNafy1QYKNRyO6BOQPhAzA=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-Mc0GRXK4MQF0aEaEiNkPDMWs5nmw3aEa4WLRFPFIhgQ=";
            };
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-zijeCok5Fj4L/eGo8dVwd4A66Gq5wn+0k8ndG24Wv+Y=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiFALSE-cp313-cp313-linux_aarch64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiFALSE-cp313-cp313-linux_aarch64.whl";
              hash = "sha256-FvW7cpMGia89qG75+piRwnO7JmXQ3TyMbWQizcTRG4w=";
            };
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-W55LQtZN0mvYha4ARLBQaqvAKqiPed7o3bsajctH5ys=";
            precx11abi = {
              name = "mamba_ssm-2.3.0+cu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-kOV13kUSgRQpTgEoMI74aTvyouFNv1oNP19ZgyzyTqw=";
            };
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
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu13torch25.08cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu13torch25.08cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-qV4Cw1cXCz/bGHXnUleqRc52jspn4C41B6BZtTA/hv0=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu13torch25.08cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu13torch25.08cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-dOB+wJ7sjFF/LDmhHBziAA6YV9B0BJ9wNpja366yZJc=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.09 ──────────────────────────────────────
    "nvidia-container-25.09" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu13torch25.09cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu13torch25.09cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-u3KVv4mS4UFldKsb/Q+LLHELjIY7Iv7V4mmeAzu7hrY=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-eE6/Ao5A0gQoRfxhThUxSWFcq4THM/VtvBVQ5AygM7Q=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.10 ──────────────────────────────────────
    "nvidia-container-25.10" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu13torch25.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu13torch25.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-ws6BzduU4WmvGeCXuyXGw9JnOKx2VTWrOzLjNVdG1kM=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu13torch25.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu13torch25.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-v1I2OuGhjAdiUaqRt/HDI6ZaLUTKe5hSIC/nLKFJZxM=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.11 ──────────────────────────────────────
    "nvidia-container-25.11" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu13torch25.11cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-uHeq+bMh9RNNRRmHbFPLobG4ouACmrcWoFwaY9PQ3KU=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-71dMeeIssAbWrvv9mKq47NevmJ5YVChkOlPBDTlAp5w=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.12 ──────────────────────────────────────
    "nvidia-container-25.12" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu13torch25.12cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu13torch25.12cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-Uk5oKgz72GpmGUdVfBlTv2KukMdkVVS3xQ8skW89kmU=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu13torch25.12cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu13torch25.12cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-bykf6rgl6C54m1+EY1/na0Hnl4i57X9uK+CeGhnVxR4=";
          };
        };
      };
    };

    # ── torch nvidia-container-26.01 ──────────────────────────────────────
    "nvidia-container-26.01" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.0+cu13torch26.01cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu13torch26.01cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-qEDAyuqSSzmzTlic1DCYwG1ec5KjHU+hTs2zvW/UQHg=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.0+cu13torch26.01cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.0/mamba_ssm-2.3.0%2Bcu13torch26.01cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-R9nOnABbF0+YfgL9H9TsvQHcU3nLCLuatEhxLU2nC64=";
          };
        };
      };
    };
  };
}
