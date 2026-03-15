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
#       python     = "3.13";
#       cuda       = "12.8";
#       pascal     = false;
#       mlPackages = with pp; [ flash-attn causal-conv1d ];
#     };
#   in
#   # Option A – use the ready-made environment directly
#   result.env
#
#   # Option B – pass extra Python packages directly to concretise
#   result = pp.concretise {
#     …
#     mlPackages          = with pp; [ flash-attn causal-conv1d ];
#     extraPythonPackages = ps: [ ps.pandas ps.numpy ];
#   };
#   result.env   # already contains torch + flash-attn + causal-conv1d + pandas + numpy
#
#   # Option C – extend an existing result with more packages after the fact
#   # extendEnv already includes all HLD-managed + extraPythonPackages; no re-listing needed.
#   result.extendEnv (ps: [ ps.matplotlib ])
#
#   # Option D – access individual concrete derivations
#   result.packages."torch"
#   result.packages."flash-attn"
#
# ── Return value ──────────────────────────────────────────────────────────────
#
#   {
#     python             # Python interpreter with concrete packages overlaid in its pkg set
#     packages           # { packageName -> derivation }  – all resolved packages incl. deps
#     env                # withPackages containing all HLD + extraPythonPackages
#     extendEnv          # (ps: […]): new env adding more packages on top of env;
#                        #   HLD packages and extraPythonPackages are included automatically
#     devShell           # mkShell containing env
#   }

{
  pkgs,
  mlPackages, # list of HLDs; transitive deps are collected automatically
  extraPythonPackages ? _ps: [ ],
  # withPackages-style function for additional nixpkgs Python
  # packages to include in env alongside the HLD packages,
  # e.g. extraPythonPackages = ps: [ ps.pandas ps.numpy ]
  pythonPackageOverrides ? _self: _super: { },
  # Optional overlay applied to basePython.pkgs BEFORE any
  # HLD packages are built.  Use this to pin or override
  # non-HLD Python packages (e.g. einops, transformers) that
  # HLD overlay files pull in via pkgs.python3Packages.
  # Applied after HDL resolution but before package building.
  # Example:
  #   pythonPackageOverrides = self: super: {
  #     einops = super.einops.overrideAttrs { version = "0.9.0"; };
  #   };
  python, # "3.11" | "3.12" | "3.13" | "3.14"
  cuda, # "12.6" | "12.8" | "13.0"
  torch,
  # required – major.minor torch series, e.g. "2.10"
  # Wheels are NOT forward-compatible across minor versions,
  # so this must be specified explicitly to avoid silently
  # selecting an incompatible torch build.
  pascal ? false,
  # Enable Pascal (sm_60/sm_61) GPU support (default: false).
  # WARNING: Pascal support is not validated per library –
  # setting pascal = true may cause build failures or silently
  # broken binaries for packages whose upstream wheels were not
  # compiled for sm_60.  Only set this if you know all requested
  # libraries support it.
  allowBuildingFromSource, # required – true: fall back to a source build when no
  # pre-built wheel exists for the requested combination.
  # false: fail at evaluation time if any package lacks a wheel
  # (safe default – avoids surprise multi-hour compilations).
}:

let
  lib = pkgs.lib;

  # ── Input validation ──────────────────────────────────────────────────────

  _validPythons = [
    "3.11"
    "3.12"
    "3.13"
    "3.14"
  ];
  _validCudas = [
    "12.6"
    "12.8"
    "13.0"
  ];

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
      "concretise: unsupported cuda '${cuda}'. " + "Valid values: ${lib.concatStringsSep " " _validCudas}"
    );

  _checkPackages =
    builtins.isList mlPackages && mlPackages != [ ]
    || throw "concretise: 'mlPackages' must be a non-empty list of high-level derivations";

  _checkAllHLD =
    builtins.all (p: p._isHighLevelDerivation or false) mlPackages
    || throw (
      "concretise: every entry in 'mlPackages' must be a high-level derivation "
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
      major = if ver != null then lib.toInt (builtins.head (lib.strings.splitString "." ver)) else null;
    in
    (ver != null && major == 13)
    || throw (
      if ver == null then
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
  pythonAttrName = "python" + lib.replaceStrings [ "." ] [ "" ] python;

  # Nix-style Python version key used in binary-hashes attrsets, e.g. "py313".
  # Matches the pyVer computed by generate-hashes/lib.nix at build time.
  pyVer = "py" + lib.replaceStrings [ "." ] [ "" ] python;

  _rawPython =
    pkgs.${pythonAttrName}
      or (throw "concretise: python ${python} not found in nixpkgs as '${pythonAttrName}'");

  # Apply user-supplied pythonPackageOverrides to the base interpreter so that
  # HLD overlay files (which reference pkgs.python3Packages.*) see the
  # overridden packages.  This runs AFTER HDL resolution but BEFORE packages
  # are built, giving the user a hook to pin or replace non-HLD dependencies
  # (e.g. einops, transformers) without touching HLD definitions.
  basePython = _rawPython.override {
    packageOverrides = pythonPackageOverrides;
  };

  # ── CUDA label & package set ──────────────────────────────────────────────

  # The cudaLabel is the canonical key used in HLD binVersions attrsets.
  # Map human-friendly "12.6" → "cu126".
  cudaLabel =
    if cuda == "12.6" then
      "cu126"
    else if cuda == "12.8" then
      "cu128"
    else if cuda == "13.0" then
      "cu130"
    else
      throw "concretise: unsupported cuda '${cuda}'"; # unreachable after _checkCuda

  baseCudaPackages =
    if cudaLabel == "cu126" then
      pkgs.cudaPackages_12_6
    else if cudaLabel == "cu128" then
      pkgs.cudaPackages_12_8
    else
      pkgs.cudaPackages_13_0;

  # torch 2.10.0 wheels for cu126/cu130 were compiled against cuDNN 9.15.1,
  # while nixpkgs currently ships 9.13.0 for all CUDA package sets.
  # Upgrade cuDNN to 9.15.1 for those labels so that autoPatchelfHook wires
  # the correct version into every package built in this concretise call.
  cudaPackagesWithCudnn =
    if cudaLabel == "cu126" || cudaLabel == "cu130" then
      import ../pkgs/torch/cuda-packages-cudnn-fix.nix {
        inherit pkgs cudaLabel;
        cudaPackages = baseCudaPackages;
      }
    else
      baseCudaPackages;

  cudaPackages =
    if !pascal then
      cudaPackagesWithCudnn
    else
      import ../pkgs/torch/cuda-packages-pascal.nix {
        inherit pkgs cudaLabel;
        cudaPackages = cudaPackagesWithCudnn;
      };

  # ── Retry wrappers (currently disabled) ───────────────────────────────────
  #
  # The nix-retry-wrapper/ infrastructure is kept for potential future use
  # (e.g. OOM avoidance, transient nvcc failure recovery).  It is not wired
  # into the build pipeline right now because even a no-op wrapper derivation
  # would change derivation input hashes compared to a plain build.
  #
  # To re-enable, uncomment the two lines below and add `wrappers` back to
  # the `args` attrset in buildOne (search for "inherit cudaPackages").
  #
  # retryWrappersLib = import ../nix-retry-wrapper { inherit pkgs; gcc = pkgs.gcc13; };
  # wrappers = retryWrappersLib.makeAllRetryWrappers cudaPackages { maxAttempts = 3; };

  # ── pkgs variant for building ─────────────────────────────────────────────

  # Override stdenv → GCC 13 (required by CUDA 12.x) and point python3 at the
  # chosen interpreter so that overlay-bin.nix files automatically pick it up via
  # pkgs.python3 / pkgs.python3Packages.
  pkgsForBuild = pkgs // {
    stdenv = pkgs.overrideCC pkgs.stdenv pkgs.gcc13;
    python3 = basePython;
    python3Packages = basePython.pkgs;
  };

  # ── Transitive dependency collection ─────────────────────────────────────

  # Starting from the user-supplied list, recursively expand highLevelDeps and
  # collect all reachable HLDs into an attrset keyed by packageName.
  # Each package is visited at most once (dedup by packageName).
  collectAll =
    userPackages:
    let
      go =
        acc: hld:
        if builtins.hasAttr hld.packageName acc then
          acc # already visited – skip
        else
          # Record this HLD, then recurse into its direct deps.
          lib.foldl' go (acc // { ${hld.packageName} = hld; }) (lib.attrValues hld.highLevelDeps);
    in
    lib.foldl' go { } userPackages;

  allHLDs = collectAll mlPackages;

  # ── Topological sort ─────────────────────────────────────────────────────

  # Use lib.toposort so deeper dependency chains (beyond the current three
  # packages) are handled correctly without manual ordering.
  #
  # before a b = true  ⟺  a must be built before b
  #           ⟺  a is a direct high-level dependency of b
  topoResult = lib.toposort (a: b: builtins.hasAttr a.packageName b.highLevelDeps) (
    lib.attrValues allHLDs
  );

  sortedHLDs =
    if topoResult ? cycle then
      throw (
        "concretise: circular dependency detected among packages: "
        + lib.concatStringsSep " -> " (map (h: h.packageName) topoResult.cycle)
      )
    else
      topoResult.result;

  # ── Version constraints ───────────────────────────────────────────────────

  # Each HLD may declare versionConstraints = { "depPkgName" = { maxVersion = …; }; }
  # Collect all constraints from all HLDs in this build and merge them by
  # package name.  When two HLDs constrain the same dependency:
  #   - maxVersion: take the stricter (lower) bound
  #   - minVersion: take the stricter (higher) bound
  allVersionConstraints = lib.foldl' (
    acc: hld:
    let
      constraints = hld.versionConstraints or { };
    in
    lib.foldl' (
      acc2: depName:
      let
        existing = acc2.${depName} or { };
        incoming = constraints.${depName};
        maxVersion =
          if existing ? maxVersion && incoming ? maxVersion then
            if lib.versionOlder existing.maxVersion incoming.maxVersion then
              existing.maxVersion # existing bound is lower → stricter
            else
              incoming.maxVersion
          else
            existing.maxVersion or incoming.maxVersion or null;
        minVersion =
          if existing ? minVersion && incoming ? minVersion then
            if lib.versionOlder incoming.minVersion existing.minVersion then
              existing.minVersion # existing bound is higher → stricter
            else
              incoming.minVersion
          else
            existing.minVersion or incoming.minVersion or null;
        merged =
          { }
          // (if maxVersion != null then { inherit maxVersion; } else { })
          // (if minVersion != null then { inherit minVersion; } else { });
      in
      acc2 // { ${depName} = merged; }
    ) acc (builtins.attrNames constraints)
  ) { } sortedHLDs;

  # Apply the collected constraints for a given package name to a list of
  # version strings, returning only those that satisfy all bounds.
  applyVersionConstraints =
    pkgName: versions:
    let
      c = allVersionConstraints.${pkgName} or { };
      maxOk = v: !(c ? maxVersion) || !(lib.versionOlder c.maxVersion v);
      minOk = v: !(c ? minVersion) || !(lib.versionOlder v c.minVersion);
    in
    lib.filter (v: maxOk v && minOk v) versions;

  # ── Build one package ─────────────────────────────────────────────────────

  # Return the major.minor prefix of a full version string, e.g. "2.10.0" → "2.10".
  _majorMinorOf =
    v:
    let
      parts = lib.splitString "." v;
    in
    lib.concatStringsSep "." (lib.take 2 parts);

  # Shared version-selection logic used by both buildOne and _checkBinAvailable.
  # Returns { allVersions, constrainedVersions, version } for a given HLD.
  # Having it here avoids duplicating the torch-series filter and constraint
  # application in two places.
  _selectVersion =
    hld:
    let
      allVersionsRaw = hld.getVersions cudaLabel pyVer;
      # For torch, restrict selection to the caller-specified major.minor series.
      # Binary wheels are not forward-compatible across minor versions.
      allVersions =
        if hld.packageName == "torch" then
          lib.filter (v: _majorMinorOf v == torch) allVersionsRaw
        else
          allVersionsRaw;
      constrainedVersions = applyVersionConstraints hld.packageName allVersions;
      sortedVersions = lib.sort lib.versionOlder constrainedVersions;
      version = if sortedVersions != [ ] then lib.last sortedVersions else null;
    in
    {
      inherit allVersions constrainedVersions version;
    };

  # Pre-resolved version stubs — computed once in topological order so that
  # _checkBinAvailable can pass them as a fake resolvedDeps to canBuildBin.
  # Each entry is a minimal attrset { version = "…"; }; canBuildBin only reads
  # .version from its resolvedDeps argument.
  #
  # Because sortedHLDs is in dependency order (torch before causal-conv1d etc.),
  # the fold here mirrors the dependency order and ensures torch's stub is
  # present before causal-conv1d's canBuildBin is evaluated.
  preResolvedVersions = lib.foldl' (
    acc: hld:
    let
      version = (_selectVersion hld).version;
    in
    acc // { ${hld.packageName} = { inherit version; }; }
  ) { } sortedHLDs;

  # Digits-only torch series string used in store-path name suffixes.
  # e.g. torch = "2.10" → _torchSeriesDigits = "210"
  _torchSeriesDigits = lib.replaceStrings [ "." ] [ "" ] torch;

  # Build a concrete package for *hld* given already-resolved *resolvedDeps*,
  # then stamp the resulting derivation so that its Nix store-path name encodes
  # the torch series, CUDA label, pascal flag, and build type (bin vs. source).
  #
  # Example store-path name transformation:
  #   flash-attention-2.8.3  →  flash-attention-2.8.3-torch210-cu128-bin
  #   causal-conv1d-1.6.0    →  causal-conv1d-1.6.0-torch210-cu128
  #   torch-2.10.0           →  torch-2.10.0-cu128-bin     (no duplicate "torch")
  #   triton-3.6.0           →  triton-3.6.0-bin           (CUDA-agnostic: no cuda/torch/pascal)
  #
  # The stamp also injects passthru.concretiseMarker for cross-call mixing
  # detection in checkedWithPackages.
  buildAndStamp =
    resolvedDeps: hld:
    let
      sel = _selectVersion hld;
      version = sel.version;
      args = {
        pkgs = pkgsForBuild;
        inherit
          cudaPackages
          cudaLabel
          resolvedDeps
          version
          ;
        mkOverlayInfo = hld.mkOverlayInfo;
        # inherit wrappers; # re-enable together with wrappers above
      };
      # canBuildBin is an optional HLD field (default: always true).
      # It lets a package signal that a discovered binary version is ABI-
      # incompatible with the resolved dependencies (e.g. causal-conv1d wheels
      # built against torch <= 2.8 are broken at runtime against torch >= 2.9).
      # When false and allowBuildingFromSource is set, we fall back to
      # buildSource.
      binCompatible = version != null && hld.canBuildBin { inherit resolvedDeps version cudaLabel; };
      drv =
        if binCompatible then
          hld.buildBin args
        else if allowBuildingFromSource then
          hld.buildSource args
        else
          throw (
            "concretise: no usable pre-built wheel for '${hld.packageName}' "
            + "with cudaLabel '${cudaLabel}' and Python ${python} (${pyVer})"
            + (
              if version == null then
                let
                  c = allVersionConstraints.${hld.packageName} or { };
                in
                if c != { } then
                  " (no binary version found after applying versionConstraints: "
                  + "${builtins.toJSON c}; unconstrained versions: "
                  + lib.concatStringsSep ", " (lib.sort lib.versionOlder sel.allVersions)
                  + ")"
                else
                  " (no binary version found)"
              else
                " (version ${version} is ABI-incompatible with resolved dependencies)"
            )
            + ". Set allowBuildingFromSource = true to build from source."
          );
      # Suffix appended to the Nix store-path name to make builds for different
      # torch/CUDA/pascal combinations visually distinct in the store.
      #
      # cudaAgnostic packages (e.g. triton) produce wheels that are identical
      # across all CUDA and torch versions, so their stamp is just "-bin".
      # The torch package itself skips the "-torch…" prefix since its own
      # pname already encodes the package identity.
      cudaAgnostic = hld.cudaAgnostic or false;
      torchAgnostic = hld.torchAgnostic or false;
      isTorchPkg = hld.packageName == "torch";
      # torchAgnostic packages (e.g. bitsandbytes) do not link against torch
      # at the C++/ABI level, so they skip the -torch{series} dimension.
      # cudaAgnostic packages (e.g. triton) skip all of cuda/torch/pascal.
      nameSuffix =
        lib.optionalString (!cudaAgnostic && !torchAgnostic && !isTorchPkg) "-torch${_torchSeriesDigits}"
        + lib.optionalString (!cudaAgnostic) "-${cudaLabel}"
        + lib.optionalString (!cudaAgnostic && pascal) "-pascal"
        + lib.optionalString binCompatible "-bin";
    in
    drv.overrideAttrs (old: {
      # pname is intentionally left unchanged so ps.<pname> lookups still work.
      # Use basePython.version (e.g. "3.13.11") rather than the
      # pythonVersion attribute ("3.13") that buildPythonPackage embeds in
      # the default name, so the full patch release is visible in the store.
      name = "python${basePython.version}-${old.pname}-${old.version}${nameSuffix}";
      passthru = (old.passthru or { }) // {
        concretiseMarker = concretiseMarkerKey;
      };
    });

  # ── Strict fold over sorted packages ─────────────────────────────────────

  # Builds each package in dependency order, accumulating resolvedDeps so that
  # dependents (flash-attn, causal-conv1d) can reference already-built packages.

  # ── Fail-early binary availability check ─────────────────────────────────

  # When allowBuildingFromSource is false, every requested package must have a
  # usable pre-built wheel: a version must exist in the binary-hashes directory
  # AND canBuildBin must return true for that version given the pre-resolved
  # dependency versions (preResolvedVersions).
  #
  # This catches both "no binary at all" and "binary exists but is
  # ABI-incompatible with the selected torch version" before any expensive
  # build evaluation begins.  Without this check the latter case would only
  # surface inside buildOne — still with a clear error, but later.
  _checkBinAvailable =
    allowBuildingFromSource
    || builtins.all (
      hld:
      let
        sel = _selectVersion hld;
        version = sel.version;
        c = allVersionConstraints.${hld.packageName} or { };
        binCompatible =
          version != null
          && hld.canBuildBin {
            resolvedDeps = preResolvedVersions;
            inherit version cudaLabel;
          };
      in
      binCompatible
      || throw (
        "concretise: no usable pre-built wheel for '${hld.packageName}' "
        + "with cudaLabel '${cudaLabel}' and Python ${python} (${pyVer})"
        + (
          if version == null then
            (
              if sel.allVersions != [ ] && sel.constrainedVersions == [ ] then
                " (no binary version found after applying versionConstraints: "
                + "${builtins.toJSON c}; unconstrained versions: "
                + lib.concatStringsSep ", " (lib.sort lib.versionOlder sel.allVersions)
                + ")"
              else
                ""
            )
          else
            let
              torchV = (preResolvedVersions."torch" or { }).version or "unknown";
            in
            " (version ${version} is ABI-incompatible with" + " torch ${torchV})"
        )
        + ". Set allowBuildingFromSource = true to fall back to a source build."
      )
    ) sortedHLDs;

  # ── Concretise marker ─────────────────────────────────────────────────────

  # An opaque string key that uniquely identifies the parameters of THIS
  # concretise call.  Every concrete package is stamped with it via
  # passthru.concretiseMarker so that the withPackages wrapper below can
  # detect when packages from two separate concretise calls (with different
  # CUDA / Python / Pascal settings) are mixed into a single Python environment.
  concretiseMarkerKey = "cuda=${cuda},pascal=${if pascal then "true" else "false"},python=${python}";

  concretePackages = lib.foldl' (
    acc: hld: acc // { ${hld.packageName} = buildAndStamp acc hld; }
  ) { } sortedHLDs;

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
  checkedWithPackages =
    f:
    let
      pkgSet = augmentedPython.pkgs;
      requestedPkgs = f pkgSet;

      foreignPkgs = lib.filter (
        p:
        (p.passthru.concretiseMarker or null) != null && p.passthru.concretiseMarker != concretiseMarkerKey
      ) requestedPkgs;

      _checkMixing =
        foreignPkgs == [ ]
        || throw (
          "concretise: mixing packages from different concretise calls is not allowed. "
          + "The following packages were concretised with different settings "
          + "(expected '${concretiseMarkerKey}'): "
          + lib.concatStringsSep ", " (
            map (p: "'${p.pname or p.name}' (${p.passthru.concretiseMarker})") foreignPkgs
          )
          + ". Make sure all packages in withPackages come from the same concretise call."
        );
    in
    assert _checkMixing;
    augmentedPython.withPackages f;

  # Expose the augmented Python with the mixing-detection wrapper in place of
  # the stock withPackages function.
  checkedPython = augmentedPython // {
    withPackages = checkedWithPackages;
  };

  # ── Extra-package collision guard ─────────────────────────────────────────

  # Build a set of names that are owned by the HLD concretise pipeline so that
  # extra packages supplied by the caller cannot shadow them.  We index by both
  # the attrset key (HLD packageName, e.g. "flash-attn") and the derivation's
  # own pname/name, whichever is available.
  concreteNameSet =
    let
      byKey = builtins.mapAttrs (_: _: true) concretePackages;
      byPname = builtins.listToAttrs (
        map (p: {
          name = p.pname or p.name;
          value = true;
        }) (lib.attrValues concretePackages)
      );
    in
    byKey // byPname;

  # Build a set of names propagated directly by concrete packages.
  #
  # Concrete packages are built against basePython.pkgs (via pkgsForBuild),
  # while extraPythonPackages receives ps = augmentedPython.pkgs.  Although
  # basePython and augmentedPython produce the same Python binary, they are
  # different Nix derivation objects; every package built against them
  # therefore has a distinct store path — even for packages like "einops" that
  # do not depend on torch at all.
  #
  # Consequence: if a concrete package propagates e.g. "einops" (from
  # basePython.pkgs) and the user also requests ps.einops (from
  # augmentedPython.pkgs), buildEnv sees two paths for the same Python module
  # and aborts with a "conflicting subpath" error.
  #
  # Fix: treat the direct propagatedBuildInputs of every concrete package as
  # also "owned" by the pipeline.  filterExtras then silently drops any
  # extraPythonPackages entry whose name matches — the version already in the
  # closure (via the concrete package) wins.
  propagatedByConcreteSet = builtins.listToAttrs (
    lib.concatMap (
      p:
      let
        n = p.pname or (p.name or null);
      in
      if n != null then
        [
          {
            name = n;
            value = true;
          }
        ]
      else
        [ ]
    ) (lib.concatMap (pkg: pkg.propagatedBuildInputs or [ ]) (lib.attrValues concretePackages))
  );

  # Drop any package from `extras` whose pname/name collides with either a
  # directly concretise-managed package or a package already propagated into
  # the env by one of those managed packages.  Packages without a recognisable
  # name attribute are passed through unchanged.
  filterExtras =
    extras:
    lib.filter (
      p:
      let
        n = p.pname or (p.name or null);
      in
      n == null || (!(concreteNameSet ? ${n}) && !(propagatedByConcreteSet ? ${n}))
    ) extras;

  env = checkedPython.withPackages (
    ps: lib.attrValues concretePackages ++ filterExtras (extraPythonPackages ps)
  );

  # Builds a new environment that contains all HLD-managed packages,
  # extraPythonPackages, plus whatever the caller adds.  The caller only needs
  # to list the *additional* packages beyond what was already passed to
  # concretise; everything else is included automatically.
  # Any package whose name collides with an HLD-managed one is silently dropped
  # from the extras so the concretise-resolved version always wins.
  #
  # Usage:
  #   result.extendEnv (ps: with ps; [ matplotlib scikit-learn ])
  extendEnv =
    morePkgs:
    checkedPython.withPackages (
      ps:
      lib.attrValues concretePackages
      ++ filterExtras (extraPythonPackages ps)
      ++ filterExtras (morePkgs ps)
    );

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
  python = checkedPython;
  packages = concretePackages;
  inherit env devShell extendEnv;

  # Per-package test scripts for all HLDs that have one.
  # Each entry is { name = "flash-attn"; script = /nix/store/...-manual_debug.py; }.
  # Used by test.nix to automatically discover and run per-package tests.
  testScripts = lib.filter (e: e != null) (
    map (
      hld:
      let
        s = hld.testScript or null;
      in
      if s != null then
        {
          name = hld.packageName;
          script = s;
        }
      else
        null
    ) (lib.attrValues allHLDs)
  );
}
