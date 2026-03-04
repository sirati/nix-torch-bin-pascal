# Shared helpers for building Python packages from pre-built binary wheels.
#
# Every package that ships pre-built wheels (causal-conv1d, flash-attn, …)
# follows the same pattern:
#   1. Look up the right compat key in a binary-hashes/v{version}.nix file.
#   2. Select the best compat key <= resolvedTorchMajorMinor.
#   3. Fetch the wheel and build a Python package derivation from it.
#
# This file factors that logic out so each package's override.nix is a thin
# wrapper that only supplies the package-specific bits (pname, meta, extra deps).
#
# Usage (from a package's override.nix):
#
#   let
#     wheelHelpers = import ../../wheel-helpers.nix { inherit pkgs; };
#   in
#   wheelHelpers.buildBinWheel {
#     pname            = "causal-conv1d";
#     version          = causalConv1dVersion;
#     binaryHashesFile = ./binary-hashes + "/v${causalConv1dVersion}.nix";
#     inherit torch cudaVersion cxx11abi;
#     meta = { … };
#   };

{ pkgs }:

let
  lib = pkgs.lib;

  inherit (import ./generate-hashes/lib.nix { inherit pkgs; })
    pythonVersion pyVer os arch versionLE versionLT;

in
{
  # Build a Python package from a pre-built binary wheel.
  #
  # Required arguments:
  #   pname             - Python package name (e.g. "causal-conv1d")
  #   version           - Package version string (e.g. "1.6.0")
  #   binaryHashesFile  - Path to the v{version}.nix binary-hashes file
  #                       (e.g. ./binary-hashes + "/v${version}.nix")
  #   torch             - Resolved torch derivation (must have .version attribute)
  #   meta              - Nix meta attrset (description, homepage, license, …)
  #
  # Optional arguments:
  #   cudaVersion        - Top-level key in the hash file (default: "cu12")
  #   cxx11abi           - "TRUE" or "FALSE" (default: "TRUE")
  #                        Set to "FALSE" only for PyTorch built with
  #                        -D_GLIBCXX_USE_CXX11_ABI=0.
  #   extraDependencies  - Additional runtime Python dependencies beyond torch
  #                        (default: [])
  #   pythonImportsCheck - Override the list of module names to check on import.
  #                        Pass [] to skip entirely.  Defaults to [ pname ].
  buildBinWheel =
    { pname
    , version
    , binaryHashesFile
    , torch
    , meta
    , cudaVersion        ? "cu12"
    , cxx11abi           ? "TRUE"
    , extraDependencies  ? []
    , pythonImportsCheck ? null   # null → [ pname ]
    }:
    let
      _assertLinux =
        if os == "linux" then true
        else throw "${pname} pre-built wheels are only available for Linux (got: ${os})";

      # ── Binary-hashes lookup ────────────────────────────────────────────────

      versionData     = (import binaryHashesFile).${cudaVersion};
      availableCompat = builtins.attrNames versionData;

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

      imports =
        if pythonImportsCheck != null then pythonImportsCheck else [ pname ];

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

      dependencies = [ torch ] ++ extraDependencies;

      doCheck = false;

      pythonImportsCheck = imports;

      inherit meta;
    };
}
