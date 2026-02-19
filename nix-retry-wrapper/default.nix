# Retry wrappers for compilation tools
#
# This module provides retry wrappers for various compilation and build tools
# to handle sporadic build failures. Each wrapper will retry failed commands
# up to a configurable number of times (default: 3).
#
# Wrapped tools:
#   - Build: ninja
#   - GCC: gcc, g++, cc, c++, cc1, cc1plus
#   - CUDA: nvcc, cicc, cudafe++, ptxas, fatbinary, nvlink
#
# Usage:
#   let
#     retryWrappers = import ./nix-retry-wrapper { inherit pkgs; };
#     wrappers = retryWrappers.makeAllRetryWrappers cudaPackages { maxAttempts = 3; };
#   in
#   # Add wrappers to PATH or nativeBuildInputs
#   buildInputs = [ wrappers ];
#
# The wrappers use the same names as the original binaries, so they replace
# them when added to PATH during builds.

{ pkgs ? import <nixpkgs> {}, gcc ? pkgs.gcc }:

let
  # Generic retry wrapper that works for any command
  makeRetryWrapper = {
    name,           # Display name for logging (e.g., "ninja", "gcc")
    binaryPath,     # Full path to the actual binary
    maxAttempts ? 3
  }: pkgs.writeShellScriptBin name ''
    #!/usr/bin/env bash

    max_attempts=${toString maxAttempts}
    attempt=1

    while [ $attempt -le $max_attempts ]; do
      echo "=== [${name}] Attempt $attempt of $max_attempts ===" >&2

      if ${binaryPath} "$@"; then
        exit 0
      else
        exit_code=$?
        echo "=== [${name}] Command failed with exit code $exit_code ===" >&2

        if [ $attempt -lt $max_attempts ]; then
          echo "=== [${name}] Retrying in 1 second... ===" >&2
          sleep 1
          attempt=$((attempt + 1))
        else
          echo "=== [${name}] All $max_attempts attempts failed ===" >&2
          exit $exit_code
        fi
      fi
    done
  '';

in
{
  inherit makeRetryWrapper;

  # Pre-made wrappers for common build tools
  # These use the SAME name as the original binaries so they can replace them in PATH
  makeNinjaRetry = { maxAttempts ? 3 }: makeRetryWrapper {
    name = "ninja";
    binaryPath = "${pkgs.ninja}/bin/ninja";
    inherit maxAttempts;
  };

  makeGccRetry = { maxAttempts ? 3 }: makeRetryWrapper {
    name = "gcc";
    binaryPath = "${gcc}/bin/gcc";
    inherit maxAttempts;
  };

  makeGxxRetry = { maxAttempts ? 3 }: makeRetryWrapper {
    name = "g++";
    binaryPath = "${gcc}/bin/g++";
    inherit maxAttempts;
  };

  makeNvccRetry = cudaPackages: { maxAttempts ? 3 }: makeRetryWrapper {
    name = "nvcc";
    binaryPath = "${cudaPackages.cuda_nvcc}/bin/nvcc";
    inherit maxAttempts;
  };

  makeCcRetry = { maxAttempts ? 3 }: makeRetryWrapper {
    name = "cc";
    binaryPath = "${gcc}/bin/cc";
    inherit maxAttempts;
  };

  makeCxxRetry = { maxAttempts ? 3 }: makeRetryWrapper {
    name = "c++";
    binaryPath = "${gcc}/bin/c++";
    inherit maxAttempts;
  };

  makeCc1Retry = { maxAttempts ? 3 }: makeRetryWrapper {
    name = "cc1";
    binaryPath = "${gcc}/libexec/gcc/x86_64-unknown-linux-gnu/${gcc.version}/cc1";
    inherit maxAttempts;
  };

  makeCc1plusRetry = { maxAttempts ? 3 }: makeRetryWrapper {
    name = "cc1plus";
    binaryPath = "${gcc}/libexec/gcc/x86_64-unknown-linux-gnu/${gcc.version}/cc1plus";
    inherit maxAttempts;
  };

  # CUDA compilation tools
  makeCiccRetry = cudaPackages: { maxAttempts ? 3 }: makeRetryWrapper {
    name = "cicc";
    binaryPath = "${cudaPackages.cuda_nvcc}/nvvm/bin/cicc";
    inherit maxAttempts;
  };

  makeCudafePlusPlusRetry = cudaPackages: { maxAttempts ? 3 }: makeRetryWrapper {
    name = "cudafe++";
    binaryPath = "${cudaPackages.cuda_nvcc}/bin/cudafe++";
    inherit maxAttempts;
  };

  makePtxasRetry = cudaPackages: { maxAttempts ? 3 }: makeRetryWrapper {
    name = "ptxas";
    binaryPath = "${cudaPackages.cuda_nvcc}/bin/ptxas";
    inherit maxAttempts;
  };

  makeFatbinaryRetry = cudaPackages: { maxAttempts ? 3 }: makeRetryWrapper {
    name = "fatbinary";
    binaryPath = "${cudaPackages.cuda_nvcc}/bin/fatbinary";
    inherit maxAttempts;
  };

  makeNvlinkRetry = cudaPackages: { maxAttempts ? 3 }: makeRetryWrapper {
    name = "nvlink";
    binaryPath = "${cudaPackages.cuda_nvcc}/bin/nvlink";
    inherit maxAttempts;
  };

  # Create a combined package with all retry wrappers
  # These replace the original binaries when added to PATH
  makeAllRetryWrappers = cudaPackages: { maxAttempts ? 3 }:
    let
      wrappers = [
        # Build tools
        (makeRetryWrapper {
          name = "ninja";
          binaryPath = "${pkgs.ninja}/bin/ninja";
          inherit maxAttempts;
        })
        # GCC/G++ compilers
        (makeRetryWrapper {
          name = "gcc";
          binaryPath = "${gcc}/bin/gcc";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "g++";
          binaryPath = "${gcc}/bin/g++";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "cc";
          binaryPath = "${gcc}/bin/cc";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "c++";
          binaryPath = "${gcc}/bin/c++";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "cc1";
          binaryPath = "${gcc}/libexec/gcc/x86_64-unknown-linux-gnu/${gcc.version}/cc1";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "cc1plus";
          binaryPath = "${gcc}/libexec/gcc/x86_64-unknown-linux-gnu/${gcc.version}/cc1plus";
          inherit maxAttempts;
        })
        # NVIDIA CUDA compilers
        (makeRetryWrapper {
          name = "nvcc";
          binaryPath = "${cudaPackages.cuda_nvcc}/bin/nvcc";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "cicc";
          binaryPath = "${cudaPackages.cuda_nvcc}/nvvm/bin/cicc";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "cudafe++";
          binaryPath = "${cudaPackages.cuda_nvcc}/bin/cudafe++";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "ptxas";
          binaryPath = "${cudaPackages.cuda_nvcc}/bin/ptxas";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "fatbinary";
          binaryPath = "${cudaPackages.cuda_nvcc}/bin/fatbinary";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "nvlink";
          binaryPath = "${cudaPackages.cuda_nvcc}/bin/nvlink";
          inherit maxAttempts;
        })
      ];
    in
    pkgs.symlinkJoin {
      name = "retry-wrappers";
      paths = wrappers;
    };
}
