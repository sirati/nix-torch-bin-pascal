# Shared Nix utilities for binary-wheel override files and hash generation apps.
#
# Provides platform detection and major.minor version comparison helpers
# that are common to every package-specific override.nix.
#
# Usage
# -----
#   let
#     binLib = import ../generate-hashes/lib.nix { inherit pkgs; };
#   in
#   # use binLib.pyVer, binLib.os, binLib.arch, binLib.versionLE, …
#
# Or with selective binding:
#   inherit (import ../generate-hashes/lib.nix { inherit pkgs; })
#     pyVer os arch versionLE versionLT;

{ pkgs }:

let
  lib = pkgs.lib;

  # Split "x86_64-linux" → ["x86_64" "-" "linux"]  (builtins.split keeps separators)
  systemParts = builtins.split "-" pkgs.stdenv.system;
  rawArch     = builtins.elemAt systemParts 0;   # "x86_64" | "aarch64"
  rawOs       = builtins.elemAt systemParts 2;   # "linux"  | "darwin" | …

  # ── Version comparison internals ─────────────────────────────────────────

  _parseMajorMinor = v:
    let parts = lib.strings.splitString "." v;
    in {
      maj = lib.toInt (lib.elemAt parts 0);
      min = lib.toInt (lib.elemAt parts 1);
    };

in {

  # ── Platform ─────────────────────────────────────────────────────────────

  # Full Python version string from the active interpreter, e.g. "3.12"
  pythonVersion = pkgs.python3.pythonVersion;

  # Nix-style Python version attribute name, e.g. "py312"
  pyVer = "py${builtins.replaceStrings ["."] [""] pkgs.python3.pythonVersion}";

  # CPU architecture as used in binary-hashes.nix, e.g. "x86_64" or "aarch64"
  arch = rawArch;

  # OS name as used in binary-hashes.nix
  os =
    if rawOs == "linux"                         then "linux"
    else if rawOs == "darwin"                   then "darwin"
    else if rawOs == "mingw32" || rawOs == "cygwin" then "windows"
    else throw "Unsupported OS for binary wheel packages: ${rawOs}";

  # ── Version comparison (major.minor strings) ──────────────────────────────
  #
  # These operate on strings like "2.4", "2.10", "3.12".
  # Plain lexicographic comparison is WRONG for these because "2.10" < "2.9"
  # lexicographically but 2.10 > 2.9 numerically.

  # Parse a "major.minor" string into { maj; min } integers.
  parseMajorMinor = _parseMajorMinor;

  # a <= b
  versionLE = a: b:
    let pa = _parseMajorMinor a; pb = _parseMajorMinor b;
    in pa.maj < pb.maj || (pa.maj == pb.maj && pa.min <= pb.min);

  # a < b
  versionLT = a: b:
    let pa = _parseMajorMinor a; pb = _parseMajorMinor b;
    in pa.maj < pb.maj || (pa.maj == pb.maj && pa.min < pb.min);

  # a > b
  versionGT = a: b:
    let pa = _parseMajorMinor a; pb = _parseMajorMinor b;
    in pa.maj > pb.maj || (pa.maj == pb.maj && pa.min > pb.min);

  # a == b  (major.minor only — patch component is ignored)
  versionEQ = a: b:
    let pa = _parseMajorMinor a; pb = _parseMajorMinor b;
    in pa.maj == pb.maj && pa.min == pb.min;

  # ── Hash generation app builder ───────────────────────────────────────────
  #
  # makeGenHashesApp hld
  #
  # Builds a flake app ({ type = "app"; program = ...; }) that runs the
  # package's generate-hashes.py with the required tools (python3, git,
  # nix-prefetch-github) on PATH.
  #
  # The script is executed from $PWD, which must be the project root (the
  # directory containing flake.nix and the pkgs/ tree).  This matches the
  # normal usage of `nix run .#<pkg>.gen-hashes` from the project root.
  #
  # The shared main (generate-hashes/main.py) is the single entry point for
  # all packages.  It loads the per-package generate-hashes.py as a
  # configuration module via --pkg-module and dispatches based on
  # ORIGIN_TYPE ("github-releases" or "torch-website").
  #
  # Usage in flake.nix:
  #   genHashesLib = import ./generate-hashes/lib.nix { inherit pkgs; };
  #   apps.x86_64-linux."flash-attn".gen-hashes =
  #     genHashesLib.makeGenHashesApp pytorchScope."flash-attn";
  makeGenHashesApp = hld:
    let
      name       = hld.packageName;
      originType = hld.originType;
      githubRepo = hld.srcOwner + "/" + hld.srcRepo;
      pkgModulePath = "pkgs/${name}/generate-hashes.py";
      deps = [ pkgs.python3 pkgs.git pkgs.nix-prefetch-github ];
      wrapperScript = pkgs.writeShellScript "gen-hashes-${name}" ''
        export PATH="${lib.makeBinPath deps}:$PATH"
        exec env PYTHONPATH="$PWD/generate-hashes" \
          python3 "$PWD/generate-hashes/main.py" \
            --pkg-module "$PWD/${pkgModulePath}" \
            --origin-type "${originType}" \
            --github-repo "${githubRepo}" \
            "$@"
      '';
    in
    { type = "app"; program = toString wrapperScript; };

}
