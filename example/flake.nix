# example/flake.nix – Downstream flake template for projects that consume
# nix-torch-bin-pascal.
#
# This is a self-contained, copy-paste starting point.  To use it:
#   1. Copy this directory into your own project.
#   2. Replace the torch-bin URL with the real GitHub path (or a local path).
#   3. Adjust mlPackages, python, cuda, torch, and the extra packages to suit.
#
# The actual environment definition lives in ./default.nix so it can be
# imported directly by the test suite without going through the flake layer.
{
  description = "Example project using nix-torch-bin-pascal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    
    torch-bin.url = "github:sirati/nix-torch-bin-pascal";
    # Keep both flakes on the same nixpkgs revision to avoid duplicate
    # dependencies in the closure.
    torch-bin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, torch-bin }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;  # required for CUDA packages
      };

      # pytorch-packages is the system-independent HLD scope.  It contains one
      # attribute per supported ML package (torch, flash-attn, causal-conv1d, …)
      # plus the concretise function.
      torchPackages = torch-bin.pytorch-packages;

      example = import ./default.nix { inherit pkgs torchPackages; };
    in
    {
      # Build the environment:   nix build
      packages.${system}.default = example.env;

      # Enter a dev shell:   nix develop
      devShells.${system}.default = example.devShell;
    };
}
