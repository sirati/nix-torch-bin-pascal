# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/state-spaces/mamba/releases
# To regenerate: nix-shell pkgs/mamba-ssm/generate-hashes.py [-- --skip-source --tag v2.2.6]
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
  _version = "2.2.6";
  cu11 = {

    # ── torch 2.4 ─────────────────────────────────────────────────────────
    "2.4" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-MNjmDiv4Q3umgfCciRdeprTY/b/qN92Cd+FgZZop4yc=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-TsIHNHasl/iBZ+uQuOboXg5acqcJg5BPGYlmTLN7Lb4=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-LmLIdHRxZCPX2o+tURia0dqRtWpS8fA+cZHdmrikUJg=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-XZ/boJRdJy4EyXsU6/JjAcw2VDWSOYkVw4LM0GWjy7o=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-THT6tk5FltGCk53CywTca6le4wsaUiH0E/PDVKVhiU4=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-0PkkMoAJxqtB4ljOWiA9HUQFtv+iFXO4+zTqc4C81dY=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-gKzbqBJ9076Qp+782ATMUXVskCEEYmSk5uGMzS8OBDg=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-iJjiTLqVs/9uJnSkzZimlOpn3ShAySOpBvTVr+ADtg8=";
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
            name = "mamba_ssm-2.2.6.post3+cu11torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-aZVdZ1SRXhh3mugEpIOzy0zcmhGqtj+MRVd9DxXil4Y=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-hzFvcWYRJK2PSNk+iD8tANLn+/+ILFosPQlBQv9bhq4=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-EwoKbxD7jChiHt8WQP3Kje6zK9TjSE1O1xzY2jVNEKc=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-Xa+Ys1IeqeHKwie6UP8bjil7SpdskiAn/O8JC5vs2o0=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-jMNTvk1bWKpQtWwrVfOXFVjjgXw2rDxKdKw5njgy4so=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-z4aUl5Ic5nZn2RMhpvgTcyLagkRMt6wpVfvOmhEkJVA=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-C/vEAXr/lf+AhYAFzqX58ZsS2MQydPtfKaWOZFSaqoI=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-eBJLE+gbQOuDKIJszoJMLzDQEId1iI80PnS1Gv6IxXo=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-Iez9abE38SaWKc+l/RniwF32h74Tda5PaOyPwzrfci0=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-OA9wX6+/VE9D22n6VM7mzAwPr+/qd9htrMITonSRwz0=";
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
            name = "mamba_ssm-2.2.6.post3+cu11torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-If4ZWcDxjJ0/5jKB38fig5qziIoSBnHliHZCH54Dz44=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-1KhjU/AtPyYsXIS8/sH7FSgAlYO5jcxhRp7QbsYY2Mc=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-J3GI2iSXhoqE3Sgi/uiLNSjwD2VkDBlgZrhkE5FXHxM=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-uyorgkBRH5aQDLnP+rlG4BpZ6+7VvFwm/ma3e7ck7Jo=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-xNhx6agR2OHB6r1+kFzQharZ/qAIaFibpclN7nb30mA=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-pVpIzAq+uCpVHH6AKs15uagDAvWzTDcyOP16ibvFHgI=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-wY5ZPVvf428lG2sUpgvWCMmmjhDARlW7mRIE22Zshos=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-QBsfOWOKnWW8KPbduleo04P4l2u/ocmGQmDAGJGZr6M=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-ajUZkwszMIg1bGRZXuGvS2OgGoq19tJAPTt1MklFf9Y=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-DSb00ALTbf8LCRp1iGhmDA5oudD7u+ipsIv/sq4nows=";
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
            name = "mamba_ssm-2.2.6.post3+cu11torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-qyoBD0QmzPuC5jqZLw0qBr3/qR1pJZCkmsuFiw95Vq0=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-wOJ11BHLHYvQ3Hh7AZKLEB84jGpjuCBkiUHX9R0UQrM=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-UPC7AnpppAr6Jkm1jae6E1JaNyYrc5nRGxS7hoDxPX8=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-znQnSomiygV4AMO8ccMgOexmWNRObBZwpRt1H7HnShk=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-aRDFR94b42Q9kKE+ALn+8djHQGHNrsqfTd5S5WSzfAk=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-57PLP03FxRkoyGzJcHjy9ugHMQrlBBPhXee8BJln6t4=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-o5XBlFiC9ogPFeMNxooIn+ToylUZst2FkBgSD9n+m8k=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-BVBjJefVSiejU8/ZJCPNrl/sYr8ooOPrMGZP6tF88m0=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-agyAanA683gpOiXA5ZBRytUpAEV+o1ZNkE5u8X0675o=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu11torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-qKO2HVTUPE4fPf3aqCX2RjQt9K+ohVZG1fj8SSzCwvw=";
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
            name = "mamba_ssm-2.2.6.post3+cu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-l+ueHD6uW69t2GouiL0awAsNhb9P5KIL5rlM0lBFmpM=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-zMO6Lr1kCHX4lLtb6trKwQRHdUJ34hBkGPALsyYlyog=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-bibYSP5Ze79ktl3jswxSnp3/VxzRJM55HgYWY1zUAQY=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-IZGOLkaOxbdDzVl7GKgF6nhM5natPqZW+I4gu4xKW84=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-Z/2jNMwsnYryj+zBcE97hJ8pXRVc+ZEX0IkqjyxgtHo=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-wwvp2DJPiF+CNEagTtzg0nAq4WA5l+3Ut+GBpMZGqmE=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-v7eu+tcJN6bpxGVxhmM0SacHAO+rmh2BxN1OvyF1zNQ=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-ESScLzxNnC9tKXOC/GojNZHRFa/oDT+NZF9aZBAswVg=";
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
            name = "mamba_ssm-2.2.6.post3+cu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-DHdN0RgrqjWTMDty4vBFC9JHjmvMkRkXRzaGKOSzP4g=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-F4p2kHX79Q4D1wUI36FVrpFQEuu4AMRwpJaWNUb27/M=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-6w+Xjhw+6xTLGFedqJlnYjfbcxLVtJw68LWGLRegOYI=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-tpw3ibkaQdiaHocWdQCwRzwi+Yp34zjGD0wUEtASeVA=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-tnrwQLEB3ETXOPtFgudVoJdkrj9xl/UpQwaezG8Qg2w=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-gMavJTqlK6IVUiiWSUa4I6YRhnkKrVHFVhbIaIf35Z4=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-mnoWBXZpeGDRI4qAmfxz3Un19hflPSP5XH4yNTSWJWw=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-VXAiisukyMKBx+ZjP7G5rBl3BWUbxTxOieiiLxNMKx8=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-Idq/U3bZW3I7XSnYZp3Bw3gA3ezUbVpzBXPtkKf1oec=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-oCbecHINGFWHTYc6b6KN3qUpnw647qLwzt1RqZMEDw4=";
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
            name = "mamba_ssm-2.2.6.post3+cu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-LL18quMA+qsCFf6nsXpyMBLftoh0hOxVPmWhCK+YHYw=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-yWbcCC4QoinjdiDAiqdJHjpDZXIFyOBDpHa5pz+J4Aw=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-S2FEQqCV2ec68u+aJLFMF/pwt6cNxt6Fc9tmfEPxb1I=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-oBDf2q8OtJrhM3km/lXPMyDEqs3TsSnPUGtTdgKrH/Y=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-nUreVTiptGz7qBTTTPTxA77/iC0YJV1RGzU8/Tq/ivU=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-d7Wlrq7VafT+pWkzIIPKKa7ORrJqoGUVnqBTkYgIwRk=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-/bwOwkM84rJUsQZxu94EgOiDBM2/mx5XImj2he4Hpsk=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-jB/XyFxL3fxov1IVlcBMF9H/VCR97ybfDfiglVePdaI=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-5em7z47sfGCRE0xcOFumMSncILfIKWgws1KsxRUC12w=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-14OLo2bBszi1ZPzjPPdXMVm9iKj15NYk7ioWUwCfLoo=";
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
            name = "mamba_ssm-2.2.6.post3+cu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-QN49P7P9sX8EiZWKTrvriQyOjh/uBTrDU5d/VXXXOVA=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-Cl71AtdELQBoF/JZDjhj9Qc5scKwXhd3jS6gcwO2F9A=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-jhnx3XW2fG9lQztaAqAJzqsDFmQwsWx5g4c7fxYMMFY=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-BZ83QNgRqAwbsJrmrw9y8LoZoo72QbT6NmBmQ8xZPH0=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-NqXhppHP5qOMFPNpz0m2W3JxcbCqNyDplOuTi8SSzGU=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-0O7tJet/IZDaZKoXUDBJH9cS9Zu38A6eMVw1OBVTYv8=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-Z9ffaNyc8VAHxqvJ2l5lD98ovjYVOY/8jFbTOQt+JxQ=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-s/Li+TbVdFoTMNdTteIK2FTOvH82/cNhtyjsU1EeKJQ=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-U2EW1e8+jHQllsBEweKN7KQmUuvi/XzmazTs1BhgW64=";
            precx11abi = {
              name = "mamba_ssm-2.2.6.post3+cu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-eEiKZBoU/iMvMvsM7IVPt+s9ayC1+EBVvVdMoYA+g2I=";
            };
          };
        };
      };
    };

    # ── torch nvidia-container-24.01 ──────────────────────────────────────
    "nvidia-container-24.01" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch24.01cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch24.01cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-1RAfPG0rMPwU/1IP2AH1xfoknMq2ob7SLUGtQgwXTO4=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.04 ──────────────────────────────────────
    "nvidia-container-25.04" = {
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch25.04cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch25.04cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-UYAIXkR7hWPYDhcykgkfB361bgKJWs7wBORTqj2DWDs=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.05 ──────────────────────────────────────
    "nvidia-container-25.05" = {
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch25.05cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch25.05cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-h0rqpIUFJlDdzOv1yLpAkSTGt5uN2Z5S43XwcVG0b/w=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.06 ──────────────────────────────────────
    "nvidia-container-25.06" = {
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu12torch25.06cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu12torch25.06cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-zi4WW2BenCAo4lljy7eZWQItIxThyCwGTxyF2Na5Jfk=";
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
            name = "mamba_ssm-2.2.6.post3+cu13torch25.08cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu13torch25.08cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-dBGj/wHbBcsDwLU+Vv+Yz3WUeoR+T0e9uIc187sEYOQ=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.09 ──────────────────────────────────────
    "nvidia-container-25.09" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.2.6.post3+cu13torch25.09cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu13torch25.09cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-2jxgYObvkIcrSj0R5ZN/9qo1A8wV37lVtixdlr7xEoc=";
          };
          x86_64 = {
            name = "mamba_ssm-2.2.6.post3+cu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.2.6.post3/mamba_ssm-2.2.6.post3%2Bcu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-n9DkAZhsRD3DqR/0x8oWqQFTRzS/AatcG7Bad0pKwzQ=";
          };
        };
      };
    };
  };
}
