# Shared helpers for building Python packages from pre-built binary wheels.
#
# Every package that ships pre-built wheels (causal-conv1d, flash-attn, …)
# follows the same pattern:
#   1. Look up the right compat key in a binary-hashes/v{version}.nix file.
#   2. Select the best compat key <= resolvedTorchMajorMinor.
#   3. Fetch the wheel and build a Python package derivation from it.
#
# This file factors that logic out so each package's overlay.nix is a thin
# wrapper that only supplies the package-specific bits (extra deps, etc.).
#
# Usage (from a package's overlay.nix):
#
#   let
#     wheelHelpers = import ../../wheel-helpers.nix;
#   in
#   wheelHelpers.buildBinWheel {
#     inherit overlayInfo;
#     binaryHashesDir = ./binary-hashes;
#   };

# No file-level argument: all inputs arrive via overlayInfo inside the call.
{
  # Build a Python package from a pre-built binary wheel.
  #
  # Required arguments:
  #   overlayInfo       - Common package context attrset from high-level.nix.
  #                       Fields used:
  #                         pkgs          nixpkgs package set
  #                         pname         Python/PyPI package name
  #                         version       version string
  #                         torch         resolved torch derivation (or null)
  #                         basePkg       upstream nixpkgs derivation (or null)
  #                         changelog     changelog URL string (or null)
  #   binaryHashesDir   - Path to the package's binary-hashes/ directory.
  #                       buildBinWheel imports
  #                       binaryHashesDir + "/v${version}.nix" automatically.
  #
  # Optional arguments – meta:
  #   extraMeta          - Attrset merged last into the final meta, allowing
  #                        per-package overrides of any field.  Default: {}.
  #
  # Optional arguments – build:
  #   cudaVersion        - Top-level key in the hash file (default: "cu12")
  #   cxx11abi           - "TRUE" or "FALSE" (default: "TRUE")
  #                        Set to "FALSE" only for PyTorch built with
  #                        -D_GLIBCXX_USE_CXX11_ABI=0.
  #   extraDependencies  - Additional runtime Python dependencies beyond torch
  #                        (default: [])
  #   pythonImportsCheck - Override the list of module names to check on import.
  #                        Pass [] to skip entirely.
  #                        Default: null → [ (pname with "-" replaced by "_") ]
  buildBinWheel =
    { overlayInfo
    , binaryHashesDir
    , extraMeta          ? {}
    , cudaVersion        ? "cu12"
    , cxx11abi           ? "TRUE"
    , extraDependencies  ? []
    , pythonImportsCheck ? null   # null → [ (pname with "-" → "_") ]
    }:
    let
      # ── Unpack overlayInfo ──────────────────────────────────────────────────
      pkgs      = overlayInfo.pkgs;
      pname     = overlayInfo.pname;
      version   = overlayInfo.version;
      torch     = overlayInfo.torch     or null;
      basePkg   = overlayInfo.basePkg   or null;
      changelog = overlayInfo.changelog or null;

      lib = pkgs.lib;

      inherit (import ./generate-hashes/lib.nix { inherit pkgs; })
        pythonVersion pyVer os arch versionLE versionLT;

      _assertLinux =
        if os == "linux" then true
        else throw "${pname} pre-built wheels are only available for Linux (got: ${os})";

      # ── Binary-hashes lookup ────────────────────────────────────────────────

      binaryHashesFile = binaryHashesDir + "/v${version}.nix";
      versionData      = (import binaryHashesFile).${cudaVersion};
      availableCompat  = builtins.attrNames versionData;

      # ── Torch major.minor extraction ────────────────────────────────────────

      torchVerParts   = lib.strings.splitString "." torch.version;
      torchMajorMinor =
        "${lib.elemAt torchVerParts 0}.${lib.elemAt torchVerParts 1}";

      # ── Compat key selection ────────────────────────────────────────────────

      # True if `compat` has a usable wheel for the current platform triple
      # (and, when cxx11abi = "FALSE", a precx11abi entry).
      compatHasWheel = compat:
        builtins.hasAttr compat versionData &&
        builtins.hasAttr pyVer  versionData.${compat} &&
        builtins.hasAttr os     versionData.${compat}.${pyVer} &&
        builtins.hasAttr arch   versionData.${compat}.${pyVer}.${os} &&
        ( cxx11abi == "TRUE" ||
          builtins.hasAttr "precx11abi"
            versionData.${compat}.${pyVer}.${os}.${arch} );

      # Candidates: all compat keys numerically <= torchMajorMinor,
      # sorted descending so we try the closest match first.
      candidates =
        lib.sort (a: b: versionLT b a)
          (lib.filter (k: versionLE k torchMajorMinor) availableCompat);

      # Highest available compat key — used in the error message so the user
      # knows what the maximum supported torch series is.
      maxCompat = lib.last (lib.sort lib.versionOlder availableCompat);

      torchCompat =
        let
          findFirst = cs:
            if cs == []
            then throw (
              "${pname} ${version} (${cudaVersion}): "
              + "no compatible pre-built wheel found for torch ${torchMajorMinor}. "
              + "The highest available compat key is ${maxCompat}. "
              + "Available compat keys: ${lib.concatStringsSep ", " availableCompat}. "
              + "Platform: Python ${pythonVersion}, cxx11abi ${cxx11abi}, "
              + "${os}/${arch}."
            )
            else if compatHasWheel (lib.head cs) then lib.head cs
            else findFirst (lib.tail cs);
        in
        findFirst candidates;

      # ── Wheel fetch ─────────────────────────────────────────────────────────

      wheelLeaf = versionData.${torchCompat}.${pyVer}.${os}.${arch};

      wheelData =
        if cxx11abi == "TRUE" then
          # Strip precx11abi (if present) so fetchurl only sees name/url/hash.
          { inherit (wheelLeaf) name url hash; }
        else
          # compatHasWheel already verified precx11abi exists.
          wheelLeaf.precx11abi;

      # ── pythonImportsCheck ────────────────────────────────────────────────
      imports =
        if pythonImportsCheck != null
        then pythonImportsCheck
        else [ (builtins.replaceStrings [ "-" ] [ "_" ] pname) ];

      # ── Meta composition ──────────────────────────────────────────────────
      # Compose from the upstream nixpkgs derivation's meta (basePkg.meta),
      # overlay the pre-built-wheel-specific fields, then apply changelog and
      # any extraMeta overrides.
      baseMeta = if basePkg != null then basePkg.meta else {};
      finalMeta =
        baseMeta
        // {
          description =
            "${baseMeta.description or pname} (pre-built wheel)";
          sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
          # The upstream nixpkgs derivation may carry broken = true (e.g.
          # because its nixpkgs build requires CUDA in a way nixpkgs cannot
          # easily express).  Our pre-built wheel is a fully-functional
          # replacement, so we default to broken = false here.
          # HLDs can override this via the isBinBuildBroken field, which is
          # a function overlayInfo -> bool — allowing fine-grained per-version
          # or per-platform broken marking without disabling the whole package.
          broken = (overlayInfo.isBinBuildBroken or (_: false)) overlayInfo;
        }
        // lib.optionalAttrs (changelog != null) { inherit changelog; }
        // extraMeta;

    in
    assert _assertLinux;
    pkgs.python3Packages.buildPythonPackage {
      inherit pname version;

      format = "wheel";

      src = pkgs.fetchurl {
        inherit (wheelData) url hash;
        name = wheelData.name;
      };

      # Pre-built wheel: no compilation step.
      build-system = [];
      buildInputs  = [];

      # torch is the first runtime dependency when present; callers append extras.
      dependencies = lib.optional (torch != null) torch ++ extraDependencies;

      doCheck = false;

      pythonImportsCheck = imports;

      meta = finalMeta;
    };
}
