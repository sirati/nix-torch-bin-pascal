{ pkgs ? import <nixpkgs> {} }:

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
    binaryPath = "${pkgs.gcc}/bin/gcc";
    inherit maxAttempts;
  };

  makeGxxRetry = { maxAttempts ? 3 }: makeRetryWrapper {
    name = "g++";
    binaryPath = "${pkgs.gcc}/bin/g++";
    inherit maxAttempts;
  };

  makeNvccRetry = cudaPackages: { maxAttempts ? 3 }: makeRetryWrapper {
    name = "nvcc";
    binaryPath = "${cudaPackages.cuda_nvcc}/bin/nvcc";
    inherit maxAttempts;
  };

  makeCcRetry = { maxAttempts ? 3 }: makeRetryWrapper {
    name = "cc";
    binaryPath = "${pkgs.gcc}/bin/cc";
    inherit maxAttempts;
  };

  makeCxxRetry = { maxAttempts ? 3 }: makeRetryWrapper {
    name = "c++";
    binaryPath = "${pkgs.gcc}/bin/c++";
    inherit maxAttempts;
  };

  # Create a combined package with all retry wrappers
  # These replace the original binaries when added to PATH
  makeAllRetryWrappers = cudaPackages: { maxAttempts ? 3 }:
    let
      wrappers = [
        (makeRetryWrapper {
          name = "ninja";
          binaryPath = "${pkgs.ninja}/bin/ninja";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "gcc";
          binaryPath = "${pkgs.gcc}/bin/gcc";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "g++";
          binaryPath = "${pkgs.gcc}/bin/g++";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "cc";
          binaryPath = "${pkgs.gcc}/bin/cc";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "c++";
          binaryPath = "${pkgs.gcc}/bin/c++";
          inherit maxAttempts;
        })
        (makeRetryWrapper {
          name = "nvcc";
          binaryPath = "${cudaPackages.cuda_nvcc}/bin/nvcc";
          inherit maxAttempts;
        })
      ];
    in
    pkgs.symlinkJoin {
      name = "retry-wrappers";
      paths = wrappers;
    };
}
