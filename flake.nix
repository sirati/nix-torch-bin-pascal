{
  description = "PyTorch binary packages with CUDA 12.6 support (regular and Pascal variants)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
        inherit system;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      });

    in
    {
      packages = forAllSystems ({ system, pkgs }:
        let
          # Import retry wrapper utilities
          retryWrappers = import ./nix-retry-wrapper { inherit pkgs; };

          # Create a pkgs variant with GCC 13 for CUDA packages
          pkgsWithGcc13 = pkgs // {
            stdenv = pkgs.overrideCC pkgs.stdenv pkgs.gcc13;
          };

          # Create Pascal-specific CUDA packages (base, without wrappers yet)
          cudaPackages_12_6_pascal_base = import ./torch-bin-cu126/cuda-packages-pascal.nix {
            inherit pkgs;
          };

          # Create retry wrapper packages with GCC 13
          retryWrappersGcc13 = import ./nix-retry-wrapper {
            inherit pkgs;
            gcc = pkgs.gcc13;
          };

          allRetryWrappers = retryWrappersGcc13.makeAllRetryWrappers pkgs.cudaPackages_12_6 {
            maxAttempts = 3;
          };

          allRetryWrappersPascal = retryWrappersGcc13.makeAllRetryWrappers cudaPackages_12_6_pascal_base {
            maxAttempts = 3;
          };

          # Wrap CUDA packages to inject retry wrappers into compiling dependencies
          wrapCudaPackagesWithRetry = import ./nix-retry-wrapper/wrap-cuda-packages.nix;

          # Use GCC 13 (max supported by CUDA 12.6) for CUDA packages only
          cudaPackages_12_6_wrapped = wrapCudaPackagesWithRetry {
            pkgs = pkgsWithGcc13;
            cudaPackages = pkgs.cudaPackages_12_6;
            retryWrappers = allRetryWrappers;
          };

          cudaPackages_12_6_pascal = wrapCudaPackagesWithRetry {
            pkgs = pkgsWithGcc13;
            cudaPackages = cudaPackages_12_6_pascal_base;
            retryWrappers = allRetryWrappersPascal;
          };

          # Import test suite
          tests = import ./test-retry-wrappers.nix { inherit pkgs; };

          # Override stdenv to always use retry wrappers
          makeStdenvWithRetry = cudaPackages: wrappers:
            pkgs.stdenvAdapters.useMoldLinker (pkgs.stdenvAdapters.overrideCC pkgs.stdenv (
              pkgs.wrapCCWith {
                cc = pkgs.stdenv.cc.cc;
                extraBuildCommands = ''
                  export PATH="${wrappers}/bin:$PATH"
                '';
              }
            ));

          # Create pkgs variants with retry-enabled builds
          pkgsWithRetry = pkgs.extend (final: prev: {
            stdenv = prev.stdenv.override (old: {
              # Inject retry wrappers into the build environment
              extraNativeBuildInputs = [ allRetryWrappers ];
            });
          });

          pkgsWithRetryPascal = pkgs.extend (final: prev: {
            stdenv = prev.stdenv.override (old: {
              extraNativeBuildInputs = [ allRetryWrappersPascal ];
            });
          });

          # Generate packages for all Python versions
          pythonVersions = {
            "311" = pkgs.python311;
            "312" = pkgs.python312;
            "313" = pkgs.python313;
          };

          # Helper to build torch with retry wrappers injected into PATH
          makeTorchWithRetry = { python, cudaPackages, wrappers }:
            let
              # Create a wrapped pkgs that injects retry wrappers
              wrappedPkgs = pkgs // {
                python3 = python;
                python3Packages = python.pkgs;
              };

              # Build torch-bin with our CUDA packages
              torchBin = import ./torch-bin-cu126/override.nix {
                pkgs = wrappedPkgs;
                cudaPackages = cudaPackages;
              };

              # Wrap the torch package to ensure retry wrappers are in PATH during any builds
              wrappedTorch = torchBin.overrideAttrs (old: {
                nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ wrappers ];
                preConfigure = ''
                  export PATH="${wrappers}/bin:$PATH"
                  ${old.preConfigure or ""}
                '';
                preBuild = ''
                  export PATH="${wrappers}/bin:$PATH"
                  ${old.preBuild or ""}
                '';
              });

            in
            wrappedTorch;

          # Generate torch packages for each Python version and CUDA variant
          torchPackages = pkgs.lib.foldl' (acc: pyVer:
            let
              python = pythonVersions.${pyVer};

              # Regular CUDA 12.6 with retry wrappers
              torchCuda126 = makeTorchWithRetry {
                inherit python;
                cudaPackages = cudaPackages_12_6_wrapped;
                wrappers = allRetryWrappers;
              };

              # Pascal CUDA 12.6 with retry wrappers
              torchCuda126Pascal = makeTorchWithRetry {
                inherit python;
                cudaPackages = cudaPackages_12_6_pascal;
                wrappers = allRetryWrappersPascal;
              };

              # Python environments
              pythonEnvCuda126 = python.withPackages (ps: [ torchCuda126 ]);
              pythonEnvCuda126Pascal = python.withPackages (ps: [ torchCuda126Pascal ]);

            in
            acc // {
              "torch-bin-cu126-py${pyVer}" = torchCuda126;
              "torch-bin-cu126-pascal-py${pyVer}" = torchCuda126Pascal;
              "python${pyVer}-torch-cu126" = pythonEnvCuda126;
              "python${pyVer}-torch-cu126-pascal" = pythonEnvCuda126Pascal;
            }
          ) {} (builtins.attrNames pythonVersions);

        in
        torchPackages // tests // {
          # Default packages
          default = torchPackages."python313-torch-cu126";

          # Retry wrappers (for manual use in other projects)
          retry-wrappers = allRetryWrappers;
          retry-wrappers-pascal = allRetryWrappersPascal;

          # CUDA toolkits
          cuda-toolkit-12-6 = cudaPackages_12_6_wrapped.cudatoolkit;
          cuda-toolkit-12-6-pascal = cudaPackages_12_6_pascal.cudatoolkit;


        }
      );

      # Overlays for integration with other flakes
      overlays.default = final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions or [] ++ [
          (python-final: python-prev:
            let
              retryWrappers = import ./nix-retry-wrapper { pkgs = final; };
              wrappers = retryWrappers.makeAllRetryWrappers final.cudaPackages_12_6 { maxAttempts = 3; };
            in
            {
              torch-bin-cu126 = (import ./torch-bin-cu126/override.nix {
                pkgs = final;
                cudaPackages = final.cudaPackages_12_6;
              }).overrideAttrs (old: {
                nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ wrappers ];
                preConfigure = ''
                  export PATH="${wrappers}/bin:$PATH"
                  ${old.preConfigure or ""}
                '';
              });

              torch-bin-cu126-pascal =
                let
                  cudaPackages_12_6_pascal = import ./torch-bin-cu126/cuda-packages-pascal.nix { pkgs = final; };
                  wrappersPascal = retryWrappers.makeAllRetryWrappers cudaPackages_12_6_pascal { maxAttempts = 3; };
                in
                (import ./torch-bin-cu126/override.nix {
                  pkgs = final;
                  cudaPackages = cudaPackages_12_6_pascal;
                }).overrideAttrs (old: {
                  nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ wrappersPascal ];
                  preConfigure = ''
                    export PATH="${wrappersPascal}/bin:$PATH"
                    ${old.preConfigure or ""}
                  '';
                });
            }
          )
        ];
      };

      # Apps for running tests
      apps = forAllSystems ({ system, pkgs }:
        let
          # Test script (inline to avoid path issues)
          testScriptContent = builtins.readFile ./test-torch.py;

          # Create test app using Python environment (includes all dependencies)
          makeTestApp = pythonEnv: name: {
            type = "app";
            program = toString (pkgs.writeShellScript "test-torch-${name}" ''
              exec ${pythonEnv}/bin/python3 - <<'EOFPYTHON'
              ${testScriptContent}
              EOFPYTHON
            '');
          };

          # Generate test apps for all Python versions and variants
          makeTestApps = pyVer:
            let
              pythonEnvPascal = self.packages.${system}."python${pyVer}-torch-cu126-pascal";
              pythonEnvRegular = self.packages.${system}."python${pyVer}-torch-cu126";
            in {
              "test-torch-pascal-py${pyVer}" = makeTestApp pythonEnvPascal "pascal-py${pyVer}";
              "test-torch-py${pyVer}" = makeTestApp pythonEnvRegular "py${pyVer}";
            };

          # Combine all test apps for Python 3.11, 3.12, 3.13
          allTestApps = pkgs.lib.foldl' (acc: pyVer: acc // (makeTestApps pyVer)) {}
            [ "311" "312" "313" ];

        in
        allTestApps // {
          # Default to Pascal variant with Python 3.13
          default = makeTestApp
            self.packages.${system}.python313-torch-cu126-pascal
            "default";

          # Convenience aliases
          test-torch-pascal = makeTestApp
            self.packages.${system}.python313-torch-cu126-pascal
            "pascal";

          test-torch = makeTestApp
            self.packages.${system}.python313-torch-cu126
            "regular";
        }
      );

      # NixOS modules for system-wide integration
      nixosModules.default = { config, lib, pkgs, ... }: {
        options.programs.torch-cuda126 = {
          enable = lib.mkEnableOption "PyTorch with CUDA 12.6 support";
          usePascal = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Use Pascal-compatible CUDA packages (cuDNN 9.11.1, cuTENSOR 2.1.0)";
          };
        };

        config = lib.mkIf config.programs.torch-cuda126.enable {
          environment.systemPackages = [
            (if config.programs.torch-cuda126.usePascal
             then self.packages.${pkgs.system}.python313-torch-cu126-pascal
             else self.packages.${pkgs.system}.python313-torch-cu126)
          ];
        };
      };
    };
}
