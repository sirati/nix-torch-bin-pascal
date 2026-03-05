# Shared helper for CUDA-extension source builds.
#
# Provides buildSourcePackage, a function that encapsulates the ~80% of
# boilerplate that causal-conv1d, flash-attn, and mamba-ssm share in their
# respective override-source.nix files:
#
#   • fetchFromGitHub using rev/hash from srcInfo (looked up inside helper)
#   • build-system: setuptools + ninja + cuda_nvcc (plus optional extras)
#   • nativeBuildInputs: pkgs.which
#   • buildInputs: the five standard CUDA libs (plus optional extras)
#   • env: optional CUDA_HOME and optional FORCE_BUILD env-var (plus extras)
#   • doCheck = false
#   • meta composed from the upstream nixpkgs derivation (overrideInfo.basePkg)
#     + "(built from source)" suffix + sourceProvenance override
#   • pythonImportsCheck derived from pname when not explicitly supplied
#
# Each override-source.nix becomes a minimal thin wrapper that:
#   1. imports this file directly (no { pkgs } arg needed)
#   2. calls buildSourcePackage with overrideInfo, sourceHashesDir, and only
#      the per-package differences
#
# --------------------------------------------------------------------------
# Argument reference for buildSourcePackage
# --------------------------------------------------------------------------
#
#   overrideInfo          Attrset constructed by high-level.nix and passed
#                         through the override-source.nix call site.  Fields:
#
#                           pkgs          nixpkgs package set (python3 = target)
#                           cudaPackages  CUDA package set (configured by concretise)
#                           version       version string, e.g. "1.6.0"
#                           pname         Python/PyPI package name
#                           srcOwner      GitHub owner default
#                           srcRepo       GitHub repo default
#                           basePkg       upstream nixpkgs derivation, or null
#                           changelog     changelog URL string, or null
#                           torch         concrete torch derivation, or null
#
#   sourceHashesDir       Nix path to the package's source-hashes/ directory.
#                         buildSourcePackage imports
#                         sourceHashesDir + "/v${version}.nix" automatically.
#
#   OPTIONAL – meta
#   extraMeta             Attrset merged last into the final meta, allowing
#                         per-package overrides of any field.  Default: {}.
#
#   OPTIONAL – build
#   fetchSubmodules       bool; default false.  Set true for flash-attn.
#   postPatch             Shell script string; default "".
#   preConfigure          Shell script string; default "".
#   extraBuildSystemPackages
#                         List of extra build-system entries; default [].
#                         e.g. [ pkgs.python3Packages.psutil ] for flash-attn.
#   extraBuildInputs      List of extra buildInputs; default [].
#                         e.g. [ cudaPackages.libcurand ] for flash-attn.
#   extraDependencies     Runtime Python deps beyond torch; default [].
#   forceBuildEnvVar      String name of the FORCE_BUILD env-var, or null.
#                         When non-null, that variable is set to "TRUE" in env.
#   useCudaHome           bool; default true.  Set false for flash-attn (which
#                         sets CC/CXX/TORCH_CUDA_ARCH_LIST instead).
#   extraEnv              Additional env entries merged last; default {}.
#
#   OPTIONAL – checks
#   pythonImportsCheck    List of Python module names to import-check.
#                         Default: null → [ (pname with "-" replaced by "_") ]
#                         e.g. "causal-conv1d" → [ "causal_conv1d" ]
#                         Override explicitly when the module name differs
#                         (e.g. pname "flash-attention" → [ "flash_attn" ]).

# No file-level argument: all inputs arrive via overrideInfo inside the call.
{
  buildSourcePackage =
    { # Required
      overrideInfo
    , sourceHashesDir

      # Optional – meta
    , extraMeta ? {}

      # Optional – build
    , fetchSubmodules          ? false
    , postPatch                ? ""
    , preConfigure             ? ""
    , extraBuildSystemPackages ? []
    , extraBuildInputs         ? []
    , extraDependencies        ? []
    , forceBuildEnvVar         ? null
    , useCudaHome              ? true
    , extraEnv                 ? {}

      # Optional – checks
    , pythonImportsCheck ? null
    }:

    let
      # ── Unpack overrideInfo ───────────────────────────────────────────────
      pkgs         = overrideInfo.pkgs;
      cudaPackages = overrideInfo.cudaPackages;
      version      = overrideInfo.version;
      pname        = overrideInfo.pname;
      srcOwner     = overrideInfo.srcOwner;
      srcRepo      = overrideInfo.srcRepo;
      basePkg      = overrideInfo.basePkg   or null;
      changelog    = overrideInfo.changelog or null;
      torch        = overrideInfo.torch     or null;

      inherit (pkgs) lib;

      # ── Source info ───────────────────────────────────────────────────────
      # Import the per-version hash file; allow the file to override the
      # owner/repo defaults supplied by high-level.nix.
      srcInfo          = import (sourceHashesDir + "/v${version}.nix");
      resolvedSrcOwner = srcInfo.owner or srcOwner;
      resolvedSrcRepo  = srcInfo.repo  or srcRepo;

      # ── Meta composition ──────────────────────────────────────────────────
      # Start from the upstream nixpkgs derivation's meta (if provided), then
      # overlay the source-build-specific fields, then apply caller overrides.
      baseMeta = if basePkg != null then basePkg.meta else {};

      meta =
        baseMeta
        // {
          description =
            "${baseMeta.description or pname} (built from source)";
          sourceProvenance = with lib.sourceTypes; [ fromSource ];
        }
        // lib.optionalAttrs (changelog != null) { inherit changelog; }
        // extraMeta;

      # ── pythonImportsCheck ────────────────────────────────────────────────
      # Default: replace hyphens with underscores in pname.
      # Override explicitly when the importable module name differs
      # (e.g. pname "flash-attention" must pass [ "flash_attn" ]).
      importsCheck =
        if pythonImportsCheck != null
        then pythonImportsCheck
        else [ (builtins.replaceStrings [ "-" ] [ "_" ] pname) ];

    in
    pkgs.python3Packages.buildPythonPackage {
      inherit pname version;

      # PEP 517 / pyproject-based build.
      pyproject = true;

      src = pkgs.fetchFromGitHub {
        owner           = resolvedSrcOwner;
        repo            = resolvedSrcRepo;
        inherit (srcInfo) rev hash;
        inherit fetchSubmodules;
      };

      inherit postPatch preConfigure;

      # Build-time Python/tool dependencies.
      # setuptools + ninja cover the PEP-517 backend; cuda_nvcc provides nvcc
      # and CUDA headers on PATH during compilation.
      # torch is intentionally absent from build-system (callers that need to
      # strip it from pyproject.toml do so in postPatch).
      build-system = [
        pkgs.python3Packages.setuptools
        pkgs.python3Packages.ninja
        cudaPackages.cuda_nvcc
      ] ++ extraBuildSystemPackages;

      nativeBuildInputs = [
        pkgs.which
      ];

      # Standard CUDA libraries required by every extension in this repo.
      # libcurand is package-specific (flash-attn only); callers pass it
      # via extraBuildInputs.
      buildInputs = (with cudaPackages; [
        cuda_cudart   # cuda_runtime.h, -lcudart
        cuda_cccl     # thrust / cub headers
        libcusparse   # cusparse.h
        libcusolver   # cusolverDn.h
        libcublas     # cublas_v2.h, -lcublas
      ]) ++ extraBuildInputs;

      # torch is the first runtime dependency when present; callers append extras.
      dependencies = lib.optional (torch != null) torch ++ extraDependencies;

      env =
        # CUDA_HOME: points nvcc / extension build scripts at the toolkit
        # headers.  flash-attn sets CC/CXX/TORCH_CUDA_ARCH_LIST instead and
        # does not need CUDA_HOME.
        lib.optionalAttrs useCudaHome {
          CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}";
        }
        # Per-package FORCE_BUILD variable (not used by flash-attn).
        // lib.optionalAttrs (forceBuildEnvVar != null) {
          ${forceBuildEnvVar} = "TRUE";
        }
        # Package-specific extras (e.g. CC, CXX, TORCH_CUDA_ARCH_LIST for
        # flash-attn, or nothing for causal-conv1d / mamba-ssm).
        // extraEnv;

      # No test suite that can run without a GPU.
      doCheck = false;

      pythonImportsCheck = importsCheck;

      inherit meta;
    };
}
