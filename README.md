Ignore the PASCAL in the name, I started this project when I wanted to use nixos cuda with a pascal gpu which was broken. When the pascal flag is set, this will still enable pascal support, however the automatic compatible version resolver does not support PASCAL, so you might end up with incompatibilities beyond pascal

# What is this
This repo provides a repositoy of the nix-hashes and source urls for all published verions of popular machine learning packages after 2022. They can all be build from source or allow using the available prebuild wheels. It is compatible with most versions of nixpkgs after 2022. When using prebuild wheels, it tries to resolve their dependecy graph to choose the highest version set that offers compatible wheels. This graph is build by the wheel filename, and some other known restrictions on a best effort basis. 

# Usage

Generally look at the [example folder](./examples)
```nix
{
  ...
  inputs = {
    nixpkgs.url = ...
    ...
    torch-bin.url = "github:sirati/nix-torch-bin-pascal";
    torch-bin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, torch-bin }:
    let
      system = "x86_64-linux"; # your system

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;  # required for CUDA packages
      };

      # pytorch-packages is the system-independent HLD scope.  It contains one
      # attribute per supported ML package (torch, flash-attn, causal-conv1d, …)
      # plus the concretise function.
      torchPackages = torch-bin.pytorch-packages;

      python313PackagesTorch = torchPackages.concretise {
        inherit pkgs;
    
        mlPackages = with torchPackages; [
          torch
          flash-attn
          causal-conv1d
        ];
    
        python                  = "3.13";
        cuda                    = "12.8";
        torch                   = "2.10";
        pascal                  = false;
        allowBuildingFromSource = true;
    
        extraPythonPackages = ps: with ps; [
          pandas
          numpy
        ];
      };
    in
    {
      # Enter a dev shell:   nix develop
      devShells.${system}.default = pkgs.mkShell {
        packages = [ python313PackagesTorch ];
      };
    };
}
```

you can also patch python packages derivations via the function provided to concretise's extraPythonPackages parameter, or via .extendEnv
for example this repo currently does not provide torchvision, however torchvision tries to build it own torch instead of using the given one and on top of that is incompatible with the output from torch-bin. As wandb pulls it in automatically however, we need to patch torchvision to torchvision-bin
```nix
python313PackagesTorch = torchPackages.concretise {
  ...
  extraPythonPackages = ps:
    let
      ps' = ps.overrideScope (_: prev: { torchvision = prev.torchvision-bin; });
    in with ps'; [
    wandb
  ];
};
```
