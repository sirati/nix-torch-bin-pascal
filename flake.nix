{
  description = "PyTorch and related binary packages with CUDA 12.6/12.8 support (regular and Pascal variants)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];

      developModule = import ./develop.nix;

      # ── High-level derivations (system-independent pure values) ─────────────
      # These describe packages without committing to a concrete build.
      # Pass them to concretise.nix to obtain actual derivations.
      torchHLD        = import ./torch/high-level.nix { };
      flashAttnHLD    = import ./flash-attn/high-level.nix    { torch = torchHLD; };
      causalConv1dHLD = import ./causal-conv1d/high-level.nix { torch = torchHLD; };

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
        inherit system;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      });

    in
    {
      # ── High-level derivations + concretise function ─────────────────────────
      #
      # System-independent output.  Consumers import these into their own flakes:
      #
      #   inputs.torch-flake.url = "github:…/nix-torch-bin-pascal";
      #
      #   result = torch-flake.pytorch-packages.concretise {
      #     inherit pkgs;
      #     packages      = with torch-flake.pytorch-packages; [ torch flash-attn ];
      #     cudaVersion   = "cu126";
      #     isPascal      = true;
      #     pythonVersion = "313";
      #   };
      #
      pytorch-packages = {
        torch           = torchHLD;
        "flash-attn"    = flashAttnHLD;
        "causal-conv1d" = causalConv1dHLD;
        concretise      = import ./concretise.nix;
      };

      # ── Concrete packages ────────────────────────────────────────────────────
      packages = forAllSystems ({ system, pkgs }:
        let
          # ── CUDA package sets ───────────────────────────────────────────────

          cudaPackages_12_6_pascal_base = import ./torch-cu126/cuda-packages-pascal.nix {
            inherit pkgs;
          };
          cudaPackages_12_8_pascal_base = import ./torch-cu128/cuda-packages-pascal.nix {
            inherit pkgs;
          };

          # ── Retry wrappers ──────────────────────────────────────────────────

          retryWrappersGcc13 = import ./nix-retry-wrapper {
            inherit pkgs;
            gcc = pkgs.gcc13;
          };

          allRetryWrappers = retryWrappersGcc13.makeAllRetryWrappers
            pkgs.cudaPackages_12_6 { maxAttempts = 3; };

          allRetryWrappersPascal = retryWrappersGcc13.makeAllRetryWrappers
            cudaPackages_12_6_pascal_base { maxAttempts = 3; };

          allRetryWrappersCu128 = retryWrappersGcc13.makeAllRetryWrappers
            pkgs.cudaPackages_12_8 { maxAttempts = 3; };

          allRetryWrappersCu128Pascal = retryWrappersGcc13.makeAllRetryWrappers
            cudaPackages_12_8_pascal_base { maxAttempts = 3; };

          # ── Wrapped CUDA package sets (for toolkit exports) ─────────────────

          pkgsWithGcc13 = pkgs // {
            stdenv = pkgs.overrideCC pkgs.stdenv pkgs.gcc13;
          };

          wrapCudaPackagesWithRetry = import ./nix-retry-wrapper/wrap-cuda-packages.nix;

          cudaPackages_12_6_wrapped = wrapCudaPackagesWithRetry {
            pkgs         = pkgsWithGcc13;
            cudaPackages = pkgs.cudaPackages_12_6;
            retryWrappers = allRetryWrappers;
          };
          cudaPackages_12_6_pascal = wrapCudaPackagesWithRetry {
            pkgs         = pkgsWithGcc13;
            cudaPackages = cudaPackages_12_6_pascal_base;
            retryWrappers = allRetryWrappersPascal;
          };
          cudaPackages_12_8_wrapped = wrapCudaPackagesWithRetry {
            pkgs         = pkgsWithGcc13;
            cudaPackages = pkgs.cudaPackages_12_8;
            retryWrappers = allRetryWrappersCu128;
          };
          cudaPackages_12_8_pascal = wrapCudaPackagesWithRetry {
            pkgs         = pkgsWithGcc13;
            cudaPackages = cudaPackages_12_8_pascal_base;
            retryWrappers = allRetryWrappersCu128Pascal;
          };

          # ── Tests ───────────────────────────────────────────────────────────
          tests = import ./test-retry-wrappers.nix { inherit pkgs; };

          # ── Default concrete environment ────────────────────────────────────
          # cu126-pascal, Python 3.13, all three packages.
          defaultResult = (import ./concretise.nix) {
            inherit pkgs;
            packages = [ torchHLD flashAttnHLD causalConv1dHLD ];
            python   = "3.13";
            cuda     = "12.6";
            pascal   = true;
          };

        in
        tests // {
          default = defaultResult.env;

          # Retry wrappers – exported for use in other projects
          retry-wrappers              = allRetryWrappers;
          retry-wrappers-pascal       = allRetryWrappersPascal;
          retry-wrappers-cu128        = allRetryWrappersCu128;
          retry-wrappers-cu128-pascal = allRetryWrappersCu128Pascal;

          # CUDA toolkits – exported for use in other projects
          cuda-toolkit-12-6         = cudaPackages_12_6_wrapped.cudatoolkit;
          cuda-toolkit-12-6-pascal  = cudaPackages_12_6_pascal.cudatoolkit;
          cuda-toolkit-12-8         = cudaPackages_12_8_wrapped.cudatoolkit;
          cuda-toolkit-12-8-pascal  = cudaPackages_12_8_pascal.cudatoolkit;
        }
      );

      # ── Test apps ────────────────────────────────────────────────────────────
      apps = forAllSystems ({ system, pkgs }:
        let
          testScriptContent = builtins.readFile ./test-torch.py;

          makeTestApp = pythonEnv: name: {
            type    = "app";
            program = toString (pkgs.writeShellScript "test-torch-${name}" ''
              exec ${pythonEnv}/bin/python3 - <<'EOFPYTHON'
              ${testScriptContent}
              EOFPYTHON
            '');
          };
        in
        {
          default = makeTestApp self.packages.${system}.default "default";
        }
      );

      # ── NixOS module ─────────────────────────────────────────────────────────
      nixosModules.default = { config, lib, pkgs, ... }: {
        options.programs.torch-cuda = {
          enable = lib.mkEnableOption "PyTorch with CUDA support";

          cuda = lib.mkOption {
            type        = lib.types.enum [ "12.6" "12.8" ];
            default     = "12.6";
            description = "CUDA toolkit version to use.";
          };

          pascal = lib.mkOption {
            type        = lib.types.bool;
            default     = false;
            description = "Use Pascal-compatible CUDA packages (cuDNN 9.10.2, cuTENSOR 2.1.0).";
          };

          python = lib.mkOption {
            type        = lib.types.enum [ "3.11" "3.12" "3.13" "3.14" ];
            default     = "3.13";
            description = "Python version to use.";
          };
        };

        config = lib.mkIf config.programs.torch-cuda.enable {
          environment.systemPackages = [
            ((import ./concretise.nix) {
              inherit pkgs;
              packages = [ torchHLD flashAttnHLD causalConv1dHLD ];
              cuda     = config.programs.torch-cuda.cuda;
              pascal   = config.programs.torch-cuda.pascal;
              python   = config.programs.torch-cuda.python;
            }).env
          ];
        };
      };

      # ── Dev shells ───────────────────────────────────────────────────────────
      devShells = nixpkgs.lib.genAttrs systems (system:
        let
          pkgs    = import nixpkgs { inherit system; };
          develop = developModule { inherit pkgs; };
        in
        {
          default = develop.makeShell {
            pascal                    = false;
            deploymentPythonPackages  = _pascal: _python-pkgs: [];
            deploymentPackages        = [];
          };
        }
      );
    };
}
