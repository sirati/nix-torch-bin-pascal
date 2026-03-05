# pkgs/default.nix
#
# Auto-discovers all package subdirectories and builds a lazily-resolved scope
# using a fixed-point so each high-level.nix can reference sibling packages by
# name without manual wiring.  Uses builtins.functionArgs for callPackage-style
# argument injection (exactly the pattern described in lib.makeScope / lib.fix).
#
# Discovery rule: any direct subdirectory of pkgs/ that contains a
# high-level.nix file is considered a package.  The attribute name in the
# returned scope is the directory name (which must equal the package's
# packageName field).
#
# In addition to peer HLDs, every high-level.nix automatically receives one
# utility argument if it declares it:
#
#   hldHelpers  – getVersionsFromCudaFiles, getVersionsFromVersionFiles, isHLD
#
# This means each high-level.nix only needs to declare what it uses:
#
#   { hldHelpers }:           # torch (no peer deps)
#   { torch, hldHelpers }:    # flash-attn / causal-conv1d
#
# HLD files return plain attrsets.  pkgs/default.nix passes every loaded
# attrset through hldType.validate, which:
#   - checks that all required fields are present
#   - checks that no unknown fields are present
#   - fills in defaults for optional fields (data = {})
#   - stamps the result with _isHighLevelDerivation = true
#
# Usage from flake.nix:
#   let pytorchScope = import ./pkgs; in
#   pytorchScope.torch          # torch HLD
#   pytorchScope."flash-attn"   # flash-attn HLD
#
# The scope can be spread into pytorch-packages alongside concretise:
#   pytorch-packages = pytorchScope // { concretise = import ./concretise; };

let
  # ── Fixed-point combinator ────────────────────────────────────────────────
  # Passes the result of f back into f as its argument.  Nix's laziness makes
  # this safe as long as there are no value-level cycles (only name-level
  # forward references).
  #
  # We define our own instead of using nixpkgs lib.fix because this file is a
  # pure Nix expression that does not import nixpkgs — it is evaluated before
  # any `pkgs` argument is available.  lib.fix is identical in semantics;
  # there is no builtins.fix in the Nix evaluator itself.
  fix = f: let x = f x; in x;

  # ── HLD type definition ───────────────────────────────────────────────────
  # Provides validate (stamps + checks each loaded HLD) and check (predicate).
  hldType = import ./hld-type.nix;

  # ── Discover package directories ──────────────────────────────────────────
  # Only include subdirectories that actually contain a high-level.nix file.
  dirEntries = builtins.readDir ./.;

  pkgDirNames = builtins.filter
    (name:
      dirEntries.${name} == "directory"
      && builtins.pathExists (./. + "/${name}/high-level.nix"))
    (builtins.attrNames dirEntries);

  # ── Utility attributes ─────────────────────────────────────────────────────
  # Injected into every high-level.nix that declares them as arguments.
  # NOT exported by this file (only actual package HLDs are exported).
  utilities = {
    # Shared getVersions helpers + isHLD type-check
    hldHelpers = import ../concretise/hld-helpers.nix;
  };

  # ── callFromScope ─────────────────────────────────────────────────────────
  # Given the lazily-resolved final scope and an HLD function, introspects the
  # function's declared argument names and injects matching attributes from the
  # scope.  Arguments not present in the scope are silently omitted — the HLD
  # itself will throw if a required argument is missing.
  callFromScope = scope: fn:
    let
      declaredArgs = builtins.functionArgs fn;
      providedArgs = builtins.intersectAttrs declaredArgs scope;
    in
    fn providedArgs;

  # ── Internal fixed-point scope ────────────────────────────────────────────
  # Combines utility attributes with lazily-resolved HLD entries so that when
  # e.g. flash-attn/high-level.nix declares { torch, hldHelpers }:, both are
  # found in the scope and injected automatically.
  #
  # Each loaded HLD attrset is passed through hldType.validate so that:
  #   - required fields are enforced at load time with a clear error
  #   - optional fields receive their defaults (data = {})
  #   - _isHighLevelDerivation = true is stamped on every HLD
  #
  # Definition order does not matter: the fixed-point ensures each HLD sees
  # the fully-evaluated scope through `self`.
  internalScope = fix (self:
    utilities //
    builtins.listToAttrs (map (name: {
      inherit name;
      value = hldType.validate name
        (callFromScope (self // { packageName = name; })
          (import (./. + "/${name}/high-level.nix")));
    }) pkgDirNames)
  );

in
# Only expose the actual package HLDs in the returned attrset (not utilities).
# Consumers (flake.nix, concretise) only need the HLD values.
builtins.listToAttrs (map (name: {
  inherit name;
  value = internalScope.${name};
}) pkgDirNames)
