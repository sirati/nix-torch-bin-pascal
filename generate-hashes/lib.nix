# Shared Nix utilities for binary-wheel override files.
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

}
