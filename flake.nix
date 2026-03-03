{
  description = "PyTorch and related binary packages with CUDA 12.6/12.8 support (regular and Pascal variants)";

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
        # flash-attn 2.8.3 pre-built wheels exist only up to cp313; py314 is not available
        flashAttnPythonVersions = [ "311" "312" "313" ];
        # causal-conv1d 1.6.0 pre-built wheels exist for py310–py313 (cu12); py314 is not available
        causalConv1dPythonVersions = [ "311" "312" "313" ];
        causalConv1dVersion = "1.6.0";
        torchVersions = [
          { version = "2.9.1"; suffix = "v209"; }
          { version = "2.10.0"; suffix = "v210"; }
        ];
        defaultTorchVersion = "2.10.0";
        flashAttnVersion = "2.8.3";
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

          # ── CUDA 12.6 package sets ──────────────────────────────────────────

          # Pascal-specific CUDA 12.6 packages (base, without wrappers yet)
          cudaPackages_12_6_pascal_base = import ./torch-bin-cu126/cuda-packages-pascal.nix {
            inherit pkgs;
          };

          # ── CUDA 12.8 package sets ──────────────────────────────────────────

          # Pascal-specific CUDA 12.8 packages (base, without wrappers yet)
          cudaPackages_12_8_pascal_base = import ./torch-bin-cu128/cuda-packages-pascal.nix {
            inherit pkgs;
          };

          # ── Retry wrappers ──────────────────────────────────────────────────

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

          allRetryWrappersCu128 = retryWrappersGcc13.makeAllRetryWrappers pkgs.cudaPackages_12_8 {
            maxAttempts = 3;
          };

          allRetryWrappersCu128Pascal = retryWrappersGcc13.makeAllRetryWrappers cudaPackages_12_8_pascal_base {
            maxAttempts = 3;
          };

          # ── Wrapped CUDA package sets ───────────────────────────────────────

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

          cudaPackages_12_8_wrapped = wrapCudaPackagesWithRetry {
            pkgs = pkgsWithGcc13;
            cudaPackages = pkgs.cudaPackages_12_8;
            retryWrappers = allRetryWrappersCu128;
          };

          cudaPackages_12_8_pascal = wrapCudaPackagesWithRetry {
            pkgs = pkgsWithGcc13;
            cudaPackages = cudaPackages_12_8_pascal_base;
            retryWrappers = allRetryWrappersCu128Pascal;
          };

          # Import test suite
          tests = import ./test-retry-wrappers.nix { inherit pkgs; };

          # Configuration for all combinations
          pythonVersions = sharedConfig.pythonVersions;
          torchVersions = sharedConfig.torchVersions;
          defaultTorchVersion = sharedConfig.defaultTorchVersion;
          flashAttnVersion = sharedConfig.flashAttnVersion;
          causalConv1dVersion = sharedConfig.causalConv1dVersion;

          # CUDA variants: name suffix, cudaPackages, retry wrappers, cuda label
          cudaVariants = [
            { name = "cu126";        cudaPackages = cudaPackages_12_6_wrapped; wrappers = allRetryWrappers;           cudaLabel = "cu126"; }
            { name = "cu126-pascal"; cudaPackages = cudaPackages_12_6_pascal;  wrappers = allRetryWrappersPascal;    cudaLabel = "cu126"; }
            { name = "cu128";        cudaPackages = cudaPackages_12_8_wrapped; wrappers = allRetryWrappersCu128;     cudaLabel = "cu128"; }
            { name = "cu128-pascal"; cudaPackages = cudaPackages_12_8_pascal;  wrappers = allRetryWrappersCu128Pascal; cudaLabel = "cu128"; }
          ];

          pythonPackagesMap = {
            "311" = pkgs.python311;
            "312" = pkgs.python312;
            "313" = pkgs.python313;
            "314" = pkgs.python314;
          };

          # ── torch-bin builder ───────────────────────────────────────────────

          makeTorchWithRetry = { python, cudaPackages, wrappers, torchVersion, cudaLabel }:
            let
              wrappedPkgs = pkgs // {
                python3 = python;
                python3Packages = python.pkgs;
              };

              torchBin =
                if cudaLabel == "cu126" then
                  import ./torch-bin-cu126/override.nix {
                    pkgs = wrappedPkgs;
                    inherit cudaPackages torchVersion;
                  }
                else
                  import ./torch-bin-cu128/override.nix {
                    pkgs = wrappedPkgs;
                    inherit cudaPackages torchVersion;
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

          # ── flash-attn builder ──────────────────────────────────────────────

          makeFlashAttn = { python, torch }:
            let
              wrappedPkgs = pkgs // {
                python3 = python;
                python3Packages = python.pkgs;
              };
            in
            import ./flash-attn-bin/override.nix {
              pkgs = wrappedPkgs;
              inherit torch flashAttnVersion;
            };

          # ── causal-conv1d builder ───────────────────────────────────────────

          makeCausalConv1d = { python, torch }:
            let
              wrappedPkgs = pkgs // {
                python3 = python;
                python3Packages = python.pkgs;
              };
            in
            import ./causal-conv1d-bin/override.nix {
              pkgs = wrappedPkgs;
              inherit torch;
              causalConv1dVersion = sharedConfig.causalConv1dVersion;
            };

          # ── Generate all torch package combinations ─────────────────────────

          torchPackages =
            let
              pythonPackages = pkgs.lib.concatMap (pyVer:
                let
                  python = pythonPackagesMap.${pyVer};

                  variantPackages = pkgs.lib.concatMap (variant:
                    let
                      variantSuffix = "-${variant.name}";

                      # Versioned packages
                      versionedPackages = map (torchVer:
                        let
                          torch = makeTorchWithRetry {
                            inherit python;
                            cudaPackages = variant.cudaPackages;
                            wrappers = variant.wrappers;
                            torchVersion = torchVer.version;
                            cudaLabel = variant.cudaLabel;
                          };
                          pythonEnv = python.withPackages (ps: [ torch ]);
                        in
                        {
                          "torch-bin${variantSuffix}-py${pyVer}-${torchVer.suffix}" = torch;
                          "python${pyVer}-torch${variantSuffix}-${torchVer.suffix}" = pythonEnv;
                        }
                      ) torchVersions;

                      # Default packages (latest torch version)
                      defaultTorch = makeTorchWithRetry {
                        inherit python;
                        cudaPackages = variant.cudaPackages;
                        wrappers = variant.wrappers;
                        torchVersion = defaultTorchVersion;
                        cudaLabel = variant.cudaLabel;
                      };
                      defaultPythonEnv = python.withPackages (ps: [ defaultTorch ]);
                      defaultPackages = {
                        "torch-bin${variantSuffix}-py${pyVer}" = defaultTorch;
                        "python${pyVer}-torch${variantSuffix}" = defaultPythonEnv;
                      };
                    in
                    versionedPackages ++ [ defaultPackages ]
                  ) cudaVariants;
                in
                variantPackages
              ) pythonVersions;
            in
            pkgs.lib.foldl' (acc: pkg: acc // pkg) {} pythonPackages;

          # ── Generate flash-attn packages for each torch variant ─────────────
          # flash-attn wheels use generic cu12 (not cu126/cu128-specific),
          # so one derivation per (python, torch) pair suffices.

          flashAttnPackages =
            let
              # Only generate packages for Python versions that have pre-built wheels.
              # flash-attn 2.8.3 does not provide py314 wheels.
              flashAttnPythonVersions = sharedConfig.flashAttnPythonVersions;

              pythonPackages = pkgs.lib.concatMap (pyVer:
                let
                  python = pythonPackagesMap.${pyVer};

                  variantPackages = pkgs.lib.concatMap (variant:
                    let
                      variantSuffix = "-${variant.name}";

                      versionedPackages = map (torchVer:
                        let
                          torch = makeTorchWithRetry {
                            inherit python;
                            cudaPackages = variant.cudaPackages;
                            wrappers = variant.wrappers;
                            torchVersion = torchVer.version;
                            cudaLabel = variant.cudaLabel;
                          };
                          flashAttn = makeFlashAttn { inherit python torch; };
                        in
                        {
                          "flash-attn-bin${variantSuffix}-py${pyVer}-${torchVer.suffix}" = flashAttn;
                        }
                      ) torchVersions;

                      defaultTorch = makeTorchWithRetry {
                        inherit python;
                        cudaPackages = variant.cudaPackages;
                        wrappers = variant.wrappers;
                        torchVersion = defaultTorchVersion;
                        cudaLabel = variant.cudaLabel;
                      };
                      defaultFlashAttn = makeFlashAttn { inherit python; torch = defaultTorch; };
                      defaultPackages = {
                        "flash-attn-bin${variantSuffix}-py${pyVer}" = defaultFlashAttn;
                      };
                    in
                    versionedPackages ++ [ defaultPackages ]
                  ) cudaVariants;
                in
                variantPackages
              ) flashAttnPythonVersions;
            in
            pkgs.lib.foldl' (acc: pkg: acc // pkg) {} pythonPackages;

          # ── Generate causal-conv1d packages for each torch variant ──────────
          # causal-conv1d wheels use generic cu12 (not cu126/cu128-specific),
          # so one derivation per (python, torch) pair suffices.

          causalConv1dPackages =
            let
              causalConv1dPythonVersions = sharedConfig.causalConv1dPythonVersions;

              pythonPackages = pkgs.lib.concatMap (pyVer:
                let
                  python = pythonPackagesMap.${pyVer};

                  variantPackages = pkgs.lib.concatMap (variant:
                    let
                      variantSuffix = "-${variant.name}";

                      versionedPackages = map (torchVer:
                        let
                          torch = makeTorchWithRetry {
                            inherit python;
                            cudaPackages = variant.cudaPackages;
                            wrappers = variant.wrappers;
                            torchVersion = torchVer.version;
                            cudaLabel = variant.cudaLabel;
                          };
                          causalConv1d = makeCausalConv1d { inherit python torch; };
                        in
                        {
                          "causal-conv1d-bin${variantSuffix}-py${pyVer}-${torchVer.suffix}" = causalConv1d;
                        }
                      ) torchVersions;

                      defaultTorch = makeTorchWithRetry {
                        inherit python;
                        cudaPackages = variant.cudaPackages;
                        wrappers = variant.wrappers;
                        torchVersion = defaultTorchVersion;
                        cudaLabel = variant.cudaLabel;
                      };
                      defaultCausalConv1d = makeCausalConv1d { inherit python; torch = defaultTorch; };
                      defaultPackages = {
                        "causal-conv1d-bin${variantSuffix}-py${pyVer}" = defaultCausalConv1d;
                      };
                    in
                    versionedPackages ++ [ defaultPackages ]
                  ) cudaVariants;
                in
                variantPackages
              ) causalConv1dPythonVersions;
            in
            pkgs.lib.foldl' (acc: pkg: acc // pkg) {} pythonPackages;

        in
        torchPackages // flashAttnPackages // causalConv1dPackages // tests // {
          # Default packages (cu126 pascal for backward compatibility)
          default = torchPackages."python313-torch-cu126-pascal";

          # Retry wrappers (for manual use in other projects)
          retry-wrappers            = allRetryWrappers;
          retry-wrappers-pascal     = allRetryWrappersPascal;
          retry-wrappers-cu128      = allRetryWrappersCu128;
          retry-wrappers-cu128-pascal = allRetryWrappersCu128Pascal;

          # CUDA toolkits
          cuda-toolkit-12-6        = cudaPackages_12_6_wrapped.cudatoolkit;
          cuda-toolkit-12-6-pascal = cudaPackages_12_6_pascal.cudatoolkit;
          cuda-toolkit-12-8        = cudaPackages_12_8_wrapped.cudatoolkit;
          cuda-toolkit-12-8-pascal = cudaPackages_12_8_pascal.cudatoolkit;
        }
      );

      # Overlays for integration with other flakes
      overlays.default = final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions or [] ++ [
          (python-final: python-prev:
          let
            retryWrappers = import ./nix-retry-wrapper { pkgs = final; };

            # cu126
            wrappers126        = retryWrappers.makeAllRetryWrappers final.cudaPackages_12_6 { maxAttempts = 3; };
            cudaPascal126      = import ./torch-bin-cu126/cuda-packages-pascal.nix { pkgs = final; };
            wrappers126Pascal  = retryWrappers.makeAllRetryWrappers cudaPascal126 { maxAttempts = 3; };

            # cu128
            wrappers128        = retryWrappers.makeAllRetryWrappers final.cudaPackages_12_8 { maxAttempts = 3; };
            cudaPascal128      = import ./torch-bin-cu128/cuda-packages-pascal.nix { pkgs = final; };
            wrappers128Pascal  = retryWrappers.makeAllRetryWrappers cudaPascal128 { maxAttempts = 3; };

            torchVersions        = sharedConfig.torchVersions;
            defaultTorchVersion  = sharedConfig.defaultTorchVersion;
            flashAttnVersion     = sharedConfig.flashAttnVersion;
            causalConv1dVersion  = sharedConfig.causalConv1dVersion;

            makeTorchOverlay = { cudaPackages, wrappers, torchVersion, cudaLabel }:
              let
                torchBin =
                  if cudaLabel == "cu126" then
                    import ./torch-bin-cu126/override.nix {
                      pkgs = final;
                      inherit cudaPackages torchVersion;
                    }
                  else
                    import ./torch-bin-cu128/override.nix {
                      pkgs = final;
                      inherit cudaPackages torchVersion;
                    };
              in
              torchBin.overrideAttrs (old: {
                nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ wrappers ];
                preConfigure = ''
                  export PATH="${wrappers}/bin:$PATH"
                  ${old.preConfigure or ""}
                '';
              });

            makeFlashAttnOverlay = { torch }:
              import ./flash-attn-bin/override.nix {
                pkgs = final;
                inherit torch flashAttnVersion;
              };

            makeCausalConv1dOverlay = { torch }:
              import ./causal-conv1d-bin/override.nix {
                pkgs = final;
                inherit torch;
                inherit causalConv1dVersion;
              };

            # Generate overlay packages for a given CUDA variant
            makeVariantPackages = { name, cudaPackages, wrappers, cudaLabel }:
              let
                variantSuffix = "-${name}";

                versionedTorch = map (tv: {
                  "torch-bin${variantSuffix}-${tv.suffix}" = makeTorchOverlay {
                    inherit cudaPackages wrappers cudaLabel;
                    torchVersion = tv.version;
                  };
                }) torchVersions;

                defaultTorch = makeTorchOverlay {
                  inherit cudaPackages wrappers cudaLabel;
                  torchVersion = defaultTorchVersion;
                };

                versionedFlash = map (tv: {
                  "flash-attn-bin${variantSuffix}-${tv.suffix}" = makeFlashAttnOverlay {
                    torch = makeTorchOverlay {
                      inherit cudaPackages wrappers cudaLabel;
                      torchVersion = tv.version;
                    };
                  };
                }) torchVersions;

                defaultFlash = makeFlashAttnOverlay { torch = defaultTorch; };

                versionedCausalConv1d = map (tv: {
                  "causal-conv1d-bin${variantSuffix}-${tv.suffix}" = makeCausalConv1dOverlay {
                    torch = makeTorchOverlay {
                      inherit cudaPackages wrappers cudaLabel;
                      torchVersion = tv.version;
                    };
                  };
                }) torchVersions;

                defaultCausalConv1d = makeCausalConv1dOverlay { torch = defaultTorch; };
              in
              final.lib.foldl' (acc: x: acc // x) {
                "torch-bin${variantSuffix}"           = defaultTorch;
                "flash-attn-bin${variantSuffix}"      = defaultFlash;
                "causal-conv1d-bin${variantSuffix}"   = defaultCausalConv1d;
              } (versionedTorch ++ versionedFlash ++ versionedCausalConv1d);

            overlayPackages =
              final.lib.foldl' (acc: variant: acc // makeVariantPackages variant) {}
              [
                { name = "cu126";        cudaPackages = final.cudaPackages_12_6; wrappers = wrappers126;       cudaLabel = "cu126"; }
                { name = "cu126-pascal"; cudaPackages = cudaPascal126;           wrappers = wrappers126Pascal; cudaLabel = "cu126"; }
                { name = "cu128";        cudaPackages = final.cudaPackages_12_8; wrappers = wrappers128;       cudaLabel = "cu128"; }
                { name = "cu128-pascal"; cudaPackages = cudaPascal128;           wrappers = wrappers128Pascal; cudaLabel = "cu128"; }
              ];
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

          # Generate test apps for all combinations
          allTestApps =
            let
              pythonTestApps = pkgs.lib.concatMap (pyVer:
                let
                  # Default version tests for each CUDA variant
                  defaultTests = pkgs.lib.concatMap (variant:
                    let variantSuffix = "-${variant.name}"; in
                    [{
                      "test-torch${variantSuffix}-py${pyVer}" = makeTestApp
                        self.packages.${system}."python${pyVer}-torch${variantSuffix}"
                        "${variant.name}-py${pyVer}";
                    }]
                  ) [
                    { name = "cu126"; } { name = "cu126-pascal"; }
                    { name = "cu128"; } { name = "cu128-pascal"; }
                  ];

                  # Versioned tests
                  versionedTests = pkgs.lib.concatMap (tv:
                    pkgs.lib.concatMap (variant:
                      let variantSuffix = "-${variant.name}"; in
                      [{
                        "test-torch${variantSuffix}-py${pyVer}-${tv.suffix}" = makeTestApp
                          self.packages.${system}."python${pyVer}-torch${variantSuffix}-${tv.suffix}"
                          "${variant.name}-py${pyVer}-${tv.suffix}";
                      }]
                    ) [
                      { name = "cu126"; } { name = "cu126-pascal"; }
                      { name = "cu128"; } { name = "cu128-pascal"; }
                    ]
                  ) torchVersions;
                in
                defaultTests ++ versionedTests
              ) pythonVersions;
            in
            pkgs.lib.foldl' (acc: apps: acc // apps) {} pythonTestApps;

          # Convenience aliases (backward-compatible names)
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
        options.programs.torch-cuda = {
          enable = lib.mkEnableOption "PyTorch with CUDA support";
          cudaVersion = lib.mkOption {
            type = lib.types.enum [ "12.6" "12.8" ];
            default = "12.6";
            description = "CUDA version to use (12.6 or 12.8)";
          };
          usePascal = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Use Pascal-compatible CUDA packages (cuDNN 9.10.2, cuTENSOR 2.1.0)";
          };
        };

        config = lib.mkIf config.programs.torch-cuda.enable {
          environment.systemPackages =
            let
              cudaSuffix = if config.programs.torch-cuda.cudaVersion == "12.8" then "cu128" else "cu126";
              pascalSuffix = if config.programs.torch-cuda.usePascal then "-pascal" else "";
            in
            [ self.packages.${pkgs.system}."python313-torch-${cudaSuffix}${pascalSuffix}" ];
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
