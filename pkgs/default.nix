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
  fix = f: let x = f x; in x;

  # ── Discover package directories ──────────────────────────────────────────
  # Only include subdirectories that actually contain a high-level.nix file.
  dirEntries = builtins.readDir ./.;

  pkgDirNames = builtins.filter
    (name:
      dirEntries.${name} == "directory"
      && builtins.pathExists (./. + "/${name}/high-level.nix"))
    (builtins.attrNames dirEntries);

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

  # ── Fixed-point scope ─────────────────────────────────────────────────────
  # Each package directory is loaded exactly once.  The fixed-point ensures
  # that when e.g. flash-attn/high-level.nix declares { torch }:, it receives
  # the real torch HLD from this same scope — evaluated lazily so definition
  # order does not matter.
  scope = fix (self:
    builtins.listToAttrs (map (name: {
      inherit name;
      value = callFromScope self (import (./. + "/${name}/high-level.nix"));
    }) pkgDirNames)
  );

in
scope
