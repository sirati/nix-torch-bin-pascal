# TODO TODO TODO
#
# this was a nice test, but mamba-ssm does autotune for the specific way it
# is used, so this is not suitable for general use.
# probably still nice to add a builder method that can be added to dev flakes
# so that for the local project the autotune is done automatically.
#
# TODO TODO TODO
# ##########################################################################
# ##########################################################################
# ##########################################################################
#
# High-level derivation for mamba-ssm-impure-local-autotune.
#
# When included in a concretise mlPackages list alongside (or instead of
# listing) mamba-ssm, this package:
#
#   1. Pulls in mamba-ssm transitively via highLevelDeps.
#
#   2. Installs a Python module `mamba_ssm_autotune` into the environment.
#
#   3. Installs a .pth hook (`nix-mamba-autotune.pth`) so Python automatically
#      imports `mamba_ssm_autotune` on every startup in this env.  The
#      __init__.py sets TRITON_CACHE_DIR (via os.environ.setdefault) to a
#      stable, per-env user-local path under ~/.cache/nix-mamba-autotune/
#      before triton initialises — so pre-warmed configurations are always
#      picked up without any shell-level setup.
#
#   4. Provides a warmup entry-point (the "impure" step):
#
#        python -m mamba_ssm_autotune [--seq-lens ...] [--d-model ...]
#
#      Run this once on a machine with a local NVIDIA GPU.  It runs Mamba2
#      forward passes for the requested shapes, which triggers triton
#      autotuning and writes the results to the per-env cache directory.
#      Subsequent sessions use the cached configurations and skip autotuning.
#
# Why "impure"?
#   The warmup step requires GPU access and produces GPU-timing-dependent
#   results, so it cannot run inside the deterministic Nix build sandbox.
#   The cache is stored in the user's home directory (~/.cache/…), not in the
#   Nix store.
#
# Why "local"?
#   The cache is local to the machine that ran the warmup.  The per-env key
#   (derived from the Nix store path of this package) means the cache is
#   silently invalidated whenever the environment changes (new mamba-ssm,
#   triton, CUDA, or Python version), so stale configurations can never be
#   used.

{ mamba-ssm, hldHelpers, packageName }:

assert hldHelpers.isHLD mamba-ssm;

{
  # ── Origin / identity ───────────────────────────────────────────────────

  # This package tracks mamba-ssm from the state-spaces/mamba repo.
  originType = "github-releases";
  srcOwner      = "state-spaces";
  srcRepo       = "mamba";

  # pname and nixpkgsAttr default to packageName ("mamba-ssm-impure-local-autotune").
  # basePkg will be null (no upstream nixpkgs counterpart); that is intentional.

  # ── Dependencies ────────────────────────────────────────────────────────

  # mamba-ssm (and its transitive deps torch + causal-conv1d) are brought in
  # automatically by concretise when this package is included.
  highLevelDeps = { inherit mamba-ssm; };

  # ── Version selection ────────────────────────────────────────────────────

  # This is a generated utility package — it has no upstream release stream.
  # A single fixed version "0.1" is returned regardless of cuda/python so
  # concretise always resolves it.
  getVersions = _cudaLabel: _pyVer: [ "0.1" ];

  # The "binary" is always available (generated inline in buildBin).
  canBuildBin = _: true;

  # ── Build ────────────────────────────────────────────────────────────────

  # Produces a Python package that installs:
  #   • mamba_ssm_autotune/__init__.py  – sets TRITON_CACHE_DIR on import
  #   • mamba_ssm_autotune/__main__.py  – warmup/autotune script
  #   • nix-mamba-autotune.pth          – auto-imports the module at startup
  #
  # No propagatedBuildInputs for mamba-ssm / triton / torch: concretise
  # already places them in the combined env via highLevelDeps; duplicating
  # them here would cause a conflict in withPackages.
  buildBin = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    pkgs.python3Packages.buildPythonPackage {
      pname  = packageName;
      inherit version;
      format = "other";

      # Use the package directory as src so __init__.py and __main__.py are
      # accessible as $src/__init__.py and $src/__main__.py in installPhase.
      src = builtins.path {
        path = ./.;
        name = "${packageName}-src";
      };

      dontUnpack = true;

      # Disable the default import check: the module sets an env-var side-
      # effect on import and requires triton/mamba_ssm to be present, neither
      # of which is available during the Nix build phase.
      pythonImportsCheck = [];
      doInstallCheck = false;

      installPhase = ''
        runHook preInstall

        sitePackages="$out/lib/python${pkgs.python3.pythonVersion}/site-packages"
        mkdir -p "$sitePackages/mamba_ssm_autotune"

        cp "$src/__init__.py" "$sitePackages/mamba_ssm_autotune/__init__.py"
        cp "$src/__main__.py" "$sitePackages/mamba_ssm_autotune/__main__.py"

        # .pth hook: processed by Python's site.py at startup via the merged
        # site-packages of the Nix buildEnv.  Causes mamba_ssm_autotune to be
        # imported automatically, which sets TRITON_CACHE_DIR before triton
        # initialises on the first kernel dispatch.
        echo "import mamba_ssm_autotune" \
          > "$sitePackages/nix-mamba-autotune.pth"

        runHook postInstall
      '';
    };

  buildSource = _:
    throw "${packageName}: buildSource is not applicable; this package is generated inline by buildBin";
}
