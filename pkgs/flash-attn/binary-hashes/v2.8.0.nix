# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/Dao-AILab/flash-attention/releases
# To regenerate: nix run .#default.flash-attn.gen-hashes [-- --skip-source --tag v2.8.0]
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
  _version = "2.8.0";
  cu12 = {

    # ── torch 2.4 ─────────────────────────────────────────────────────────
    "2.4" = {
      py39 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.4cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-4CVfaWUiB91yP3iNL/lOfmeZzQQMJEPcwhE496IDOaI=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.4cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-m8aWPUYRPrcAF+jbIWM9iq6YqNVEVenPZ/WNPwGl1/E=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.4cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-mHFmA+A2Gpro10lwUrzDHen47KJq8nbX4QDRJDONzGk=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-HuMI/IJYVi4LVTWwtklUTt1o2gSoS8StHwItHwm3dbk=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.4cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-mPBXp76kp5cKevgCDr5EOjY1SLgEtIgJxK12ldEBsUE=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.4cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-sdHXukjevJaPdAzvu9vyaTFgp1oG/GBa1vpFJllLgIE=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.4cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-Xs+STtqFlqGaflmd7jTEYgSaR+VmShD2hCP9ZQY5+8E=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.4cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-DfLvnLmx19JRmz5fZ4DsSlnPlcJRV5qztMQwz2oK2Y4=";
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
            name = "flash_attn-2.8.0.post2+cu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.5cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-p8WwS93yCdufRnOxesiofZocvYDo/14whJec35kUtbw=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.5cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-VyXXe4Ovzk3E5lvi+PERzEW80uEPrhPM52i2jPJJn9A=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.5cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-TGEjHK2vbfg5/6Dp09RTtNgve17qdPUo0llULQIC87I=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.5cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-BDv0v4RqLWijTCEL85Kwr25fsz8dWwx/+m1YN/HzOOI=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.5cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-qhu+xEICdlVpqux2a4O5i6L7BC3wXR1qkNdyCDW7osU=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.5cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-2qpojxLFoy2nRXfpCaICI4mdKu8G22uF6IFqs8WG9/c=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.5cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-UBHl70tBdFYAJ3Ifvkmz/mv0MDiEPrPIGuu1jqlOP/A=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.5cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-jcBQeVqy5CXUYJrSgmX8Vpsfr87JngTuGPpbGV3a5TM=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.5cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-y3r+c9KloWh0CgU9Eonu4cJhiUfuWLKzRrU0o5J9ZHg=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.5cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-glEmeq0qHsDiR0pN+Ez8c8/gAtXChpPAKPxETgjlLoU=";
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
            name = "flash_attn-2.8.0.post2+cu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.6cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-3DeTCTmebFtpjaADILmpL0HhzXsZUUnOfCPLaGbvCyM=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.6cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-PnmCr6XijdXAaLrJRz6G2dfH+2T2qj5WDCYaGoVAk7E=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-lDStplgFkZ1qLsZQq7QoWntMExBuf3z1yzuAs2bhcp4=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-sRsPb9Nm+g4KNfqqXJ2fa3L81Y7ZbUx0KbwW5Rpg1q4=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-olZuwMxs8jMCUgMPi/Qfh/6hFQOiEeH3a1UsA404r3c=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-5+j9DVARLjMCqW/NW1rkYGvTjCChFJ/GZv7VyHulqcc=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-eA8hvkbpZV9+e2OuoTZD1QphiBtVm71yli7LXHCN/y8=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-5dVSOaplHxnceAvtr0e0cKUUvuW22i3jImTOE0zPXO4=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-bxjYaDyeKU4FfS95+5vWO/aJc5adOwrS2Y8G5F3DrCE=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-4+STE/IHl1LkywyjDFAKfRVm4qlKMmy/3KO9AW15Oeo=";
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
            name = "flash_attn-2.8.0.post2+cu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.7cxx11abiTRUE-cp39-cp39-linux_x86_64.whl";
            hash = "sha256-n2vAmcjZfxGt6LHm1102pmOqaMnOAY9QrQWHGEM4kTk=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.7cxx11abiFALSE-cp39-cp39-linux_x86_64.whl";
              hash = "sha256-LBI9QmEhmd8kgyEwwTYCQgf8TMyS5T4f8ZrltYxv9SE=";
            };
          };
        };
      };
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-jXUCgXqs77kGoG2ZG1xXd+y8VBru/Xb7RkZqqnh/ADQ=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-WdsHV+R6L5MsGqF2APb8vW0l1iklLmtXjyPSCwmNnWM=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-jtcawJL4CwedLmBDt2kTWQTW6DSRbLbafTcrOUWBRHs=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-FFLytyc3m6dTug2Wxhfkz1xKHqGlFH3l4QMv+jqXoeM=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-/FlrBB5tQ80AiGpHFSNKzNdajpOBPI7QrRe0dGZpNhA=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-Xr5391Jn0wDZ89J83cz2Yj/O8Q9wLIW3QUgp0Ot7m/k=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.8.0.post2+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-sBTEGSM4NpXSVu80WGlfl8PNA1XFkNjV/YBL37P+dVY=";
            precx11abi = {
              name = "flash_attn-2.8.0.post2+cu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.0.post2/flash_attn-2.8.0.post2%2Bcu12torch2.7cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-paDQwvdXfFacicStAZCwTB3FaylSu6md7Jh67X2ZfV4=";
            };
          };
        };
      };
    };
  };
}
