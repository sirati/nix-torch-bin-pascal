# PyTorch Binary with CUDA 12.6 Support

This directory contains files to override the default `torch-bin` package to use CUDA 12.6 instead of the default CUDA 12.8.

## Files

- **`binary-hashes.nix`**: Contains the SHA256 hashes and URLs for PyTorch 2.9.1 wheels compiled with CUDA 12.6
- **`override.nix`**: Nix expression that overrides `torch-bin` to use CUDA 12.6 packages and the custom binary hashes

## How It Works

1. The `binary-hashes.nix` file maps Python versions to their corresponding wheel URLs and hashes
   - Keys follow the format: `x86_64-linux-{python_version}-cuda12_6`
   - URLs point to PyTorch wheels from `https://download.pytorch.org/whl/cu126/`
   - Hashes are in Nix's base32 format (converted from SHA256)

2. The `override.nix` file:
   - Takes `pkgs` and `cudaPackages` (set to `cudaPackages_12_6`) as inputs
   - Overrides the default `torch-bin` package's `src` attribute to fetch CUDA 12.6 wheels
   - Updates `buildInputs` to use CUDA 12.6 packages
   - Updates `extraRunpaths` to point to CUDA 12.6 libraries

3. In `devenv.nix`, the override is applied to the Python environment:
   ```nix
   torch-bin-cu126 = import ./torch-bin-cu126/override.nix {
     inherit pkgs;
     cudaPackages = pkgs.cudaPackages_12_6;
   };
   ```

## Supported Python Versions

- Python 3.10
- Python 3.11
- Python 3.12
- Python 3.13
- Python 3.14

## PyTorch Version

Currently configured for PyTorch 2.9.1 with CUDA 12.6 support.

## Updating

To update to a new PyTorch version:

1. Find the wheel URLs at `https://download.pytorch.org/whl/cu126/torch/`
2. Download the wheels and note their SHA256 hashes (included in the URL fragment)
3. Convert SHA256 hashes to Nix base32 format using:
   ```bash
   nix-hash --type sha256 --to-base32 <sha256-hash>
   ```
4. Update `binary-hashes.nix` with the new version, URLs, and converted hashes

## Notes

- The wheel URLs include the original SHA256 hash as a URL fragment for verification
- The `hash` field uses Nix's base32 format with the `sha256-` prefix
- Only x86_64 Linux is currently supported (matching the available CUDA 12.6 wheels)