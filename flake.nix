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
      # Loaded via pkgs/default.nix which auto-discovers every subdirectory
      # containing a high-level.nix and wires inter-package dependencies using a
      # fixed-point (lib.fix-style) so definition order does not matter.
      pytorchScope = import ./pkgs;


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
      pytorch-packages = pytorchScope // {
        concretise = import ./concretise;
      };

      # ── Concrete packages ────────────────────────────────────────────────────
      packages = forAllSystems ({ system, pkgs }:
        let
          # ── CUDA package sets ───────────────────────────────────────────────

          cudaPackages_12_6_pascal_base = import ./pkgs/torch/cuda-packages-pascal.nix {
            inherit pkgs;
            cudaLabel    = "cu126";
            cudaPackages = pkgs.cudaPackages_12_6;
          };
          cudaPackages_12_8_pascal_base = import ./pkgs/torch/cuda-packages-pascal.nix {
            inherit pkgs;
            cudaLabel    = "cu128";
            cudaPackages = pkgs.cudaPackages_12_8;
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
          defaultResult = (import ./concretise) {
            inherit pkgs;
            packages = [
              pytorchScope.torch
              pytorchScope."flash-attn"
              pytorchScope."causal-conv1d"
            ];
            python   = "3.13";
            cuda     = "12.6";
            pascal   = true;
          };

          # ── Test: torch-only, Python 3.13, CUDA 12.8 ───────────────────────
          testTorchCu128Result = (import ./concretise) {
            inherit pkgs;
            packages = [ pytorchScope.torch ];
            python   = "3.13";
            cuda     = "12.8";
          };

          # ── Test: torch + causal-conv1d, Python 3.13, CUDA 12.8 ────────────
          testCausalCu128Result = (import ./concretise) {
            inherit pkgs;
            packages = [
              pytorchScope.torch
              pytorchScope."causal-conv1d"
            ];
            python   = "3.13";
            cuda     = "12.8";
          };

          # ── Test: all three packages, Python 3.13, CUDA 12.8 ───────────────
          testAllCu128Result = (import ./concretise) {
            inherit pkgs;
            packages = [
              pytorchScope.torch
              pytorchScope."flash-attn"
              pytorchScope."causal-conv1d"
            ];
            python   = "3.13";
            cuda     = "12.8";
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

          # Test environments – py313 + cu128
          test-torch-py313-cu128         = testTorchCu128Result.env;
          test-causal-conv1d-py313-cu128 = testCausalCu128Result.env;
          test-all-py313-cu128           = testAllCu128Result.env;
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
            ((import ./concretise) {
              inherit pkgs;
              packages = [
                pytorchScope.torch
                pytorchScope."flash-attn"
                pytorchScope."causal-conv1d"
              ];
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
