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

      # ── Per-system outputs (packages + devShells computed together) ──────────
      # Keeping them in one block avoids duplicating the expensive let-bindings
      # (CUDA package sets, retry wrappers, concretise calls) across separate
      # genAttrs invocations.
      perSystem = forAllSystems ({ system, pkgs }:
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
          # causal-conv1d 1.6.0 has no binary wheel for torch >= 2.9, so source
          # build is required when using torch 2.10.
          defaultResult = (import ./concretise) {
            inherit pkgs;
            packages = [
              pytorchScope.torch
              pytorchScope."flash-attn"
              pytorchScope."causal-conv1d"
            ];
            python                  = "3.13";
            cuda                    = "12.6";
            torch                   = "2.10";
            pascal                  = true;
            allowBuildingFromSource = true;
          };

          # ── Test: torch-only, Python 3.13, CUDA 12.8 ───────────────────────
          testTorchCu128Result = (import ./concretise) {
            inherit pkgs;
            packages                = [ pytorchScope.torch ];
            python                  = "3.13";
            cuda                    = "12.8";
            torch                   = "2.10";
            allowBuildingFromSource = false;
          };

          # ── Test: torch + causal-conv1d binary wheel, Python 3.13, CUDA 12.8
          # Uses torch 2.8 which is the highest torch series for which a
          # causal-conv1d 1.6.0 pre-built wheel exists (maxCompat = "2.8").
          testCausalCu128Result = (import ./concretise) {
            inherit pkgs;
            packages = [
              pytorchScope.torch
              pytorchScope."causal-conv1d"
            ];
            python                  = "3.13";
            cuda                    = "12.8";
            torch                   = "2.8";
            allowBuildingFromSource = false;
          };

          # ── Test: torch + causal-conv1d from source, Python 3.13, CUDA 12.8 ─
          testCausalCu128FromSourceResult = (import ./concretise) {
            inherit pkgs;
            packages = [
              pytorchScope.torch
              pytorchScope."causal-conv1d"
            ];
            python                  = "3.13";
            cuda                    = "12.8";
            torch                   = "2.10";
            allowBuildingFromSource = true;
          };

          # ── Test: torch + flash-attn binary wheels, Python 3.13, CUDA 12.8 ─
          # flash-attn 2.8.3 has py313 wheels for torch 2.8 on cu12.
          testFlashAttnBinCu128Result = (import ./concretise) {
            inherit pkgs;
            packages = [
              pytorchScope.torch
              pytorchScope."flash-attn"
            ];
            python                  = "3.13";
            cuda                    = "12.8";
            torch                   = "2.8";
            allowBuildingFromSource = false;
          };

          # ── Test: flash-attn from source, Python 3.13, CUDA 12.8 ───────────
          # flash-attn 2.8.3 has no py313 wheel for torch >= 2.10, so a source
          # build is required.  causal-conv1d is intentionally excluded here.
          testFlashAttnSourceCu128Result = (import ./concretise) {
            inherit pkgs;
            packages = [
              pytorchScope.torch
              pytorchScope."flash-attn"
            ];
            python                  = "3.13";
            cuda                    = "12.8";
            torch                   = "2.10";
            allowBuildingFromSource = true;
          };

          # ── Test: all three packages, Python 3.13, CUDA 12.8 ───────────────
          # causal-conv1d requires a source build with torch 2.10.
          testAllCu128Result = (import ./concretise) {
            inherit pkgs;
            packages = [
              pytorchScope.torch
              pytorchScope."flash-attn"
              pytorchScope."causal-conv1d"
            ];
            python                  = "3.13";
            cuda                    = "12.8";
            torch                   = "2.10";
            allowBuildingFromSource = true;
          };

          # ── Dev shell for this project (Nix tooling) ────────────────────────
          develop = developModule { inherit pkgs; };

        in
        {
          packages = tests // {
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
            test-torch-py313-cu128                     = testTorchCu128Result.env;
            test-causal-conv1d-py313-cu128             = testCausalCu128Result.env;
            test-causal-conv1d-from-source-py313-cu128 = testCausalCu128FromSourceResult.env;
            test-flash-attn-bin-py313-cu128            = testFlashAttnBinCu128Result.env;
            test-flash-attn-source-py313-cu128         = testFlashAttnSourceCu128Result.env;
            test-all-py313-cu128                       = testAllCu128Result.env;
          };

          devShells = {
            # Dev shell for working on this Nix project (linters, LSPs, etc.)
            default = develop.makeShell {
              pascal                   = false;
              deploymentPythonPackages = _pascal: _python-pkgs: [];
              deploymentPackages       = [];
            };

            # Dev shells for the concrete test environments – these expose
            # python3 in PATH so `nix develop .#<name>` works for ad-hoc testing.
            test-torch-py313-cu128                     = testTorchCu128Result.devShell;
            test-causal-conv1d-py313-cu128             = testCausalCu128Result.devShell;
            test-causal-conv1d-from-source-py313-cu128 = testCausalCu128FromSourceResult.devShell;
            test-flash-attn-bin-py313-cu128            = testFlashAttnBinCu128Result.devShell;
            test-flash-attn-source-py313-cu128         = testFlashAttnSourceCu128Result.devShell;
            test-all-py313-cu128                       = testAllCu128Result.devShell;
          };
        }
      );

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
      packages  = nixpkgs.lib.mapAttrs (_: s: s.packages)  perSystem;

      # ── Dev shells ───────────────────────────────────────────────────────────
      devShells = nixpkgs.lib.mapAttrs (_: s: s.devShells) perSystem;

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
    };
}
