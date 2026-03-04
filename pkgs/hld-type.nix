# pkgs/hld-type.nix
#
# Declarative type definition for High-Level Derivations (HLDs).
#
# Each field entry under `fieldSpecs` is an attrset with:
#   description  string  – human-readable description of the field (always present)
#   default      any     – if present, the field is optional and this value is used
#                          when the field is absent; if absent, the field is required
#
# Usage (pkgs/default.nix validates each loaded HLD automatically):
#
#   { torch, hldHelpers }:
#
#   assert hldHelpers.isHLD torch;
#
#   {
#     packageName   = "my-pkg";
#     highLevelDeps = { inherit torch; };
#     getVersions   = hldHelpers.getVersionsFromVersionFiles ./binary-hashes;
#     buildBin      = { pkgs, cudaPackages, wrappers, cudaLabel,
#                       resolvedDeps, version }:
#                     import ./override.nix { inherit pkgs; };
#     buildSource   = { ... }:
#                     throw "my-pkg/high-level.nix: buildSource not implemented";
#   }
#
# HLD files are plain attrsets – no constructor call is required.
# pkgs/default.nix calls hldType.validate name on the result of each import.
# packageName is injected automatically from the directory name; HLD files do
# not declare it.

let
  # ── Field specification ───────────────────────────────────────────────────
  #
  # Each entry: { description [, default] }
  # Fields without 'default' are required; fields with 'default' are optional.
  #
  # Note: packageName is NOT a field here.  It is injected automatically by
  # pkgs/default.nix from the directory name, so HLD files never set it.
  fieldSpecs = {
    highLevelDeps = {
      description = "attrset – map of dependency name → HLD (may be {})";
    };
    getVersions = {
      description = "function – cudaLabel -> pyVer -> [ versionString ]";
    };
    buildBin = {
      description =
        "function – { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version }"
        + " -> derivation; build from a pre-built wheel";
    };
    buildSource = {
      description =
        "function – same args as buildBin -> derivation; build from source"
        + " (throw when not yet implemented)";
    };
    data = {
      description = "attrset – arbitrary package-specific metadata";
      default     = {};
    };
  };

  # ── Derived field lists ───────────────────────────────────────────────────

  allFieldNames = builtins.attrNames fieldSpecs;

  requiredFieldNames = builtins.filter
    (name: !(builtins.hasAttr "default" fieldSpecs.${name}))
    allFieldNames;

  # ── validate ──────────────────────────────────────────────────────────────
  #
  # validate packageName attrs
  #
  # Accepts the package name (from the pkgs/ directory name) and a raw attrset
  # returned directly by a high-level.nix file.  Validates attrs against
  # fieldSpecs, fills in defaults for optional fields, and stamps the result
  # with _isHighLevelDerivation = true and packageName = packageName.
  #
  # Throws a descriptive error if any required field is absent or if any field
  # not declared in fieldSpecs is present.
  validate = packageName: attrs:
    let
      providedKeys = builtins.attrNames attrs;

      missingFields = builtins.filter
        (name: !builtins.hasAttr name attrs)
        requiredFieldNames;

      extraFields = builtins.filter
        (name: !builtins.elem name allFieldNames)
        providedKeys;

      _checkMissing =
        missingFields == []
        || throw (
          "HLD type error: missing required field(s): "
          + builtins.concatStringsSep ", " missingFields
          + ". Required fields: "
          + builtins.concatStringsSep ", " requiredFieldNames
        );

      _checkExtra =
        extraFields == []
        || throw (
          "HLD type error: unknown field(s): "
          + builtins.concatStringsSep ", " extraFields
          + ". Allowed fields: "
          + builtins.concatStringsSep ", " allFieldNames
        );

      # Build an attrset of defaults for every optional field not provided.
      appliedDefaults = builtins.listToAttrs (
        builtins.concatLists (map (name:
          let spec = fieldSpecs.${name};
          in
          if builtins.hasAttr "default" spec && !builtins.hasAttr name attrs
          then [ { inherit name; value = spec.default; } ]
          else []
        ) allFieldNames)
      );
    in
    assert _checkMissing;
    assert _checkExtra;
    attrs // appliedDefaults // { _isHighLevelDerivation = true; inherit packageName; };

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
