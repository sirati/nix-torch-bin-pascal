{
  description = "PyTorch binary packages with CUDA 12.6 support (regular and Pascal variants)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];

      # Import develop.nix
      developModule = import ./develop.nix;

      # Shared configuration for all package generations
      sharedConfig = {
        pythonVersions = [ "311" "312" "313" "314" ];
        torchVersions = [
          { version = "2.9.1"; suffix = "v209"; }
          { version = "2.10.0"; suffix = "v210"; }
        ];
        defaultTorchVersion = "2.10.0";
      };

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

          # Configuration for all combinations
          pythonVersions = sharedConfig.pythonVersions;
          torchVersions = sharedConfig.torchVersions;
          defaultTorchVersion = sharedConfig.defaultTorchVersion;

          cudaVariants = [
            { name = ""; cudaPackages = cudaPackages_12_6_wrapped; wrappers = allRetryWrappers; }
            { name = "pascal"; cudaPackages = cudaPackages_12_6_pascal; wrappers = allRetryWrappersPascal; }
          ];

          pythonPackagesMap = {
            "311" = pkgs.python311;
            "312" = pkgs.python312;
            "313" = pkgs.python313;
            "314" = pkgs.python314;
          };

          # Helper to build torch with retry wrappers injected into PATH
          makeTorchWithRetry = { python, cudaPackages, wrappers, torchVersion }:
            let
              wrappedPkgs = pkgs // {
                python3 = python;
                python3Packages = python.pkgs;
              };

              torchBin = import ./torch-bin-cu126/override.nix {
                pkgs = wrappedPkgs;
                cudaPackages = cudaPackages;
                inherit torchVersion;
              };

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

          # Generate all package combinations
          torchPackages =
            let
              # For each Python version
              pythonPackages = pkgs.lib.concatMap (pyVer:
                let
                  python = pythonPackagesMap.${pyVer};

                  # For each CUDA variant (regular and Pascal)
                  variantPackages = pkgs.lib.concatMap (variant:
                    let
                      variantSuffix = if variant.name == "" then "" else "-${variant.name}";

                      # For each torch version
                      versionedPackages = map (torchVer:
                        let
                          torch = makeTorchWithRetry {
                            inherit python;
                            cudaPackages = variant.cudaPackages;
                            wrappers = variant.wrappers;
                            torchVersion = torchVer.version;
                          };
                          pythonEnv = python.withPackages (ps: [ torch ]);
                        in
                        {
                          "torch-bin-cu126${variantSuffix}-py${pyVer}-${torchVer.suffix}" = torch;
                          "python${pyVer}-torch-cu126${variantSuffix}-${torchVer.suffix}" = pythonEnv;
                        }
                      ) torchVersions;

                      # Default packages (latest torch version)
                      defaultTorch = makeTorchWithRetry {
                        inherit python;
                        cudaPackages = variant.cudaPackages;
                        wrappers = variant.wrappers;
                        torchVersion = defaultTorchVersion;
                      };
                      defaultPythonEnv = python.withPackages (ps: [ defaultTorch ]);
                      defaultPackages = {
                        "torch-bin-cu126${variantSuffix}-py${pyVer}" = defaultTorch;
                        "python${pyVer}-torch-cu126${variantSuffix}" = defaultPythonEnv;
                      };
                    in
                    versionedPackages ++ [ defaultPackages ]
                  ) cudaVariants;
                in
                variantPackages
              ) pythonVersions;
            in
            pkgs.lib.foldl' (acc: pkg: acc // pkg) {} pythonPackages;

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
            cudaPackages_12_6_pascal = import ./torch-bin-cu126/cuda-packages-pascal.nix { pkgs = final; };
            wrappersPascal = retryWrappers.makeAllRetryWrappers cudaPackages_12_6_pascal { maxAttempts = 3; };

            makeTorchOverlay = { cudaPackages, wrappers, torchVersion }:
              (import ./torch-bin-cu126/override.nix {
                pkgs = final;
                inherit cudaPackages torchVersion;
              }).overrideAttrs (old: {
                nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ wrappers ];
                preConfigure = ''
                  export PATH="${wrappers}/bin:$PATH"
                  ${old.preConfigure or ""}
                '';
              });

            torchVersions = sharedConfig.torchVersions;
            defaultTorchVersion = sharedConfig.defaultTorchVersion;

            # Generate all overlay packages
            overlayPackages =
              let
                # Regular variant packages
                regularPackages = map (tv: {
                  "torch-bin-cu126-${tv.suffix}" = makeTorchOverlay {
                    cudaPackages = final.cudaPackages_12_6;
                    inherit wrappers;
                    torchVersion = tv.version;
                  };
                }) torchVersions;

                # Pascal variant packages
                pascalPackages = map (tv: {
                  "torch-bin-cu126-pascal-${tv.suffix}" = makeTorchOverlay {
                    cudaPackages = cudaPackages_12_6_pascal;
                    wrappers = wrappersPascal;
                    torchVersion = tv.version;
                  };
                }) torchVersions;

                # Default packages (latest torch version)
                defaultPackages = {
                  torch-bin-cu126 = makeTorchOverlay {
                    cudaPackages = final.cudaPackages_12_6;
                    inherit wrappers;
                    torchVersion = defaultTorchVersion;
                  };

                  torch-bin-cu126-pascal = makeTorchOverlay {
                    cudaPackages = cudaPackages_12_6_pascal;
                    wrappers = wrappersPascal;
                    torchVersion = defaultTorchVersion;
                  };
                };
              in
              final.lib.foldl' (acc: pkg: acc // pkg) defaultPackages (regularPackages ++ pascalPackages);
          in
          overlayPackages
          )
        ];
      };

      # Apps for running tests
      apps = forAllSystems ({ system, pkgs }:
        let
          testScriptContent = builtins.readFile ./test-torch.py;

          makeTestApp = pythonEnv: name: {
            type = "app";
            program = toString (pkgs.writeShellScript "test-torch-${name}" ''
              exec ${pythonEnv}/bin/python3 - <<'EOFPYTHON'
              ${testScriptContent}
              EOFPYTHON
            '');
          };

          pythonVersions = sharedConfig.pythonVersions;
          torchVersions = sharedConfig.torchVersions;

          # Generate all test app combinations
          allTestApps =
            let
              # For each Python version
              pythonTestApps = pkgs.lib.concatMap (pyVer:
                let
                  # Default version tests
                  defaultTests = [
                    {
                      "test-torch-pascal-py${pyVer}" = makeTestApp
                        self.packages.${system}."python${pyVer}-torch-cu126-pascal"
                        "pascal-py${pyVer}";
                      "test-torch-py${pyVer}" = makeTestApp
                        self.packages.${system}."python${pyVer}-torch-cu126"
                        "py${pyVer}";
                    }
                  ];

                  # Versioned tests
                  versionedTests = map (tv: {
                    "test-torch-pascal-py${pyVer}-${tv.suffix}" = makeTestApp
                      self.packages.${system}."python${pyVer}-torch-cu126-pascal-${tv.suffix}"
                      "pascal-py${pyVer}-${tv.suffix}";
                    "test-torch-py${pyVer}-${tv.suffix}" = makeTestApp
                      self.packages.${system}."python${pyVer}-torch-cu126-${tv.suffix}"
                      "py${pyVer}-${tv.suffix}";
                  }) torchVersions;
                in
                defaultTests ++ versionedTests
              ) pythonVersions;
            in
            pkgs.lib.foldl' (acc: apps: acc // apps) {} pythonTestApps;

          # Convenience aliases
          convenientAliases = {
            default = makeTestApp
              self.packages.${system}.python313-torch-cu126-pascal
              "default";

            test-torch-pascal = makeTestApp
              self.packages.${system}.python313-torch-cu126-pascal
              "pascal";

            test-torch = makeTestApp
              self.packages.${system}.python313-torch-cu126
              "regular";

            test-torch-pascal-v209 = makeTestApp
              self.packages.${system}.python313-torch-cu126-pascal-v209
              "pascal-v209";

            test-torch-v209 = makeTestApp
              self.packages.${system}.python313-torch-cu126-v209
              "v209";
          };
        in
        allTestApps // convenientAliases
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

      # Development shells
      devShells = nixpkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          develop = developModule { inherit pkgs; };
        in
        {
          default = develop.makeShell {
            pascal = false;
            deploymentPythonPackages = _pascal: _python-pkgs: [];
            deploymentPackages = [];
          };
        }
      );
    };
}
