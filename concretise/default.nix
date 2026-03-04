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
#   pkgs                    (required)  nixpkgs instance, e.g. from flake inputs
#   packages                (required)  list of HLDs to include; transitive deps
#                                       are added automatically
#   python                  (required)  Python version as "3.11"|"3.12"|"3.13"|"3.14"
#   cuda                    (required)  CUDA toolkit version as "12.6" | "12.8"
#   pascal                  (optional)  bool – use Pascal-compatible CUDA packages
#                                       (cuDNN 9.10.2, cuTENSOR 2.1.0); default false
#   allowBuildingFromSource (required)  bool – set to true to fall back to source
#                                       builds when no pre-built wheel is available;
#                                       set to false to fail early if any package
#                                       lacks a pre-built wheel (source builds are
#                                       not yet implemented, so false is the safe
#                                       choice for now)
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
, packages                # list of HLDs; transitive deps are collected automatically
, python                  # "3.11" | "3.12" | "3.13" | "3.14"
, cuda                    # "12.6" | "12.8"
, torch                   # required – major.minor torch series, e.g. "2.10"
                          # Wheels are NOT forward-compatible across minor versions,
                          # so this must be specified explicitly to avoid silently
                          # selecting an incompatible torch build.
, pascal             ? false
, allowBuildingFromSource  # required – true to allow source builds, false to fail early
}:

let
  lib = pkgs.lib;

  # ── Input validation ──────────────────────────────────────────────────────

  _validPythons = [ "3.11" "3.12" "3.13" "3.14" ];
  _validCudas   = [ "12.6" "12.8" ];

  # torch is validated as a free-form "major.minor" string rather than an
  # enumerated list, because new minor releases appear frequently.
  _checkTorch =
    builtins.match "[0-9]+\\.[0-9]+" torch != null
    || throw (
      "concretise: 'torch' must be a major.minor version string "
      + "(e.g. \"2.10\"), got '${toString torch}'"
    );

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

  # ── Compiler-version validation ───────────────────────────────────────────

  # CUDA 12.x requires GCC in the range [12, 13] (inclusive).  We always pin
  # GCC 13 explicitly via pkgs.gcc13, so we verify:
  #   (a) pkgs.gcc13 exists in the provided nixpkgs instance, and
  #   (b) its version string actually starts with "13." so a future nixpkgs
  #       rename/alias does not silently slip through.
  #
  # An incompatible host compiler causes sporadic runtime crashes that are
  # very hard to diagnose, so we fail at evaluation time with a clear message.
  _gcc13Version = pkgs.gcc13.version or null;

  _checkCudaCompiler =
    let
      ver = _gcc13Version;
      major = if ver != null
              then lib.toInt (builtins.head (lib.strings.splitString "." ver))
              else null;
    in
    (ver != null && major == 13)
    || throw (
      if ver == null
      then
        "concretise: pkgs.gcc13 is not available in the provided nixpkgs instance. "
        + "CUDA 12.x requires GCC 13 for building. "
        + "Please use a nixpkgs revision that provides gcc13."
      else
        "concretise: pkgs.gcc13 reports version '${ver}' (major ${toString major}), "
        + "expected 13.x. "
        + "CUDA 12.x requires GCC 13. "
        + "Please check your nixpkgs revision."
    );


  # ── Python interpreter ────────────────────────────────────────────────────

  # Map human-friendly "3.13" → pkgs.python313
  pythonAttrName =
    "python" + lib.replaceStrings [ "." ] [ "" ] python;

  # Nix-style Python version key used in binary-hashes attrsets, e.g. "py313".
  # Matches the pyVer computed by generate-hashes/lib.nix at build time.
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
      import ../pkgs/torch/cuda-packages-pascal.nix {
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

  # ── Topological sort ─────────────────────────────────────────────────────

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

  # ── Version constraints ───────────────────────────────────────────────────

  # Each HLD may declare versionConstraints = { "depPkgName" = { maxVersion = …; }; }
  # Collect all constraints from all HLDs in this build and merge them by
  # package name.  When two HLDs constrain the same dependency:
  #   - maxVersion: take the stricter (lower) bound
  #   - minVersion: take the stricter (higher) bound
  allVersionConstraints =
    lib.foldl' (acc: hld:
      let
        constraints = hld.versionConstraints or {};
      in
      lib.foldl' (acc2: depName:
        let
          existing  = acc2.${depName} or {};
          incoming  = constraints.${depName};
          maxVersion =
            if existing ? maxVersion && incoming ? maxVersion
            then
              if lib.versionOlder existing.maxVersion incoming.maxVersion
              then existing.maxVersion    # existing bound is lower → stricter
              else incoming.maxVersion
            else existing.maxVersion or incoming.maxVersion or null;
          minVersion =
            if existing ? minVersion && incoming ? minVersion
            then
              if lib.versionOlder incoming.minVersion existing.minVersion
              then existing.minVersion    # existing bound is higher → stricter
              else incoming.minVersion
            else existing.minVersion or incoming.minVersion or null;
          merged =
            {}
            // (if maxVersion != null then { inherit maxVersion; } else {})
            // (if minVersion != null then { inherit minVersion; } else {});
        in
        acc2 // { ${depName} = merged; }
      ) acc (builtins.attrNames constraints)
    ) {} sortedHLDs;

  # Apply the collected constraints for a given package name to a list of
  # version strings, returning only those that satisfy all bounds.
  applyVersionConstraints = pkgName: versions:
    let
      c      = allVersionConstraints.${pkgName} or {};
      maxOk  = v: !(c ? maxVersion) || !(lib.versionOlder c.maxVersion v);
      minOk  = v: !(c ? minVersion) || !(lib.versionOlder v c.minVersion);
    in
    lib.filter (v: maxOk v && minOk v) versions;

  # ── Build one package ─────────────────────────────────────────────────────

  # Return the major.minor prefix of a full version string, e.g. "2.10.0" → "2.10".
  _majorMinorOf = v:
    let parts = lib.splitString "." v;
    in lib.concatStringsSep "." (lib.take 2 parts);

  buildOne = resolvedDeps: hld:
    let
      allVersionsRaw = hld.getVersions cudaLabel pyVer;
      # For torch itself, restrict version selection to the caller-specified
      # major.minor series.  Binary wheels are not forward-compatible across
      # minor versions, so "latest overall" is wrong when the user has pinned
      # a specific series.
      allVersions =
        if hld.packageName == "torch"
        then lib.filter (v: _majorMinorOf v == torch) allVersionsRaw
        else allVersionsRaw;
      constrainedVersions = applyVersionConstraints hld.packageName allVersions;
      sortedVersions      = lib.sort lib.versionOlder constrainedVersions;
      version             = if sortedVersions != [] then lib.last sortedVersions else null;
      args = {
        pkgs         = pkgsForBuild;
        inherit cudaPackages wrappers cudaLabel resolvedDeps version;
      };
      # canBuildBin is an optional HLD field (default: always true).
      # It lets a package signal that a discovered binary version is ABI-
      # incompatible with the resolved dependencies (e.g. causal-conv1d wheels
      # built against torch <= 2.8 are broken at runtime against torch >= 2.9).
      # When false and allowBuildingFromSource is set, we fall back to
      # buildSource (passing the resolved version so the source build knows
      # exactly which release to compile).
      binCompatible = version != null &&
        hld.canBuildBin { inherit resolvedDeps version cudaLabel; };
    in
    if binCompatible
      then hld.buildBin args
      else if allowBuildingFromSource
        then hld.buildSource args
        else throw (
          "concretise: no usable pre-built wheel for '${hld.packageName}' "
          + "with cudaLabel '${cudaLabel}' and Python ${python} (${pyVer})"
          + (if version == null
             then
               let c = allVersionConstraints.${hld.packageName} or {}; in
               if c != {}
               then " (no binary version found after applying versionConstraints: "
                    + "${builtins.toJSON c}; unconstrained versions: "
                    + lib.concatStringsSep ", " (lib.sort lib.versionOlder allVersions)
                    + ")"
               else " (no binary version found)"
             else " (version ${version} is ABI-incompatible with resolved dependencies)")
          + ". Set allowBuildingFromSource = true to build from source."
        );

  # ── Strict fold over sorted packages ─────────────────────────────────────

  # Builds each package in dependency order, accumulating resolvedDeps so that
  # dependents (flash-attn, causal-conv1d) can reference already-built packages.

  # ── Fail-early binary availability check ─────────────────────────────────

  # When allowBuildingFromSource is false, every requested package must have at
  # least one pre-built wheel for the requested (cudaLabel, Python) combination
  # after applying versionConstraints.  Without this check the failure would only
  # surface inside buildOne as an opaque error from buildSource or a missing-wheel
  # throw, which is hard to diagnose.
  _checkBinAvailable =
    allowBuildingFromSource ||
    builtins.all (hld:
      let
        allVersionsRaw      = hld.getVersions cudaLabel pyVer;
        allVersions         =
          if hld.packageName == "torch"
          then lib.filter (v: _majorMinorOf v == torch) allVersionsRaw
          else allVersionsRaw;
        constrainedVersions = applyVersionConstraints hld.packageName allVersions;
        c                   = allVersionConstraints.${hld.packageName} or {};
      in
      constrainedVersions != []
      || throw (
        "concretise: no pre-built wheel available for '${hld.packageName}' "
        + "with cudaLabel '${cudaLabel}' and Python ${python} (${pyVer})"
        + (if allVersions != [] && constrainedVersions == []
           then
             " (after applying versionConstraints: ${builtins.toJSON c}; "
             + "unconstrained versions: "
             + lib.concatStringsSep ", " (lib.sort lib.versionOlder allVersions)
             + ")"
           else "")
        + ". Set allowBuildingFromSource = true to build from source "
        + "(source builds are not yet implemented)."
      )
    ) sortedHLDs;

  # ── Concretise marker ─────────────────────────────────────────────────────

  # An opaque string key that uniquely identifies the parameters of THIS
  # concretise call.  Every concrete package is stamped with it via
  # passthru.concretiseMarker so that the withPackages wrapper below can
  # detect when packages from two separate concretise calls (with different
  # CUDA / Python / Pascal settings) are mixed into a single Python environment.
  concretiseMarkerKey =
    "cuda=${cuda},pascal=${if pascal then "true" else "false"},python=${python}";

  # Stamp a derivation with the marker.  Works for any package that supports
  # overrideAttrs (all stdenv.mkDerivation / buildPythonPackage descendants).
  addMarker = drv:
    drv.overrideAttrs (old: {
      passthru = (old.passthru or {}) // {
        concretiseMarker = concretiseMarkerKey;
      };
    });

  concretePackages =
    lib.foldl'
      (acc: hld: acc // { ${hld.packageName} = addMarker (buildOne acc hld); })
      {}
      sortedHLDs;

  # ── Augmented Python interpreter ──────────────────────────────────────────

  # Overlay the concrete packages into the Python package set so callers can:
  #   result.python.withPackages (ps: [ ps.torch ps."flash-attn" ps.numpy ])
  augmentedPython = basePython.override {
    packageOverrides = _self: _super: concretePackages;
  };

  # ── withPackages mixing-detection wrapper ─────────────────────────────────

  # Wraps augmentedPython.withPackages so that if the caller passes a package
  # whose concretiseMarker differs from ours (i.e. it came from a different
  # concretise call with different cuda/pascal/python settings), evaluation
  # fails immediately with a clear diagnostic.
  #
  # The check is best-effort: packages without a concretiseMarker (e.g. plain
  # nixpkgs packages like numpy) are silently accepted.
  checkedWithPackages = f:
    let
      pkgSet        = augmentedPython.pkgs;
      requestedPkgs = f pkgSet;

      foreignPkgs = lib.filter
        (p:
          (p.passthru.concretiseMarker or null) != null &&
          p.passthru.concretiseMarker != concretiseMarkerKey)
        requestedPkgs;

      _checkMixing =
        foreignPkgs == []
        || throw (
          "concretise: mixing packages from different concretise calls is not allowed. "
          + "The following packages were concretised with different settings "
          + "(expected '${concretiseMarkerKey}'): "
          + lib.concatStringsSep ", "
              (map (p: "'${p.pname or p.name}' (${p.passthru.concretiseMarker})") foreignPkgs)
          + ". Make sure all packages in withPackages come from the same concretise call."
        );
    in
    assert _checkMixing;
    augmentedPython.withPackages f;

  # Expose the augmented Python with the mixing-detection wrapper in place of
  # the stock withPackages function.
  checkedPython = augmentedPython // { withPackages = checkedWithPackages; };

  env = checkedPython.withPackages (_ps: lib.attrValues concretePackages);

  devShell = pkgs.mkShell {
    packages = [ env ];
  };

in

# Force all validation before returning the result attrset.
assert _checkPython;
assert _checkCuda;
assert _checkPackages;
assert _checkAllHLD;
assert _checkCudaCompiler;
assert _checkBinAvailable;

{
  python   = checkedPython;
  packages = concretePackages;
  inherit env devShell;
}
