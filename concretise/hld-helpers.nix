# Shared helpers for high-level derivations (HLDs).
#
# This file provides reusable getVersions implementations for the two
# binary-hashes directory layouts used across packages:
#
#   getVersionsFromCudaFiles
#     For packages like torch whose binary-hashes/ contains one file per
#     CUDA label:  binary-hashes/{cudaLabel}.nix
#     The file is a plain attrset keyed by version string.
#
#   getVersionsFromVersionFiles
#     For packages like flash-attn and causal-conv1d whose binary-hashes/
#     contains one file per package version:  binary-hashes/v{version}.nix
#     Each file is a plain attrset keyed by cudaVersion label.
#     A "cu12" key is treated as a generic fallback covering all cu12x labels.
#
# Both helpers now require a pyVer argument (e.g. "py313") in addition to the
# cudaLabel.  A version is only returned if a pre-built wheel actually exists
# for the requested (cuda, python) combination — not merely for the cuda label
# alone.  This allows concretise to fail early with a clear diagnostic instead
# of surfacing a cryptic evaluation error deep inside an override.nix file.
#
# Usage in a high-level.nix:
#
#   let hldHelpers = import ../concretise/hld-helpers.nix; in
#   {
#     getVersions = hldHelpers.getVersionsFromCudaFiles    ./binary-hashes;
#     # or
#     getVersions = hldHelpers.getVersionsFromVersionFiles ./binary-hashes;
#   }
#
# Both produce a curried function:  cudaLabel -> pyVer -> [ versionString ]

{
  # --------------------------------------------------------------------------
  # getVersionsFromCudaFiles
  #
  # binaryHashesDir : path to the binary-hashes/ directory
  # cudaLabel       : e.g. "cu126" or "cu128"
  # pyVer           : e.g. "py313"
  #
  # Returns the list of version strings present in
  #   binaryHashesDir/{cudaLabel}.nix
  # that also have a wheel entry for pyVer, or [] if no such file exists.
  #
  # File structure assumed:  version -> pyVer -> os -> arch -> wheelData
  # The file may carry a self-identifying _cudaLabel attribute at the top
  # level; that key is filtered out before version enumeration.
  # --------------------------------------------------------------------------
  getVersionsFromCudaFiles = binaryHashesDir: cudaLabel: pyVer:
    let
      f = binaryHashesDir + "/${cudaLabel}.nix";
    in
    if builtins.pathExists f
    then
      let
        attrset     = import f;
        allVersions = builtins.filter (k: k != "_cudaLabel") (builtins.attrNames attrset);
      in
      # Only include a version if the hash file contains a wheel entry for the
      # requested Python version.  This ensures getVersions returns [] (and
      # concretise fails early) rather than silently selecting a version whose
      # wheel does not exist for the requested Python.
      builtins.filter (v: builtins.hasAttr pyVer attrset.${v}) allVersions
    else [];

  # --------------------------------------------------------------------------
  # getVersionsFromVersionFiles
  #
  # binaryHashesDir : path to the binary-hashes/ directory
  # cudaLabel       : e.g. "cu126", "cu128", or "cu12"
  # pyVer           : e.g. "py313"
  #
  # Scans binaryHashesDir for files matching v{semver}.nix, then returns
  # only those versions whose file:
  #   1. contains a key for cudaLabel or the generic "cu12" fallback, AND
  #   2. has at least one torch-compat entry within that cuda section that
  #      carries a wheel for pyVer.
  #
  # File structure assumed:  cudaKey -> torchCompat -> pyVer -> os -> arch
  # The file may carry a self-identifying _version attribute at the top level;
  # that key never equals a cudaLabel so it does not affect the cuda filter.
  # The cuda section's keys are torch-compat strings (e.g. "2.4", "2.9") which
  # never start with "_", so no extra filtering is needed there.
  # --------------------------------------------------------------------------
  getVersionsFromVersionFiles = binaryHashesDir: cudaLabel: pyVer:
    let
      files = builtins.readDir binaryHashesDir;

      # Collect filenames that look like versioned hash files
      vNames = builtins.filter
        (n: builtins.match "v[0-9]+\\.[0-9]+\\.[0-9]+\\.nix" n != null)
        (builtins.attrNames files);

      # Strip leading "v" and trailing ".nix" to get the bare version string
      versions = map
        (n: builtins.substring 1 (builtins.stringLength n - 5) n)
        vNames;
    in
    builtins.filter (v:
      let
        h = import (binaryHashesDir + "/v${v}.nix");

        # Resolve the cuda section: prefer the exact label, fall back to "cu12".
        cudaSection =
          if      builtins.hasAttr cudaLabel h then h.${cudaLabel}
          else if builtins.hasAttr "cu12"    h then h."cu12"
          else                                     null;
      in
      # Both conditions must hold:
      #   • a cuda section exists for this label
      #   • at least one torch-compat entry within it has a wheel for pyVer
      cudaSection != null &&
      builtins.any
        (compat: builtins.hasAttr pyVer cudaSection.${compat})
        (builtins.attrNames cudaSection)
    ) versions;
}
