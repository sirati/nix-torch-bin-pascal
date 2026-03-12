# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/Dao-AILab/causal-conv1d/releases
# To regenerate: nix run .#default.causal-conv1d.gen-hashes [-- --skip-source --tag v1.6.1]
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
  _version = "1.6.1";
  cu11 = {

    # ── torch 2.6 ─────────────────────────────────────────────────────────
    "2.6" = {
      py310 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-Zyk8JP5744KTTx2DDo8wDP4HPyPMdqTR/djnTM4KXrc=";
            precx11abi = {
              name = "causal_conv1d-1.6.1+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-L10g+geDCY2QExu7b+iYDTwrXV7FrFWUQs1Gru37txc=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-MKQoz+u9qwF+rezB1rrzLxroMSUNeg5kp8IZml7zgj0=";
            precx11abi = {
              name = "causal_conv1d-1.6.1+cu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-zYCz8b2rmT0kAtBwTshnZ+5ZHeDoyLeZrJVj3pVvvyo=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-P+RZhRd8zjSq7AxZBLxyqc9K+iT2YEXhKE9eAvwX0Oc=";
            precx11abi = {
              name = "causal_conv1d-1.6.1+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-TcnBsKsZgQjiqleBuwjyFYG9JGpifDFp81geweZyZL8=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-fhrd+ZjpBRK/AYQjSh8heHE1nJAFnGJMierqgEv3Ir4=";
            precx11abi = {
              name = "causal_conv1d-1.6.1+cu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-7hn41Oe8lgGxX2ln33FsdlKyIyL1msNl8KYrGsHzDEg=";
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
            name = "causal_conv1d-1.6.1+cu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-j3bbNdKs7Qz695JGsIhh5X8vhXYr4gJoPRAfpdXn3bc=";
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-DFho5SapbbE7yw3CyyciEWzGg/iRd6NjPvAttex4wCE=";
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-MPbHSC2omtESJDgyD9FUzGQarx1OyE6HaV0LfwfsxQM=";
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-oCqyl0jk8hFA8HZDh8R571TQbQP6bTba+4wQks/8aRM=";
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
            name = "causal_conv1d-1.6.1+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-FTZHMnazg3jmvLmo6NfOhP406nwKqW3WvGWkXTzkhxI=";
            precx11abi = {
              name = "causal_conv1d-1.6.1+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-tUmSJoUwryoqu6eD2DdgLmXT93XW/RksTfoiEwDV3m0=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-ozZYZRHDrDmdod/4SWGX5j2jM59v5S3GSTCiJesG6sg=";
            precx11abi = {
              name = "causal_conv1d-1.6.1+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-/dpdOK8hjfk+D7vsmWGGuz2e4eDKYk78XOukPeNiAGs=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-2ZvwX221Ziv6F423itL2FGxVsUyfDw1p6r5MAcc0uOI=";
            precx11abi = {
              name = "causal_conv1d-1.6.1+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-YFIr8T7oFQUQzJhGO6MljMVsa66VtBDJ/IFACx142hE=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-XF6DOFi3fEbcyqQoiaDeoB5ZMiQLmaaF67JVixvCe84=";
            precx11abi = {
              name = "causal_conv1d-1.6.1+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-MCE2xFsImOOtHt7eVdSi0Zmz/hApFhulCFtYV0gieEY=";
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
            name = "causal_conv1d-1.6.1+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-fHEqVXpnfsZMIgG/UFmv/z7gvlc2FlioUS4OCxWInVA=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-Z5sTMB3dYQ2fi8vFdlfzpYDKOwQbjPC0hTQGiWf1EEw=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-tEjbOsglhM7L4GD++dOOPDaHAo9XdZmckbK6S+KVYto=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-jYHW7wn8CyzRK1oaTD0FHyFGZt0syRteto3pyGcmy38=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-0zHjm/SINqdS8ZZ/lKf5yCu9p7vQ+uejnR9QFhugbTw=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-T0EAhmOrtLvaa1eNtRXvnJ2878wJChrhENpaXYTI4bU=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-QUGaYUo//p99NFJC7lizPAE3wCdnkGAb0VGVKumLVSg=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-WRF3eT7oQ2PGt1ayy9Mayi7ouFaiOU5njb7G4fXPN1s=";
          };
        };
      };
    };

    # ── torch 2.8 ─────────────────────────────────────────────────────────
    "2.8" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-PDoVFC7EDGm1FhcCXgS9mOJMVyTy28Ou1Z8F+EhKzgY=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-H4SlFpLW6I7tDs41Vv1Je9HBY8tQNKsainuG74ahIi4=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-Ge4DNJZ100EJK2Fohde0ToOFlZnfoz4I2yY6lVlLXe8=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-ec6jL9zki2FifePuqY4VuYBkd1rfO4h2yF2MpB2kDCs=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-22hsUizxSxfP/lbm0ClKr2ITH0cYbxNdEuzYYJYcLvQ=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-3Pewl2dq5SlfTl1NGCC1BWWPQJUQYtQo/iNNMq3/2pk=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.8cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.8cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-ruNalszunQqwN+R0GNDV+1GenSlGLPim6t0U8Ia90Wg=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-EBff84dTgXBvgCLLTbjngLT0FxujKHumPyCyJsuOp2Y=";
          };
        };
      };
    };

    # ── torch 2.9 ─────────────────────────────────────────────────────────
    "2.9" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-STer0bokfTLYFDoCr/R7MPK44rWzlA6/KQ7XE8/cyXs=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-TiZFaD2swAYiHUNaNjQsFry1WQjmo+XBNCG3Sn9Kmvw=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-O+/NV/R6HqcC7rMuVH851kKp6u3Djt4/kORlD4graQg=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-nc3GCz9E/ZsPRhIWlbQGvNDAqqYb1wfHAA8NvT0YrT8=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-Mi3GaIOZK6V5Yn4pKpOQlA1ISnB3gSn+Bf98MAyXOPU=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-t8mEIZqh6C6BRpesD+vbyhcbH3uBP4MfnPmlaAlkNyA=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-LfKWJm2A/zeGdfDporTeTYtk5lnyW59U7CbDC2LfKzQ=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-+ETI90kOmIgIk0nAVzmnnFFIK8qyxNS4oIeaLnGDWyM=";
          };
        };
      };
    };

    # ── torch 2.10 ────────────────────────────────────────────────────────
    "2.10" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-Pd2HHqWD9KO1edATXrgbS5KwX64VN/EEgYHGOiXh0CA=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-BkKIzCUwntBw9JTjEjqAimRQTgTFK1qWiIwXn5vaTSc=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-5kF7LDIKSkNN09Kk9ZcblH5PUP7XmaNAvy2ugYve2Ps=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-/SKS1UiKwIK6FRhOc45EYrJzJ2k9DenQMm3ye+1a4z4=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-n11yKidEyDeIvg5wrUnlR6IILHBB8uw6ZfTOu/DOgnY=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-oEOan9Ggx0V6H2pwtIDoJk9xAfOfYuvRXLYiZ0/heB8=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-KNe3Cnj0GDSCD6BK86v5ZfDFyh+uAY/btO3vX9ZlK8M=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu12torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu12torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-InemLiIX01dXCbRBTRDbSt7jzLtZp7Q3OXo+FekzXH4=";
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
            name = "causal_conv1d-1.6.1+cu13torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-ZLys1b2ZkhXjIIUsGgamrswgMMOyb88wJMbJZRIAXcI=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-X15/ORitj8roy01vMZyM3lZC78pUif0e8/DsNEyVDD4=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-2NVf/PcpSB5rYk1KyMGplCVldJ5sz2OIoa1XHO3uNEM=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-bCJ4IHs3N/hvKYMs10IQAipVQDudbbCOwFavKU+ZU0I=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-LjGBEuNIrNU3ZllvhfArKHaq7vjlCwJwFC2RzXYNlTs=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-v3Ilc+MjOT0P+/TiCQ3lxbk+LuLVG8UjKzlzVLODtUg=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-Ms2KFBiBCvywzvD+gDToUQ8GOwDNcOCy+N3aiv+kT7o=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-4uATyz5SpnhvqmvqNfHCB2EfnR3R4yNgTMBcoH+gu4o=";
          };
        };
      };
    };

    # ── torch 2.10 ────────────────────────────────────────────────────────
    "2.10" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-IgXw5Ou2yqGYRQlQ00T+ckqrMCULHyZH8cFOFRGWngc=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-aQmri7UEoy07B9lwtuC52sbfoo4lIDCJ6o4VWQiOSrg=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-8S3zOl0pOquehApe2SjKLMGjJ5lVetaC6JzZMvky0Qg=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-f9epy+JxyfnsmU6zqkF9LRme7XZDwsqbZYzSRxZrXPY=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-M1JKV2IpsogzxPq7FOscVEQtnInD6lGK2vMDTTWpWfg=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-d3hBgBnTw2qZUePbIvTmlFnQboGYeDQZeCtfvbMc+Ok=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-X0FiSUl8sbQYYCJtTD9+Jfs6bu71gEBkBJG+BSnTuwo=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-9/3JsAj38z/7G3PAgIto7oKBA1mJWA5u7IqJ0VkzA9g=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.09 ──────────────────────────────────────
    "nvidia-container-25.09" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu13torch25.09cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch25.09cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-5kEQBFIP2Wkw+arGCKDHrEd+YeBID8a2qpyXAiJW4vw=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-fJRlQNv0RBZY2Yurh4brTOxp1kiFYuN4uxTaYJw1ECI=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.10 ──────────────────────────────────────
    "nvidia-container-25.10" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu13torch25.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch25.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-qQpXkX00R7fAl3bt8mmP+5LAjhFj1PhB4fDF4N7W5iI=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch25.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch25.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-iFW8FeGX2AdZ7vatT2jfLwrkALjmezIxgdL4QU2JKC4=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.11 ──────────────────────────────────────
    "nvidia-container-25.11" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch25.11cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-tdts3kVg+XH2cB6lJaNwuVqvzLXbpWqLar+GwgHqSwk=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-XNygyZGAuBAjHOv0WKWS0WIzApSCsQ4BVYSNCX5Izh4=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.12 ──────────────────────────────────────
    "nvidia-container-25.12" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu13torch25.12cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch25.12cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-Yd8QIA2Ni70bgOCh2ddDar5bAXIubS62vrZk+/Q5pwE=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch25.12cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch25.12cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-P8wlJUlGhxuNvLy3xaEBcawoGu2Ch3udtIJjZNzDfhg=";
          };
        };
      };
    };

    # ── torch nvidia-container-26.01 ──────────────────────────────────────
    "nvidia-container-26.01" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu13torch26.01cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch26.01cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-+U5UK5WHIScvY9OlCJt0OmFr+HBUoMQqT8B0j3MmmjE=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch26.01cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch26.01cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-d7DAEN3l6qTln9JH4q2U2ELHza6PMqtS0eMEoYPDj6o=";
          };
        };
      };
    };

    # ── torch nvidia-container-26.02 ──────────────────────────────────────
    "nvidia-container-26.02" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "causal_conv1d-1.6.1+cu13torch26.02cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch26.02cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-9oExxd1LPAk/xAe/UhE2LPEx/5LTfzUQtbP67n3nv4I=";
          };
          x86_64 = {
            name = "causal_conv1d-1.6.1+cu13torch26.02cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/causal-conv1d/releases/download/v1.6.1.post4/causal_conv1d-1.6.1%2Bcu13torch26.02cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-AJ6+kMZlECV4eZbf+uTpQZwP8N23R8OcWj2Ci0cJa9Y=";
          };
        };
      };
    };
  };
}
