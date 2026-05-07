# pkgs/hld-type.nix
#
# Declarative type definition for High-Level Derivations (HLDs).
#
# Each field entry under `fieldSpecs` is an attrset with:
#   description         string  – human-readable description (always present)
#   default             any     – if present, the field is optional with a static
#                                 default; if absent, the field is required
#   dynamicDefault      bool    – if true, the field is optional and its default
#                                 is computed dynamically from packageName in
#                                 validate; do not also set `default`
#   conditionalDefault  bool    – if true, the field is optional but its default
#                                 depends on origin-type (computed in validate);
#                                 do not also set `default`
#
# Identity fields (pname, srcOwner, srcRepo, nixpkgsAttr, mkChangelog,
# mkOverlayInfo, originType) are declared here and exposed on every validated
# HLD so that overlay-bin.nix / overlay-source.nix files never hardcode
# package-specific strings.
#
# originType controls which defaults are applied:
#   "github-releases"  – mkChangelog defaults to hldHelpers."github-release-tag"
#                        srcOwner srcRepo; mkOverlayInfo defaults to the
#                        standard factory from hldHelpers.mkOverlayInfo
#   "torch-website"    – mkChangelog and mkOverlayInfo are mandatory (no default)
#
# originType replaces the old hyphenated "origin-type" attribute name.
#
# pname defaults to packageName (the directory name) when omitted.
# nixpkgsAttr defaults to packageName when omitted.
#
# Usage (pkgs/default.nix validates each loaded HLD automatically):
#
#   { torch, hldHelpers, packageName }:
#
#   assert hldHelpers.isHLD torch;
#
#   {
#     originType  = "github-releases";
#     srcOwner    = "MyOrg";
#     srcRepo     = "my-pkg";
#     # mkChangelog and mkOverlayInfo are auto-derived for "github-releases".
#     highLevelDeps  = { inherit torch; };
#     getVersions    = hldHelpers.getVersionsFromVersionFiles ./binary-hashes;
#     buildBin       = { mkOverlayInfo, pkgs, cudaPackages, cudaLabel,
#                        resolvedDeps, version, wrappers ? null }:
#                      import ./overlay-bin.nix {
#                        overlayInfo = mkOverlayInfo
#                          { inherit pkgs cudaPackages version resolvedDeps; };
#                      };
#     buildSource    = { ... }: throw "not yet implemented";
#   }
#
# HLD files are attrsets; pkgs/default.nix calls hldType.validate name on
# the result of each import.  packageName is injected automatically from the
# directory name; HLD files that need it declare `packageName` in their
# argument list (injected via pkgs/default.nix callFromScope).

let
  # ── hldHelpers import ─────────────────────────────────────────────────────
  # Needed to supply default implementations for mkChangelog / mkOverlayInfo
  # when originType = "github-releases".
  hldHelpers = import ../concretise/hld-helpers.nix;

  # ── Field specification ───────────────────────────────────────────────────
  #
  # Fields without 'default', 'dynamicDefault', or 'conditionalDefault' are
  # required — the HLD file must supply them.
  #
  # Note: packageName is NOT a field here.  It is injected automatically by
  # pkgs/default.nix from the directory name, so HLD files never set it.
  fieldSpecs = {

    # ── Origin / identity ──────────────────────────────────────────────────

    originType = {
      description =
        "string – origin type of the package; allowed values: " + ''"torch-website", "github-releases"'';
    };

    pname = {
      description =
        "string – Python/PyPI package name used as pname in derivations; "
        + "defaults to packageName (directory name) when omitted";
      dynamicDefault = true;
    };

    srcOwner = {
      description = "string – GitHub organisation or user owning the upstream repository";
    };

    srcRepo = {
      description = "string – GitHub repository name";
    };

    nixpkgsAttr = {
      description =
        "string – attribute name in pkgs.python3Packages for the upstream "
        + "nixpkgs derivation (for meta inheritance); defaults to packageName";
      dynamicDefault = true;
    };

    mkChangelog = {
      description =
        "function – version string → changelog URL; "
        + "for originType=\"github-releases\" defaults to "
        + "hldHelpers.\"github-release-tag\" srcOwner srcRepo; "
        + "required for originType=\"torch-website\"";
      conditionalDefault = true;
    };

    mkOverlayInfo = {
      description =
        "function – { pkgs, cudaPackages, version, resolvedDeps } → overlayInfo "
        + "attrset; for originType=\"github-releases\" defaults to the standard "
        + "factory from hldHelpers.mkOverlayInfo; required for "
        + "originType=\"torch-website\"";
      conditionalDefault = true;
    };

    # ── Build mechanics ────────────────────────────────────────────────────

    highLevelDeps = {
      description = "attrset – map of dependency name → HLD (may be {})";
    };

    getVersions = {
      description = "function – cudaLabel -> pyVer -> [ versionString ]";
    };

    buildBin = {
      description =
        "function – { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }"
        + " -> derivation; build from a pre-built wheel";
    };

    buildSource = {
      description =
        "function – same args as buildBin -> derivation; build from source"
        + " (wrappers ? null; throw when not yet implemented)";
    };

    canBuildBin = {
      description =
        "function – { resolvedDeps, version, cudaLabel } -> bool; "
        + "returns false when the pre-built wheel is ABI-incompatible with the "
        + "resolved dependencies.  Defaults to always-true.";
      default = _: true;
    };

    isBinBuildBroken = {
      description =
        "function – overlayInfo -> bool; when true the binary wheel derivation "
        + "is marked meta.broken = true, preventing evaluation.  Defaults to "
        + "_: false (never broken).  Use to mark specific (version, cuda, python) "
        + "combinations broken without disabling the entire package.";
      default = _: false;
    };

    isSourceBuildBroken = {
      description =
        "function – overlayInfo -> bool; when true the source build derivation "
        + "is marked meta.broken = true.  Defaults to _: false (never broken).";
      default = _: false;
    };

    versionConstraints = {
      description =
        "attrset – static version bounds applied to dependencies during version "
        + "selection.  Each key is a dep packageName; each value is "
        + "{ minVersion?, maxVersion? }.  Defaults to {} (no constraints).";
      default = { };
    };

    cudaAgnostic = {
      description =
        "bool – when true the package's wheels are identical across all CUDA "
        + "versions and torch versions (e.g. triton).  The store-path stamp "
        + "omits the cuda, torch, and pascal dimensions; only python version "
        + "and the -bin suffix are added.  Default: false.";
      default = false;
    };

    torchAgnostic = {
      description =
        "bool – when true the package does not link against torch at the "
        + "C++/ABI level (e.g. bitsandbytes).  The store-path stamp omits "
        + "the -torch{series} dimension so the derivation is reused across "
        + "torch version changes.  The package may still depend on torch at "
        + "Python runtime level.  Default: false.";
      default = false;
    };

    data = {
      description = "attrset – arbitrary package-specific metadata";
      default = { };
    };

    generateHashesScript = {
      description =
        "path – path to the generate-hashes.py script for this package; "
        + "when non-null the flake exposes a gen-hashes app at "
        + "apps.<system>.<packageName>.gen-hashes that runs the script "
        + "with the required tools on PATH.  Defaults to "
        + "pkgs/<packageName>/generate-hashes.py if that file exists, "
        + "otherwise null (no app exposed).";
      dynamicDefault = true;
    };

    testScript = {
      description =
        "path – path to manual_debug.py test script for this package; "
        + "when non-null the flake exposes a test app at "
        + "apps.<system>.<packageName>.test and concretise includes "
        + "it in result.testScripts for automatic discovery.  Defaults to "
        + "pkgs/<packageName>/manual_debug.py if that file exists, "
        + "otherwise null.";
      dynamicDefault = true;
    };
  };

  # ── Derived field lists ───────────────────────────────────────────────────

  allFieldNames = builtins.attrNames fieldSpecs;

  # A field is required (must be supplied by the HLD file) when it has none of:
  #   • a static `default`
  #   • dynamicDefault = true  (computed from packageName at validate time)
  #   • conditionalDefault = true  (computed from originType at validate time)
  requiredFieldNames = builtins.filter (
    name:
    let
      spec = fieldSpecs.${name};
    in
    !(builtins.hasAttr "default" spec)
    && !(spec.dynamicDefault or false)
    && !(spec.conditionalDefault or false)
  ) allFieldNames;

  # ── validate ──────────────────────────────────────────────────────────────
  #
  # validate packageName attrs
  #
  # Accepts the package name (from the pkgs/ directory name) and a raw attrset
  # returned directly by a high-level.nix file.  Performs:
  #   1. Checks that all required fields are present.
  #   2. Checks that no fields outside fieldSpecs are present.
  #   3. Validates the value of originType.
  #   4. Fills in defaults for optional fields:
  #        – static defaults (canBuildBin, versionConstraints, data) via
  #          appliedDefaults
  #        – dynamic defaults (pname, nixpkgsAttr) computed from packageName
  #        – conditional defaults (mkChangelog, mkOverlayInfo) computed from
  #          originType; throws when originType = "torch-website" and these
  #          fields are absent
  #   5. Stamps the result with _isHighLevelDerivation = true and
  #      packageName = packageName.
  validate =
    packageName: attrs:
    let
      providedKeys = builtins.attrNames attrs;

      missingFields = builtins.filter (name: !builtins.hasAttr name attrs) requiredFieldNames;

      extraFields = builtins.filter (name: !builtins.elem name allFieldNames) providedKeys;

      _checkMissing =
        missingFields == [ ]
        || throw (
          "HLD '${packageName}': missing required field(s): "
          + builtins.concatStringsSep ", " missingFields
          + ". Required fields: "
          + builtins.concatStringsSep ", " requiredFieldNames
        );

      _checkExtra =
        extraFields == [ ]
        || throw (
          "HLD '${packageName}': unknown field(s): "
          + builtins.concatStringsSep ", " extraFields
          + ". Allowed fields: "
          + builtins.concatStringsSep ", " allFieldNames
        );

      # ── originType validation ──────────────────────────────────────────
      _checkOriginType =
        let
          ot = attrs.originType;
        in
        (ot == "github-releases" || ot == "torch-website")
        || throw (
          "HLD '${packageName}': originType must be "
          + "\"github-releases\" or \"torch-website\", got \"${ot}\""
        );

      # ── Dynamic defaults (depend on packageName) ───────────────────────
      resolvedPname = attrs.pname or packageName;
      resolvedNixpkgsAttr = attrs.nixpkgsAttr or packageName;

      resolvedGenerateHashesScript =
        if builtins.hasAttr "generateHashesScript" attrs then
          attrs.generateHashesScript
        else
          let
            scriptPath = ./. + "/${packageName}/generate-hashes.py";
          in
          if builtins.pathExists scriptPath then scriptPath else null;

      resolvedTestScript =
        if builtins.hasAttr "testScript" attrs then
          attrs.testScript
        else
          let
            scriptPath = ./. + "/${packageName}/manual_debug.py";
          in
          if builtins.pathExists scriptPath then scriptPath else null;

      # ── Conditional defaults (depend on originType) ────────────────────
      resolvedMkChangelog =
        if builtins.hasAttr "mkChangelog" attrs then
          attrs.mkChangelog
        else if attrs.originType == "github-releases" then
          hldHelpers."github-release-tag" attrs.srcOwner attrs.srcRepo
        else
          throw ("HLD '${packageName}': mkChangelog is required when " + "originType = \"torch-website\"");

      resolvedMkOverlayInfo =
        if builtins.hasAttr "mkOverlayInfo" attrs then
          attrs.mkOverlayInfo
        else if attrs.originType == "github-releases" then
          hldHelpers.mkOverlayInfo {
            pname = resolvedPname;
            nixpkgsAttr = resolvedNixpkgsAttr;
            srcOwner = attrs.srcOwner;
            srcRepo = attrs.srcRepo;
            mkChangelog = resolvedMkChangelog;
            # Thread through the HLD-level broken-check functions so that even
            # auto-defaulted mkOverlayInfo carries them into overlayInfo.
            # attrs.X or (_: false) because appliedDefaults haven't been merged
            # yet at this point in validate.
            isBinBuildBroken = attrs.isBinBuildBroken or (_: false);
            isSourceBuildBroken = attrs.isSourceBuildBroken or (_: false);
          }
        else
          throw ("HLD '${packageName}': mkOverlayInfo is required when " + "originType = \"torch-website\"");

      # ── Static defaults ────────────────────────────────────────────────
      # Handles canBuildBin, versionConstraints, data (and any future fields
      # with a plain `default` value in fieldSpecs).
      appliedDefaults = builtins.listToAttrs (
        builtins.concatLists (
          map (
            name:
            let
              spec = fieldSpecs.${name};
            in
            if builtins.hasAttr "default" spec && !builtins.hasAttr name attrs then
              [
                {
                  inherit name;
                  value = spec.default;
                }
              ]
            else
              [ ]
          ) allFieldNames
        )
      );

      # ── Computed fields (dynamic + conditional) ────────────────────────
      # These always override whatever was in attrs (they resolve to the HLD-
      # provided value when present, or to the computed default otherwise).
      computedFields = {
        pname = resolvedPname;
        nixpkgsAttr = resolvedNixpkgsAttr;
        mkChangelog = resolvedMkChangelog;
        mkOverlayInfo = resolvedMkOverlayInfo;
        generateHashesScript = resolvedGenerateHashesScript;
        testScript = resolvedTestScript;
      };
    in
    assert _checkMissing;
    assert _checkExtra;
    assert _checkOriginType;
    attrs
    // appliedDefaults
    // computedFields
    // {
      _isHighLevelDerivation = true;
      inherit packageName;
    };

  # ── check ─────────────────────────────────────────────────────────────────
  #
  # Lightweight predicate: returns true iff x is a validated HLD (i.e. was
  # processed by validate and therefore carries _isHighLevelDerivation = true).
  # Used by dependency assertions in high-level.nix files:
  #   assert hldHelpers.isHLD torch;
  check = x: x._isHighLevelDerivation or false;

in
{
  inherit fieldSpecs validate check;
}
