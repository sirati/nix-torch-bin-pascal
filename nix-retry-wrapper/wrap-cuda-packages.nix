# Function to inject retry wrappers into CUDA packages that actually compile
#
# This wraps packages like libnvshmem, gdrcopy, etc. that build from source
# and are prone to sporadic compilation failures.
#
# Usage:
#   cudaPackagesWithRetry = wrapCudaPackagesWithRetry {
#     inherit pkgs;
#     cudaPackages = pkgs.cudaPackages_12_6;
#     retryWrappers = allRetryWrappers;
#   };

{ pkgs, cudaPackages, retryWrappers }:

cudaPackages.overrideScope (final: prev: {
  # Override libnvshmem to use retry wrappers
  # This package compiles from source and can fail sporadically
  libnvshmem = prev.libnvshmem.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ retryWrappers ];

    preConfigure = ''
      export PATH="${retryWrappers}/bin:$PATH"
      echo "=== Retry wrappers injected into libnvshmem build ===" >&2
      echo "=== PATH: $PATH ===" >&2
      type gcc >&2 || true
      type g++ >&2 || true
      type nvcc >&2 || true
      type cicc >&2 || true
      type ptxas >&2 || true
      ${old.preConfigure or ""}
    '';

    preBuild = ''
      export PATH="${retryWrappers}/bin:$PATH"
      # Override NVCC to use wrapper instead of absolute path
      export NVCC="${retryWrappers}/bin/nvcc"
      ${old.preBuild or ""}
    '';
  });

  # Override gdrcopy to use retry wrappers
  gdrcopy = prev.gdrcopy.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ retryWrappers ];

    preConfigure = ''
      export PATH="${retryWrappers}/bin:$PATH"
      echo "=== Retry wrappers injected into gdrcopy build ===" >&2
      echo "=== PATH: $PATH ===" >&2
      type gcc >&2 || true
      type nvcc >&2 || true
      ${old.preConfigure or ""}
    '';

    preBuild = ''
      export PATH="${retryWrappers}/bin:$PATH"
      # Override NVCC to use wrapper instead of absolute path
      export NVCC="${retryWrappers}/bin/nvcc"
      ${old.preBuild or ""}
    '';
  });

  # Override nccl if it compiles from source
  nccl = prev.nccl.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ retryWrappers ];

    preConfigure = ''
      export PATH="${retryWrappers}/bin:$PATH"
      echo "=== Retry wrappers injected into nccl build ===" >&2
      echo "=== PATH: $PATH ===" >&2
      echo "=== Checking which nvcc will be used ===" >&2
      type nvcc >&2 || true
      type cicc >&2 || true
      type ptxas >&2 || true
      ${old.preConfigure or ""}
    '';

    preBuild = ''
      export PATH="${retryWrappers}/bin:$PATH"
      # Override NVCC to use wrapper instead of absolute path
      export NVCC="${retryWrappers}/bin/nvcc"
      ${old.preBuild or ""}
    '';
  });

  # Override cutensor if it has any build steps
  libcutensor = prev.libcutensor.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ retryWrappers ];

    preConfigure = ''
      export PATH="${retryWrappers}/bin:$PATH"
      echo "=== Retry wrappers injected into libcutensor build ===" >&2
      echo "=== PATH: $PATH ===" >&2
      type nvcc >&2 || true
      ${old.preConfigure or ""}
    '';

    preBuild = ''
      export PATH="${retryWrappers}/bin:$PATH"
      # Override NVCC to use wrapper instead of absolute path
      export NVCC="${retryWrappers}/bin/nvcc"
      ${old.preBuild or ""}
    '';
  });
})
