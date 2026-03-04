# Resolves a set of high-level derivations into concrete Python packages.
#
# High-level derivations (HLDs) describe a package without committing to a
# specific build.  Pass them together with a concrete environment config and
# this function produces:
#   - concrete package derivations for every requested package (plus any deps
#     that were implied transitively)
#   - an augmented Python interpreter with those packages overlaid in its
#     package set, so callers can write:
#       result.python.withPackages (ps: [ ps.torch ps."flash-attn" ps.numpy ])
#   - a ready-made environment with all resolved packages pre-installed
#
# ── Config fields ──────────────────────────────────────────────────────────────
#
#   pkgs       (required)  nixpkgs instance, e.g. from flake inputs
#   packages   (required)  list of HLDs to include; transitive deps are added
#                          automatically – passing just [ flash-attn ] is enough
#   python     (required)  Python version as "3.11" | "3.12" | "3.13" | "3.14"
#   cuda       (required)  CUDA toolkit version as "12.6" | "12.8"
#   pascal     (optional)  bool – use Pascal-compatible CUDA packages
#                          (cuDNN 9.10.2, cuTENSOR 2.1.0); default false
#   preferBin  (optional)  bool – prefer pre-built wheels over source builds;
#                          default true
#
# ── Usage ─────────────────────────────────────────────────────────────────────
#
#   let
#     pp = inputs.this-flake.pytorch-packages;
#
#     # Specifying flash-attn is enough – torch is implied automatically.
#     result = pp.concretise {
#       inherit pkgs;
#       python   = "3.13";
#       cuda     = "12.6";
#       pascal   = true;
#       packages = with pp; [ "flash-attn" "causal-conv1d" ];
#     };
#   in
#   # Option A – use the ready-made environment directly
#   result.env
#
#   # Option B – extend it with additional packages from nixpkgs
#   result.python.withPackages (ps: [ ps.torch ps."flash-attn" ps.numpy ])
#
#   # Option C – access individual concrete derivations
#   result.packages."torch"
#   result.packages."flash-attn"
#
# ── Return value ──────────────────────────────────────────────────────────────
#
#   {
#     python    # Python interpreter with concrete packages overlaid in its pkg set
#     packages  # { packageName -> derivation }  – all resolved packages incl. deps
#     env       # python.withPackages with every resolved package pre-installed
#   }

{ pkgs
, packages         # list of HLDs; transitive deps are collected automatically
, python           # "3.11" | "3.12" | "3.13" | "3.14"
, cuda             # "12.6" | "12.8"
, pascal    ? false
, preferBin ? true
}:

let
  lib = pkgs.lib;

  # ── Input validation ──────────────────────────────────────────────────────

  _validPythons = [ "3.11" "3.12" "3.13" "3.14" ];
  _validCudas   = [ "12.6" "12.8" ];

  _checkPython =
    builtins.elem python _validPythons
    || throw (
      "concretise: unsupported python '${python}'. "
      + "Valid values: ${lib.concatStringsSep " " _validPythons}"
    );

  _checkCuda =
    builtins.elem cuda _validCudas
    || throw (
      "concretise: unsupported cuda '${cuda}'. "
      + "Valid values: ${lib.concatStringsSep " " _validCudas}"
    );

  _checkPackages =
    builtins.isList packages && packages != []
    || throw "concretise: 'packages' must be a non-empty list of high-level derivations";

  _checkAllHLD =
    builtins.all (p: p._isHighLevelDerivation or false) packages
    || throw (
      "concretise: every entry in 'packages' must be a high-level derivation "
      + "(imported from torch/high-level.nix, flash-attn/high-level.nix, etc.). "
      + "Concrete derivations or plain nixpkgs packages are not accepted here."
    );

  # ── Python interpreter ────────────────────────────────────────────────────

  # Map human-friendly "3.13" → pkgs.python313
  pythonAttrName =
    "python" + lib.replaceStrings [ "." ] [ "" ] python;

  # Nix-style Python version key used in binary-hashes attrsets, e.g. "py313".
  # Matches the pyVer computed by generate-binary-hashes/lib.nix at build time.
  pyVer = "py" + lib.replaceStrings [ "." ] [ "" ] python;

  basePython =
    pkgs.${pythonAttrName}
    or (throw "concretise: python ${python} not found in nixpkgs as '${pythonAttrName}'");

  # ── CUDA label & package set ──────────────────────────────────────────────

  # The cudaLabel is the canonical key used in HLD binVersions attrsets.
  # Map human-friendly "12.6" → "cu126".
  cudaLabel =
    if      cuda == "12.6" then "cu126"
    else if cuda == "12.8" then "cu128"
    else throw "concretise: unsupported cuda '${cuda}'";  # unreachable after _checkCuda

  baseCudaPackages =
    if      cudaLabel == "cu126" then pkgs.cudaPackages_12_6
    else                              pkgs.cudaPackages_12_8;

  cudaPackages =
    if !pascal then
      baseCudaPackages
    else
      import ../torch/cuda-packages-pascal.nix {
        inherit pkgs cudaLabel;
        cudaPackages = baseCudaPackages;
      };

  # ── Retry wrappers ────────────────────────────────────────────────────────

  # GCC 13 is the maximum compiler version supported by CUDA 12.x.
  retryWrappersLib = import ../nix-retry-wrapper { inherit pkgs; gcc = pkgs.gcc13; };
  wrappers = retryWrappersLib.makeAllRetryWrappers cudaPackages { maxAttempts = 3; };

  # ── pkgs variant for building ─────────────────────────────────────────────

  # Override stdenv → GCC 13 (required by CUDA 12.x) and point python3 at the
  # chosen interpreter so that override.nix files automatically pick it up via
  # pkgs.python3 / pkgs.python3Packages.
  pkgsForBuild = pkgs // {
    stdenv          = pkgs.overrideCC pkgs.stdenv pkgs.gcc13;
    python3         = basePython;
    python3Packages = basePython.pkgs;
  };

  # ── Transitive dependency collection ─────────────────────────────────────

  # Starting from the user-supplied list, recursively expand highLevelDeps and
  # collect all reachable HLDs into an attrset keyed by packageName.
  # Each package is visited at most once (dedup by packageName).
  collectAll = userPackages:
    let
      go = acc: hld:
        if builtins.hasAttr hld.packageName acc
        then acc      # already visited – skip
        else
          # Record this HLD, then recurse into its direct deps.
          lib.foldl' go
            (acc // { ${hld.packageName} = hld; })
            (lib.attrValues hld.highLevelDeps);
    in
    lib.foldl' go {} userPackages;

  allHLDs = collectAll packages;

  # ── Topological sort ──────────────────────────────────────────────────────

  # Use lib.toposort so deeper dependency chains (beyond the current three
  # packages) are handled correctly without manual ordering.
  #
  # before a b = true  ⟺  a must be built before b
  #           ⟺  a is a direct high-level dependency of b
  topoResult = lib.toposort
    (a: b: builtins.hasAttr a.packageName b.highLevelDeps)
    (lib.attrValues allHLDs);

  sortedHLDs =
    if topoResult ? cycle
    then throw (
      "concretise: circular dependency detected among packages: "
      + lib.concatStringsSep " -> " (map (h: h.packageName) topoResult.cycle)
    )
    else topoResult.result;

  # ── Build one package ─────────────────────────────────────────────────────

  buildOne = resolvedDeps: hld:
    let
      availableVersions = hld.getVersions cudaLabel pyVer;
      sortedVersions    = lib.sort lib.versionOlder availableVersions;
      version           = if sortedVersions != [] then lib.last sortedVersions else null;
      useBin            = preferBin && version != null;
      args = {
        pkgs         = pkgsForBuild;
        inherit cudaPackages wrappers cudaLabel resolvedDeps version;
      };
    in
    if useBin
      then hld.buildBin   args
      else hld.buildSource (args // { version = null; });

  # ── Strict fold over sorted packages ─────────────────────────────────────

  # Builds each package in dependency order, accumulating resolvedDeps so that
  # dependents (flash-attn, causal-conv1d) can reference already-built packages.
  # ── Fail-early binary availability check ─────────────────────────────────

  # When preferBin is true, every requested package must have at least one
  # pre-built wheel for the requested cudaLabel.  Without this check the
  # failure would only surface inside buildOne as an opaque "not yet
  # implemented" throw from buildSource, which is hard to diagnose.
  # When preferBin is true every requested package must have at least one
  # pre-built wheel for the requested (cudaLabel, Python) combination.
  # getVersions now filters by both axes, so an empty result here means either
  # no CUDA wheel exists at all or no wheel exists for the requested Python
  # version — both are surfaced with a clear diagnostic before reaching buildOne.
  _checkBinAvailable =
    !preferBin || builtins.all (hld:
      hld.getVersions cudaLabel pyVer != []
      || throw (
        "concretise: no pre-built wheel available for '${hld.packageName}' "
        + "with cudaLabel '${cudaLabel}' and Python ${python} (${pyVer}). "
        + "Set preferBin = false to build from source (not yet implemented)."
      )
    ) sortedHLDs;

  concretePackages =
    lib.foldl'
      (acc: hld: acc // { ${hld.packageName} = buildOne acc hld; })
      {}
      sortedHLDs;

  # ── Augmented Python interpreter ──────────────────────────────────────────

  # Overlay the concrete packages into the Python package set so callers can:
  #   result.python.withPackages (ps: [ ps.torch ps."flash-attn" ps.numpy ])
  augmentedPython = basePython.override {
    packageOverrides = _self: _super: concretePackages;
  };

  env = augmentedPython.withPackages (_ps: lib.attrValues concretePackages);

in

# Force all validation before returning the result attrset.
assert _checkPython;
assert _checkCuda;
assert _checkPackages;
assert _checkAllHLD;
assert _checkBinAvailable;

{
  python   = augmentedPython;
  packages = concretePackages;
  inherit env;
}
