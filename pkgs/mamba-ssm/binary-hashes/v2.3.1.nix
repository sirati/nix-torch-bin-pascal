# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/state-spaces/mamba/releases
# To regenerate: nix run .#default.mamba-ssm.gen-hashes [-- --skip-source --tag v2.3.1]
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
  _version = "2.3.1";
  cu11 = {

    # ── torch 2.6 ─────────────────────────────────────────────────────────
    "2.6" = {
      py310 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu11torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-dNJO9ijyvHrm1Q46dU9IfAqdJ9BFL51XcuRy6MaM0RU=";
            precx11abi = {
              name = "mamba_ssm-2.3.1+cu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu11torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-qoarHRYxneSW9u49DUNdXTS5bFW5GHELBNEvWu6BAUI=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu11torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-1dL4ED2xGUDABbz13V9QXGCLBuYbkn4LIEnXETUop0I=";
            precx11abi = {
              name = "mamba_ssm-2.3.1+cu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu11torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-kJyLRjkq+YuG2s/jwSEZ+/lmigvM0QecUvF7r2+lezA=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu11torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-eDUnKLs84H6X3bJ4M/0mf+/ERwRTFEHfZv88W5Y+JUg=";
            precx11abi = {
              name = "mamba_ssm-2.3.1+cu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu11torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-S4uN5Ks9FUNY23afaGh9bauBp77M3/ejOTuD5U6eFco=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu11torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-E/jvam1oIYvVJaLIHzpEMROZQWW4zvhEH2oNkCruJkg=";
            precx11abi = {
              name = "mamba_ssm-2.3.1+cu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu11torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-g1dq8iwwEZJvMNbEHbVGkm8rkmnWWEbM9p3zP7gmLsY=";
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
            name = "mamba_ssm-2.3.1+cu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu11torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-RYl0dVJ8zINUli37pn051rqKYGabNj/5ed70LuhCVgw=";
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu11torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-/Fv1o4hDXI5EbIPXCmg3wc9CmXSMu6tGwF+ZWf02IMU=";
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu11torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-nhUGVarHVfq9fD4ebTZY0DyvQMdZrPhl0raxy6mRAzE=";
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu11torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-Ah+GbICiAgoKCMNfDAW/G0cFKoUE9wzUh6DX5DLtqCI=";
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
            name = "mamba_ssm-2.3.1+cu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.6cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-6N1LLnXtzEcAkV+Ddyf961J4Vmv8COjmTIlxD8mOOUo=";
            precx11abi = {
              name = "mamba_ssm-2.3.1+cu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.6cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-fSPJihiNHVEBnAAx8IMxczn1PF5FGuBNncX9I2binZ8=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-Et2ksVfDSdNAQmnlTqg4jjs1NvdB3Wv6Xc/fnFSuccs=";
            precx11abi = {
              name = "mamba_ssm-2.3.1+cu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.6cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-iMbZacOb3Bay6FOEBm+qVKOdPf0byNHaOniwKCLi1nk=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.6cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-uACaZ8EpAXco8aCE6RY7H594vIsDcWazwjullNeDjO4=";
            precx11abi = {
              name = "mamba_ssm-2.3.1+cu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.6cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-mdfuVx7Ls3Ujt8gP8mYkyHFWYy6nSCZrU1ErrcpdF3M=";
            };
          };
        };
      };
      py313 = {
        linux = {
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.6cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-jgqwE1DbDb3ekJHhJlHSoUSEZYeP7dtCzpiOG07NFcI=";
            precx11abi = {
              name = "mamba_ssm-2.3.1+cu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.6cxx11abiFALSE-cp313-cp313-linux_x86_64.whl";
              hash = "sha256-rbt5cnIwQpWlosH4XuZVCPFPucE9/PTdV8ByGiBiaUw=";
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
            name = "mamba_ssm-2.3.1+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-b89X49GchIvACjF5bQFitP2iolQRNXn/CBcgTzkDbE4=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-s08lZMId7frcWkepIbNt9Cd8Z6/q2SpMq99KVtwNjOs=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-2x5vfdFjZZ9oxIRsRepkN4uArDc8IIfj4O1z5bp34ks=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-JuGQ9mbIwBJNfW7jc8u2JHH7j9yCO+PLRstCnK7QkOc=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-8j3JU6pmbd31jHe4ibUuE5RuhaaVQsrjs9tJW4Iy4Oc=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-Sld3xozLKLlZ6mszgzQmZCFkyhd1Ov6U2sw7PqDmzMk=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-Liccazy+c2Nu+8EVwO/9MNRTGiQAVN8iuef/xB36sa8=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.7cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-NHgStzWFfkZMKpelKre4I6Db40zTzr+BBRf8dLIv9mg=";
          };
        };
      };
    };

    # ── torch 2.8 ─────────────────────────────────────────────────────────
    "2.8" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-IBihG0Vv1m0DNekkTrwjh8i85BWETFZxzcCX7FTDmb8=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-NDGq6jAOurLLBqzBO3ESgzvbs8jA1QOPEBUnICsn7dA=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-7TUKJbPVcPVNG7G4UZT3RBbnt06319Vk8kl/es4HqS8=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-fMDeqMeLY9ekUKpCclBVoldxomzjZhsyFoGEX9w59cg=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-NbOJHfnUYSQSklJGczpL56BYLcIawmknLpFOiAF/AuI=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-+eN1tHzuHvJ0Y8kkkHP5Bl8Pjw+Ysy+r+7jfS/deK2Y=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.8cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.8cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-6sD0LEB8KREsFBBhKHUaV8WxRtk9QYV+Nk8oFWfKHWQ=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.8cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-/ExKX2DbGuixbpE7Hw7thBokarbpFhehfqG39WJZzw0=";
          };
        };
      };
    };

    # ── torch 2.9 ─────────────────────────────────────────────────────────
    "2.9" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-r3KgQ2aS+4GljoFppfTYZNFKWQbwpq7mAbpUpDOJ90k=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-TuHfOrM9pQZhbjXkdZ1o5itlJ6c7EA8OEhfBM788NpU=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-7Wh4ssQEP7cKtqAQhq8d0iffrU3/VxJGNum3Hco1izU=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-L/IXF+vxV0HIyCsk1lGF+BMZPi4QqSasqcNLDNYkguA=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-h7hup3NXCRwWuD2G2/zMNaLvDQDMmUntPL0oYym2z38=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-jQeawTSXvP0zn5OqBoedGDBCTWsX4fxASoPbYaQjFuI=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-FbnAaCrDfjDJLWiPn6OZu9a9M+KyqokcZdnYgDC/q1w=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-TcXtuZYvuk4MmTf9i78gYsMvax7Wda5W3jevNrvs8DM=";
          };
        };
      };
    };

    # ── torch 2.10 ────────────────────────────────────────────────────────
    "2.10" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-JK2VJ11jbQjSUmCkhhWYJ7Sl4TuCkos2VU+JCnEXmug=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-XQDdrZgOnKEHpP+CHXcR/JBdExG0+nyfA34LyYemIVU=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-Nr+zHR5Qh/TrBnufMSZyM268yua1zRIEHajM4KSnMkE=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-BOurCWgFjGRZLri61D6nqKQqyZJ7LYhnmmDn2mz5B8g=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-gE+PcPxn5CBwX+VXE7YeafPDubWXghKFFq8HY4IXu0s=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-1mo8TJSmk+AtNBys56avC3IXe2r6ZVol46ZQUTCmjL8=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-p+6AWOQYbg48anmaD3P3qBikiZD82YAYo8TcdUM9avs=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu12torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu12torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-8w6DfcwC8RjinmUC7QnPz7bqO3bHjmuEnzndYTjs3gQ=";
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
            name = "mamba_ssm-2.3.1+cu13torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.9cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-lQlPQW731WffKb4fabaetq2bPQVEnKpOUle55rkh5y4=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.9cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-nr8Q2rHO9S65HHuuKTqV/3Rvy12gE35OrUkpJWG/unQ=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.9cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-8i7CH9hpOrO5iIiumVZC09PGxtfee4wFCVv+qtsk6q8=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.9cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-ueRzNaclcIj0mh9E/ImoeFlN9o/HtViyxTPwrDzVrAg=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.9cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-g0gt8FinwQAVIXb1D40RyQfVy43KjScGxNSOQTBARy0=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.9cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-NB0WvjG5iwxQb7ZgxdVFjXdymNfrnIZQe8uB/oWY62Q=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.9cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-fzovmUGgy+7+wyhDMbSEi7R7yKHLIjhQ16cUJ9Z6FKA=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.9cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-Pa3O6fvOCcRXO4BWk6mNA9wXserpWhfl8Fzujc4e1DU=";
          };
        };
      };
    };

    # ── torch 2.10 ────────────────────────────────────────────────────────
    "2.10" = {
      py310 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.10cxx11abiTRUE-cp310-cp310-linux_aarch64.whl";
            hash = "sha256-Aswf7zyhxZXzZULYBo5T64CfuWH9SD6CBIJ9LGvV9pU=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.10cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-qNGKIGqmzSUfZ9ISEG617M8VsCI+R/KbslJSN81UPSk=";
          };
        };
      };
      py311 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.10cxx11abiTRUE-cp311-cp311-linux_aarch64.whl";
            hash = "sha256-H9vWHcnY4d6wmd3BuMQ/dVXAHmI5ozALpx+mrLRpr/g=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.10cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-jB+K2vU7UeEKnzwz4rfYRFiuFPk6MlMPaVxUrPzUaQE=";
          };
        };
      };
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-5HUGBGUv+UAfVEJC4s4xsVgRKtGhsGh51sLa56JDNto=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-BAhqCl5MRPeWBFc7YDIjvNwqjPGtvk1a1ECX80DdkB8=";
          };
        };
      };
      py313 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.10cxx11abiTRUE-cp313-cp313-linux_aarch64.whl";
            hash = "sha256-7lOHA0gHYY7jvHWSuQZUga/UJhCvXyLai8e//MB1u0Q=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch2.10cxx11abiTRUE-cp313-cp313-linux_x86_64.whl";
            hash = "sha256-7j+hOJ80EexDjbJhdtgidscoE+XzQ74Npeda56Z/kU0=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.09 ──────────────────────────────────────
    "nvidia-container-25.09" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu13torch25.09cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch25.09cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-ekaUvkUOehy2jpt69uEDbty8VKbJB6hr8OmiuSd7gZ4=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch25.09cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-a8h1NfQrKiLWwDGtwRWa/Sf3bS0sG75+Qaepz2/jzxM=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.10 ──────────────────────────────────────
    "nvidia-container-25.10" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu13torch25.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch25.10cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-N8ZUXU6iDfNASHLTQWHKR3KwsEC+riLTdzsPH5dJNwk=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch25.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch25.10cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-YJEFgZmvLv5kJvn9Ld8RDB6JkMw5hgFEB8AfmivB2S0=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.11 ──────────────────────────────────────
    "nvidia-container-25.11" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch25.11cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-it52fy9feZTltI/pvhSjqGUiaLx7QvMTqBxHPqLQ1ZU=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch25.11cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-gIeD+rIauSs+9aipq68n7Bep+zKS8Oob5EC3fwBl0VY=";
          };
        };
      };
    };

    # ── torch nvidia-container-25.12 ──────────────────────────────────────
    "nvidia-container-25.12" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu13torch25.12cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch25.12cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-5/2mVec6NOMhGJM336qBuYTbMXWyqpLl+28ae7e6OUQ=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch25.12cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch25.12cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-STudlmVALG4AomBykslgSjJLPRhHQ86ynhkKl78l3pA=";
          };
        };
      };
    };

    # ── torch nvidia-container-26.01 ──────────────────────────────────────
    "nvidia-container-26.01" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu13torch26.01cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch26.01cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-cVFA+x+oMATIA73n2OMF/7xze2bkGKanDqr3AwK1l4I=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch26.01cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch26.01cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-uBjgo5zbU73N5FUMiuvnITY7GKxxSvXMM7P5ZVZH8WU=";
          };
        };
      };
    };

    # ── torch nvidia-container-26.02 ──────────────────────────────────────
    "nvidia-container-26.02" = {
      py312 = {
        linux = {
          aarch64 = {
            name = "mamba_ssm-2.3.1+cu13torch26.02cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch26.02cxx11abiTRUE-cp312-cp312-linux_aarch64.whl";
            hash = "sha256-agUeq7pTC10IrvoOfJS1uhmuhQ6amTwzHZ6uyIdOSFU=";
          };
          x86_64 = {
            name = "mamba_ssm-2.3.1+cu13torch26.02cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/state-spaces/mamba/releases/download/v2.3.1/mamba_ssm-2.3.1%2Bcu13torch26.02cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-rqiHXwwujIPiFRaP80eY1FQvP2CCU5zKv/p45mRo/3Q=";
          };
        };
      };
    };
  };
}
