# High-level derivation for PyTorch.
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

{
  # ── Type marker ────────────────────────────────────────────────────────────
  _isHighLevelDerivation = true;

  # ── Identity ───────────────────────────────────────────────────────────────
  packageName    = "torch";
  defaultVersion = "2.10.0";

  # ── Binary availability ────────────────────────────────────────────────────
  # { cudaLabel -> [ versionString ] }
  # Both cu126 and cu128 pre-built wheels are available for these versions.
  binVersions = {
    cu126 = [ "2.9.1" "2.10.0" ];
    cu128 = [ "2.9.1" "2.10.0" ];
  };

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
      base =
        if cudaLabel == "cu126" then
          import ../torch-cu126/override.nix {
            inherit pkgs cudaPackages;
            torchVersion = version;
          }
        else if cudaLabel == "cu128" then
          import ../torch-cu128/override.nix {
            inherit pkgs cudaPackages;
            torchVersion = version;
          }
        else
          throw "torch/high-level.nix: unsupported cudaLabel '${cudaLabel}'. Use 'cu126' or 'cu128'";
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
