# PyTorch with CUDA 12.6 for Nix

A Nix flake providing PyTorch binary packages with CUDA 12.6 support, including special Pascal GPU compatibility variants.
Importantly because on my system python and especially torch related python packages builds fail sporadically, I am using some wrappers to just retry failed build steps 2 more times. If the build really is broken, this means it will take 3x the time to properly fail. However, for me it is most important that I do not have to win the lottery to actually get a build that succeeds.

## Features

- **CUDA 12.6 Support**: Latest CUDA toolkit with PyTorch 2.9.1 and 2.10.0
- **Pascal GPU Support**: Special builds with cuDNN 9.10.2 for NVIDIA Pascal architecture (see [PASCAL-Support.md](PASCAL-Support.md))
- **Multiple Python Versions**: Support for Python 3.11, 3.12, 3.13, and 3.14
- **Overlay Support**: Easy integration with existing Nix flakes
- 
## Quick Start

### Test PyTorch Installation

```bash
# Test with Pascal-compatible variant (Python 3.13, PyTorch 2.10.0)
nix run github:sirati/nix-torch-bin-pascal#test-torch-pascal

# Test with regular variant (Python 3.13, PyTorch 2.10.0)
nix run github:sirati/nix-torch-bin-pascal#test-torch

# Test with specific Python version
nix run github:sirati/nix-torch-bin-pascal#test-torch-pascal-py311
nix run github:sirati/nix-torch-bin-pascal#test-torch-py312

# Test with specific PyTorch version (2.9.1)
nix run github:sirati/nix-torch-bin-pascal#test-torch-pascal-v209
nix run github:sirati/nix-torch-bin-pascal#test-torch-pascal-py312-v209
```

### Use in Your Flake

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    torch-cu126.url = "github:sirati/nix-torch-bin-pascal";
  };

  outputs = { self, nixpkgs, torch-cu126 }: {
    # Your flake outputs...
  };
}
```

## Available Packages

### PyTorch Binary Packages

All packages are available for Python 3.11, 3.12, 3.13, and 3.14, with both PyTorch 2.9.1 and 2.10.0.

#### Regular CUDA 12.6 (cuDNN 9.13.0)

Default (PyTorch 2.10.0):
- `torch-bin-cu126-py311` - PyTorch 2.10.0 for Python 3.11
- `torch-bin-cu126-py312` - PyTorch 2.10.0 for Python 3.12
- `torch-bin-cu126-py313` - PyTorch 2.10.0 for Python 3.13

With version suffix:
- `torch-bin-cu126-py311-v209` - PyTorch 2.9.1 for Python 3.11
- `torch-bin-cu126-py311-v210` - PyTorch 2.10.0 for Python 3.11
- (Similar for py312, py313, py314)

#### Pascal-Compatible (cuDNN 9.10.2)

Default (PyTorch 2.10.0):
- `torch-bin-cu126-pascal-py311` - PyTorch 2.10.0 for Python 3.11
- `torch-bin-cu126-pascal-py312` - PyTorch 2.10.0 for Python 3.12
- `torch-bin-cu126-pascal-py313` - PyTorch 2.10.0 for Python 3.13

With version suffix:
- `torch-bin-cu126-pascal-py311-v209` - PyTorch 2.9.1 for Python 3.11
- `torch-bin-cu126-pascal-py311-v210` - PyTorch 2.10.0 for Python 3.11
- (Similar for py312, py313, py314)

### Python Environments

Complete Python environments with PyTorch and dependencies:

#### Regular CUDA 12.6

Default (PyTorch 2.10.0):
- `python311-torch-cu126`
- `python312-torch-cu126`
- `python313-torch-cu126` (default)
- `python314-torch-cu126`

With version suffix:
- `python311-torch-cu126-v209` - Python 3.11 with PyTorch 2.9.1
- `python313-torch-cu126-v210` - Python 3.13 with PyTorch 2.10.0
- (Similar for other combinations)

#### Pascal-Compatible

Default (PyTorch 2.10.0):
- `python311-torch-cu126-pascal`
- `python312-torch-cu126-pascal`
- `python313-torch-cu126-pascal`
- `python314-torch-cu126-pascal`

With version suffix:
- `python311-torch-cu126-pascal-v209` - Python 3.11 with PyTorch 2.9.1
- `python313-torch-cu126-pascal-v210` - Python 3.13 with PyTorch 2.10.0
- (Similar for other combinations)

### Additional Packages

- `retry-wrappers` - Build retry utilities (for development)
- `retry-wrappers-pascal` - Pascal variant retry utilities
- `cuda-toolkit-12-6` - CUDA toolkit 12.6
- `cuda-toolkit-12-6-pascal` - Pascal-compatible CUDA toolkit

## Usage Examples

### Shell Environment

```bash
# Enter a shell with PyTorch
nix shell github:sirati/nix-torch-bin-pascal#python313-torch-cu126-pascal

# Now you can use Python with PyTorch
python3 -c "import torch; print(torch.cuda.is_available())"
```

### Development Shell

Create a `flake.nix` for your project:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    torch-cu126.url = "github:sirati/nix-torch-bin-pascal";
  };

  outputs = { self, nixpkgs, torch-cu126 }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          torch-cu126.packages.${system}.python313-torch-cu126-pascal
        ];
      };
    };
}
```

### Using the Overlay

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    torch-cu126.url = "github:sirati/nix-torch-bin-pascal";
  };

  outputs = { self, nixpkgs, torch-cu126 }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ torch-cu126.overlays.default ];
      };
    in
    {
      # Now you can use torch-bin-cu126 and torch-bin-cu126-pascal
      # in your Python packages
      packages.${system}.my-ml-app = pkgs.python313.pkgs.buildPythonApplication {
        pname = "my-ml-app";
        version = "0.1.0";
        
        propagatedBuildInputs = with pkgs.python313.pkgs; [
          torch-bin-cu126-pascal
          numpy
          # ... other dependencies
        ];
        
        # ... rest of your package definition
      };
    };
}
```


## Pascal GPU Support

For GTX 10-series and other Pascal GPUs, use the `-pascal` variant packages. See [PASCAL-Support.md](PASCAL-Support.md) for technical details.

## Building Locally

```bash
# Clone the repository
git clone https://github.com/sirati/nix-torch-bin-pascal.git
cd nix-torch-bin-pascal

# Build a specific package
nix build .#torch-bin-cu126-pascal-py313

# Run tests
nix run .#test-torch-pascal
```

## Troubleshooting

### "CUDA is not available"

1. Check that your GPU is detected: `nvidia-smi`
2. Verify CUDA driver version: `nvidia-smi` (should be ≥ 525.60.13)
3. Ensure you're using the correct variant (Pascal vs regular)

### Build Failures

The flake includes retry wrappers to handle intermittent build failures. If builds still fail:

1. Try building again (network issues are common)
2. Check available disk space
3. Review build logs for specific errors

## Contributing

Contributions are welcome! Please:

1. Test your changes with both variants (regular and Pascal)
2. Verify all Python versions (3.11, 3.12, 3.13, 3.14)
3. Run `nix flake check` before submitting
4. Update documentation as needed

## License

MIT
