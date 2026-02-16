#!/usr/bin/env bash
# Example: Using retry wrappers for a Nix build

# Method 1: Enter shell with retry wrappers enabled
# nix develop .#with-retry

# Method 2: Manually add retry wrappers to PATH for a single command
nix build .#retry-wrappers
export PATH="$(pwd)/result/bin:$PATH"

# Now ninja, gcc, g++, nvcc, etc. will retry 3 times on failure
# ninja -C build
# or any build command that uses these tools
