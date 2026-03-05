# example/default.nix – Callable implementation of the example environment.
#
# Imported by example/flake.nix (the downstream flake template) and by
# test.nix (the test suite) alike.  Returns { env, devShell }.
#
# Arguments:
#   pkgs          – nixpkgs instance (must have config.allowUnfree = true)
#   torchPackages – pytorch-packages scope + concretise function
#
# ── Concretise argument reference ────────────────────────────────────────────
#
#   mlPackages            – list of HLD values you want installed
#   python                – Python minor version string ("3.11"/"3.12"/"3.13")
#   cuda                  – CUDA major.minor string ("12.6" or "12.8")
#   torch                 – torch major.minor string ("2.8"/"2.9"/"2.10")
#   pascal                – enable Pascal (sm_60/sm_61) GPU support (default: false)
#                           WARNING: Pascal support is not validated per library –
#                           setting pascal = true may cause build failures or silently
#                           broken binaries for packages whose upstream wheels were not
#                           compiled for sm_60.  Only set this if you know all requested
#                           libraries support it.
#   allowBuildingFromSource – true: fall back to source when no wheel exists.
#                           false: fail at eval time if any package lacks a wheel.
#   extraPythonPackages   – withPackages-style fn for extra nixpkgs Python packages
#                           bundled into result.env; HLD packages always win on conflict.
#
# ── extendEnv ─────────────────────────────────────────────────────────────────
#
#   result.extendEnv (ps: with ps; [ … ]) returns a new env containing all HLD
#   packages + extraPythonPackages + the additional packages you pass.  Nothing
#   needs to be re-listed.  Use it when you want one base env and several
#   augmented variants without re-running concretise.

{ pkgs, torchPackages }:

let
  # ── Step 1: concretise the ML stack ────────────────────────────────────────
  #
  # pandas and numpy are bundled directly via extraPythonPackages so that
  # result.env already contains them without an extra extendEnv call.
  result = torchPackages.concretise {
    inherit pkgs;

    mlPackages = with torchPackages; [
      torch
      flash-attn
      causal-conv1d
    ];

    python                  = "3.13";
    cuda                    = "12.8";
    torch                   = "2.10";
    pascal                  = false;
    allowBuildingFromSource = true;

    extraPythonPackages = ps: with ps; [
      pandas
      numpy
    ];
  };

  # ── Step 2: extend with more packages after the fact ───────────────────────
  #
  # matplotlib, scikit-learn, and tqdm are added on top via extendEnv.
  # The HLD packages (torch, flash-attn, causal-conv1d) and the
  # extraPythonPackages (pandas, numpy) are already included automatically –
  # no re-listing required.
  env = result.extendEnv (ps: with ps; [
    matplotlib
    scikit-learn
    tqdm
  ]);

in
{
  inherit env;

  devShell = pkgs.mkShell {
    packages = [ env ];
  };
}
