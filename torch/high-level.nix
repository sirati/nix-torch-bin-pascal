# High-level derivation for PyTorch.
#
# getVersions is provided by the shared helper in concretise/hld-helpers.nix.
# torch uses the per-CUDA-label layout: binary-hashes/{cudaLabel}.nix
#
# This is NOT a buildable derivation.  Import it and pass it (along with other
# high-level derivations) to concretise.nix, which resolves the concrete build.
#
# Usage:
#   let pp = inputs.this-flake.pytorch-packages; in
#   pp.concretise {
#     inherit pkgs;
#     packages = with pp; [ torch ];
#     python   = "3.13";
#     cuda     = "12.6";
#   };

{ }:

let
  hldHelpers = import ../concretise/hld-helpers.nix;
in

{
  # ── Type marker ────────────────────────────────────────────────────────────
  _isHighLevelDerivation = true;

  # ── Identity ───────────────────────────────────────────────────────────────
  packageName = "torch";

  # ── Binary availability ────────────────────────────────────────────────────
  # torch uses per-CUDA-label files: binary-hashes/{cudaLabel}.nix
  # Each file is a plain attrset keyed by version string.
  getVersions = hldHelpers.getVersionsFromCudaFiles ./binary-hashes;

  # ── High-level dependencies ────────────────────────────────────────────────
  # Torch has no high-level deps; other packages depend on it.
  highLevelDeps = {};

  # ── Build from pre-built wheel ─────────────────────────────────────────────
  #
  # Received from concretise:
  #   { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version }
  #
  # torch does not use resolvedDeps (it has no deps).
  buildBin = { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version }:
    let
      binaryHashes = import (./binary-hashes + "/${cudaLabel}.nix");
      base = import ./override-common.nix {
        inherit pkgs cudaPackages binaryHashes;
        torchVersion = version;
      };
    in
    # Inject retry wrappers so transient CUDA toolchain failures are retried
    # automatically.  Safe for wheel-only installs (wrappers go into PATH but
    # are never invoked if there is no compilation step).
    base.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ wrappers ];
      preConfigure = ''
        export PATH="${wrappers}/bin:$PATH"
        ${old.preConfigure or ""}
      '';
      preBuild = ''
        export PATH="${wrappers}/bin:$PATH"
        ${old.preBuild or ""}
      '';
    });

  # ── Build from source ──────────────────────────────────────────────────────
  buildSource = { pkgs, cudaPackages, wrappers, cudaLabel, resolvedDeps, version }:
    throw "torch/high-level.nix: buildSource is not yet implemented";
}
