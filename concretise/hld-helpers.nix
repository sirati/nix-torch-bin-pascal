# Shared helpers for high-level derivations (HLDs).
#
# In addition to the version-resolution and ABI-check helpers, this file
# provides two identity/overrideInfo helpers used by high-level.nix files:
#
#   github-release-tag
#     Builds the standard GitHub releases changelog URL template.
#     Usage in high-level.nix:
#       mkChangelog = hldHelpers."github-release-tag" srcOwner srcRepo;
#
#   mkOverrideInfo
#     Builds the standard mkOverrideInfo constructor function used by every
#     buildBin / buildSource call.  Closes over the package identity fields
#     so that neither override.nix nor override-source.nix needs to repeat them.
#     Usage in high-level.nix:
#       mkOverrideInfo = hldHelpers.mkOverrideInfo {
#         inherit pname srcOwner srcRepo mkChangelog;
#         nixpkgsAttr = packageName;   # or a custom attr name
#       };
#     Then in buildBin / buildSource:
#       overrideInfo = mkOverrideInfo { inherit pkgs cudaPackages version resolvedDeps; };
#
#
# This file provides reusable getVersions implementations for the two
# binary-hashes directory layouts used across packages, plus a type-check
# helper (isHLD) used both by high-level.nix dependency asserts and by
# pkgs/default.nix when wiring the fixed-point scope.
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
# Usage in a high-level.nix (injected via pkgs/default.nix scope):
#
#   { hldHelpers, mkHLD, torch }:
#   mkHLD {
#     getVersions = hldHelpers.getVersionsFromCudaFiles    ./binary-hashes;
#     # or
#     getVersions = hldHelpers.getVersionsFromVersionFiles ./binary-hashes;
#     ...
#   }
#
# Both produce a curried function:  cudaLabel -> pyVer -> [ versionString ]

{
  # --------------------------------------------------------------------------
  # github-release-tag
  #
  # Returns the standard GitHub releases changelog URL for a given package
  # version.  Takes owner and repo as curried arguments; returns a function
  # v -> url so it can be used directly as the mkChangelog field value:
  #
  #   mkChangelog = hldHelpers."github-release-tag" srcOwner srcRepo;
  #
  # The resulting function prepends "v" to the version string, matching the
  # conventional GitHub release tag format (e.g. "v1.6.0").
  # --------------------------------------------------------------------------
  "github-release-tag" = owner: repo: v:
    "https://github.com/${owner}/${repo}/releases/tag/v${v}";

  # --------------------------------------------------------------------------
  # mkOverrideInfo
  #
  # Factory that produces the mkOverrideInfo constructor function consumed by
  # each package's override.nix and override-source.nix.  Takes the package
  # identity fields as a named-argument attrset and returns a curried function:
  #
  #   mkOverrideInfo identityAttrs buildArgs -> overrideInfo attrset
  #
  # Identity fields (all required unless marked optional):
  #   pname               – Python/PyPI package name
  #   nixpkgsAttr         – attribute in pkgs.python3Packages (may equal pname)
  #   srcOwner            – GitHub organisation or user
  #   srcRepo             – GitHub repository name
  #   mkChangelog         – version string → changelog URL function
  #
  # Optional identity fields (default to always-false functions):
  #   isBinBuildBroken    – overrideInfo -> bool; when true the binary wheel
  #                         derivation is marked meta.broken = true.  Default:
  #                         _: false (never broken).
  #   isSourceBuildBroken – overrideInfo -> bool; same for source builds.
  #                         Default: _: false (never broken).
  #
  # Build args (all required, passed at build time from buildBin/buildSource):
  #   pkgs          – nixpkgs package set
  #   cudaPackages  – CUDA package set
  #   version       – resolved version string
  #   resolvedDeps  – attrset of resolved HLD dependency derivations
  #
  # The resulting overrideInfo attrset contains:
  #   pkgs, cudaPackages, pname, srcOwner, srcRepo, version,
  #   basePkg             (pkgs.python3Packages.${nixpkgsAttr} or null),
  #   changelog           (mkChangelog version),
  #   torch               (resolvedDeps.torch or null),
  #   isBinBuildBroken    (propagated from identity; called with overrideInfo),
  #   isSourceBuildBroken (propagated from identity; called with overrideInfo)
  # --------------------------------------------------------------------------
  mkOverrideInfo =
    { pname, nixpkgsAttr, srcOwner, srcRepo, mkChangelog
    , isBinBuildBroken    ? _: false
    , isSourceBuildBroken ? _: false
    }:
    { pkgs, cudaPackages, version, resolvedDeps }:
    {
      inherit pkgs cudaPackages pname srcOwner srcRepo version;
      inherit isBinBuildBroken isSourceBuildBroken;
      basePkg   = pkgs.python3Packages.${nixpkgsAttr} or null;
      changelog = mkChangelog version;
      torch     = resolvedDeps.torch or null;
    };

  # --------------------------------------------------------------------------
  # isHLD
  #
  # Returns true iff value x is a validated high-level derivation (i.e. was
  # constructed via mkHLD and therefore carries _isHighLevelDerivation = true).
  # --------------------------------------------------------------------------
  isHLD = x: x._isHighLevelDerivation or false;

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
  # getVersionsFromSourceFiles
  #
  # sourceHashesDir : path to the source-hashes/ directory
  # _cudaLabel      : ignored (source builds are independent of CUDA label)
  # _pyVer          : ignored (source builds are independent of Python version)
  #
  # Scans sourceHashesDir for files matching v{semver}.nix and returns the list
  # of version strings.  Unlike the binary-hashes helpers, this does not filter
  # by cuda or Python version — a source build is valid for every combination
  # once the source hash file exists.
  #
  # Signature takes cudaLabel and pyVer parameters for consistency with the
  # other getVersions helpers (allowing drop-in substitution), but both are
  # ignored (prefixed with _ to signal they are unused).
  # --------------------------------------------------------------------------
  getVersionsFromSourceFiles = sourceHashesDir: _cudaLabel: _pyVer:
    let
      files  = builtins.readDir sourceHashesDir;
      vNames = builtins.filter
        (n: builtins.match "v[0-9]+\\.[0-9]+\\.[0-9]+\\.nix" n != null)
        (builtins.attrNames files);
    in
    map (n: builtins.substring 1 (builtins.stringLength n - 5) n) vNames;

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

  # --------------------------------------------------------------------------
  # canBuildBinFromVersionFiles
  #
  # Shared canBuildBin implementation for packages whose binary-hashes/
  # directory uses per-version files (v{version}.nix), where each file is
  # keyed by cudaVersion label and then by torch-compat string.
  #
  # binaryHashesDir : path to the binary-hashes/ directory
  # args            : { resolvedDeps, version, cudaLabel, ... }
  #
  # Returns true iff the resolved torch major.minor does not exceed the
  # highest torch-compat key available for the given cuda label (with "cu12"
  # as a generic fallback).  Returns false when no cuda section is found,
  # which causes concretise to fall back to a source build.
  # --------------------------------------------------------------------------
  canBuildBinFromVersionFiles = binaryHashesDir: { resolvedDeps, version, cudaLabel, ... }:
    let
      torchVersion    = resolvedDeps."torch".version;
      mm              = builtins.match "([0-9]+[.][0-9]+).*" torchVersion;
      torchMajorMinor = builtins.elemAt mm 0;

      versionFile = import (binaryHashesDir + "/v${version}.nix");
      cudaSection =
        if      builtins.hasAttr cudaLabel versionFile then versionFile.${cudaLabel}
        else if builtins.hasAttr "cu12"    versionFile then versionFile."cu12"
        else {};

      availableCompat = builtins.attrNames cudaSection;

      sortedCompat = builtins.sort
        (a: b: builtins.compareVersions a b < 0)
        availableCompat;

      maxCompat = if sortedCompat == []
        then "0.0"
        else builtins.elemAt sortedCompat (builtins.length sortedCompat - 1);
    in
    builtins.compareVersions torchMajorMinor maxCompat <= 0;

  # --------------------------------------------------------------------------
  # requireSourceHash
  #
  # Shared buildSource pre-flight check used by every high-level.nix
  # buildSource implementation.  Validates that:
  #   1. version is non-null (i.e. at least one binary-hashes entry exists
  #      for the requested cuda label so we know which version to build).
  #   2. The corresponding source-hashes/v{version}.nix file exists on disk.
  #
  # On success returns the validated version string so it can be bound with
  # `let v = hldHelpers.requireSourceHash ... args;`.
  # On failure throws a human-readable error pointing to the fix.
  #
  # pkgName        : human-readable package name, e.g. "causal-conv1d"
  # pkgRelPath     : repo-relative path string for error messages,
  #                  e.g. "pkgs/causal-conv1d"
  # sourceHashesDir: Nix path to the source-hashes/ directory, e.g. ./source-hashes
  # args           : { version, cudaLabel, ... }
  # --------------------------------------------------------------------------
  requireSourceHash = pkgName: pkgRelPath: sourceHashesDir: { version, cudaLabel, ... }:
    let
      v = if version != null then version else throw (
        "${pkgName} buildSource: version is null — no binary-hashes entry "
        + "exists for cudaLabel '${cudaLabel}'.  Add a binary-hashes entry "
        + "for the desired version, or run generate-hashes.py to fetch it."
      );
      sourceHashPath = sourceHashesDir + "/v${v}.nix";
    in
    if !builtins.pathExists sourceHashPath
    then throw (
      "${pkgName} buildSource: source-hashes/v${v}.nix does not exist. "
      + "Run: nix-shell ${pkgRelPath}/generate-hashes.py -- "
      + "--source-only --tag v${v}"
    )
    else v;
}
