# stdenv wrapper that injects retry wrappers into the build environment
# This ensures that compilation commands (gcc, g++, nvcc, ninja) automatically
# retry on failure during package builds.
#
# Usage:
#   let
#     retryStdenv = import ./stdenv-with-retry.nix {
#       inherit pkgs;
#       cudaPackages = pkgs.cudaPackages_12_6;
#       maxAttempts = 3;
#     };
#   in
#   yourPackage.override { stdenv = retryStdenv; }

{ pkgs
, cudaPackages
, maxAttempts ? 3
}:

let
  retryWrappers = import ./default.nix { inherit pkgs; };

  # Create the retry wrapper package for the given CUDA packages
  allRetryWrappers = retryWrappers.makeAllRetryWrappers cudaPackages {
    inherit maxAttempts;
  };

in
# Override the stdenv to prepend retry wrappers to PATH
pkgs.stdenv.override {
  # We need to override the mkDerivation function to inject our wrappers
  mkDerivation = args: pkgs.stdenv.mkDerivation (args // {
    # Prepend retry wrappers to nativeBuildInputs so they're available during build
    nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ allRetryWrappers ];

    # Ensure retry wrappers are first in PATH
    preConfigure = ''
      export PATH="${allRetryWrappers}/bin:$PATH"

      # Verify wrappers are active
      echo "=== Retry wrappers active for build ===" >&2
      echo "ninja: $(command -v ninja)" >&2
      echo "gcc: $(command -v gcc)" >&2
      echo "g++: $(command -v g++)" >&2
      echo "nvcc: $(command -v nvcc)" >&2

      ${args.preConfigure or ""}
    '';
  });
}
