# Shared helper for CUDA-extension source builds.
#
# Provides buildSourcePackage, a function that encapsulates the ~80% of
# boilerplate that causal-conv1d, flash-attn, and mamba-ssm share in their
# respective override-source.nix files:
#
#   • fetchFromGitHub using rev/hash from a pre-imported srcInfo attrset
#   • build-system: setuptools + ninja + cuda_nvcc (plus optional extras)
#   • nativeBuildInputs: pkgs.which
#   • buildInputs: the five standard CUDA libs (plus optional extras)
#   • env: optional CUDA_HOME and optional FORCE_BUILD env-var (plus extras)
#   • doCheck = false
#   • meta composed from the upstream nixpkgs derivation (basePkg) +
#     "(built from source)" suffix + sourceProvenance override
#   • pythonImportsCheck derived from pname when not explicitly supplied
#
# Each override-source.nix becomes a thin wrapper that:
#   1. imports this file with `{ inherit pkgs; }`
#   2. imports its own source-hashes/v{version}.nix into srcInfo
#   3. calls buildSourcePackage with only the per-package differences
#
# --------------------------------------------------------------------------
# Argument reference
# --------------------------------------------------------------------------
#
#   pkgs                      nixpkgs package set.  pkgs.python3 is the target
#                             interpreter; pkgs.python3Packages is used for the
#                             build-system tools.
#
# The returned buildSourcePackage function accepts an attrset with:
#
#   REQUIRED
#   pname                     Package name, e.g. "causal-conv1d".
#   version                   Version string, e.g. "1.6.0".
#   srcInfo                   Attrset imported from source-hashes/v{ver}.nix.
#                             Must carry .rev and .hash.
#   srcOwner                  GitHub owner string (caller applies or-default).
#   srcRepo                   GitHub repo string (caller applies or-default).
#   torch                     Concrete torch derivation (resolvedDeps."torch").
#   cudaPackages              CUDA package set (already configured by concretise).
#
#   OPTIONAL – meta
#   basePkg                   The upstream nixpkgs derivation for this package
#                             (e.g. pkgs.python3Packages."causal-conv1d").
#                             When non-null, its .meta is used as the base;
#                             homepage, license, platforms etc. are inherited
#                             automatically and need not be repeated here.
#                             Default: null (meta built from extraMeta alone).
#   changelog                 Changelog URL string for this exact version.
#                             Merged into the final meta when non-null.
#                             Default: null.
#   extraMeta                 Attrset merged last into the final meta, allowing
#                             per-package overrides of any field.  Default: {}.
#
#   OPTIONAL – build
#   fetchSubmodules           bool; default false.  Set true for flash-attn.
#   postPatch                 Shell script string; default "".
#   preConfigure              Shell script string; default "".
#   extraBuildSystemPackages  List of extra build-system entries; default [].
#                             e.g. [ pkgs.python3Packages.psutil ] for flash-attn.
#   extraBuildInputs          List of extra buildInputs; default [].
#                             e.g. [ cudaPackages.libcurand ] for flash-attn.
#   extraDependencies         Runtime Python deps beyond torch; default [].
#   forceBuildEnvVar          String name of the FORCE_BUILD env-var, or null.
#                             When non-null, that variable is set to "TRUE" in env.
#   useCudaHome               bool; default true.  Set false for flash-attn (which
#                             sets CC/CXX/TORCH_CUDA_ARCH_LIST instead).
#   extraEnv                  Additional env entries merged last; default {}.
#
#   OPTIONAL – checks
#   pythonImportsCheck        List of Python module names to import-check.
#                             Default: null → [ (pname with "-" replaced by "_") ]
#                             e.g. "causal-conv1d" → [ "causal_conv1d" ]
#                             Override explicitly when the module name differs
#                             (e.g. pname "flash-attention" → [ "flash_attn" ]).

{ pkgs }:

let
  inherit (pkgs) lib;
in
{
  buildSourcePackage =
    { # Required
      pname
    , version
    , srcInfo
    , srcOwner
    , srcRepo
    , torch
    , cudaPackages

      # Optional – meta
    , basePkg   ? null
    , changelog ? null
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
        owner           = srcOwner;
        repo            = srcRepo;
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

      # torch is always the first runtime dependency; callers append extras.
      dependencies = [ torch ] ++ extraDependencies;

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
