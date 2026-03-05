# Test environments for the concretise pipeline.
# Imported by flake.nix; not a standalone file.
#
# Arguments:
#   pkgs         – nixpkgs instantiation for the current system
#   pytorchScope – the HLD scope from pkgs/default.nix (pytorch-packages)
{ pkgs, pytorchScope }:

let
  concretise        = import ./concretise;
  testScriptContent = builtins.readFile ./test-torch.py;

  # ── Example: validates the pattern shown in example/flake.nix ────────────
  exampleResult = import ./example {
    inherit pkgs;
    torchPackages = pytorchScope // { concretise = concretise; };
  };

  makeTestApp = envPkg: name: {
    type    = "app";
    program = toString (pkgs.writeShellScript "run-tests-${name}" ''
      exec ${envPkg}/bin/python3 ${pkgs.writeText "test-torch.py" testScriptContent}
    '');
  };

  # ── Default concrete environment ─────────────────────────────────────────
  # cu126-pascal, Python 3.13, all three packages.
  # causal-conv1d 1.6.0 has no binary wheel for torch >= 2.9, so source
  # build is required when using torch 2.10.
  defaultResult = concretise {
    inherit pkgs;
    mlPackages = [
      pytorchScope.torch
      pytorchScope."flash-attn"
      pytorchScope."causal-conv1d"
    ];
    python                  = "3.13";
    cuda                    = "12.6";
    torch                   = "2.10";
    pascal                  = true;
    allowBuildingFromSource = true;
  };

  # ── Test: torch-only, Python 3.13, CUDA 12.8 ─────────────────────────────
  testTorchCu128Result = concretise {
    inherit pkgs;
    mlPackages              = [ pytorchScope.torch ];
    python                  = "3.13";
    cuda                    = "12.8";
    torch                   = "2.10";
    allowBuildingFromSource = false;
  };

  # ── Test: torch + causal-conv1d binary wheel, Python 3.13, CUDA 12.8 ─────
  # Uses torch 2.8 which is the highest torch series for which a
  # causal-conv1d 1.6.0 pre-built wheel exists (maxCompat = "2.8").
  testCausalCu128Result = concretise {
    inherit pkgs;
    mlPackages = [
      pytorchScope.torch
      pytorchScope."causal-conv1d"
    ];
    python                  = "3.13";
    cuda                    = "12.8";
    torch                   = "2.8";
    allowBuildingFromSource = false;
  };

  # ── Test: torch + causal-conv1d from source, Python 3.13, CUDA 12.8 ──────
  # torch 2.10 has no causal-conv1d 1.6.0 binary wheel, so source build
  # is required.
  testCausalCu128FromSourceResult = concretise {
    inherit pkgs;
    mlPackages = [
      pytorchScope.torch
      pytorchScope."causal-conv1d"
    ];
    python                  = "3.13";
    cuda                    = "12.8";
    torch                   = "2.10";
    allowBuildingFromSource = true;
  };

  # ── Test: torch + flash-attn binary wheels, Python 3.13, CUDA 12.8 ───────
  # flash-attn 2.8.3 has py313 wheels for torch 2.8 on cu12.
  testFlashAttnBinCu128Result = concretise {
    inherit pkgs;
    mlPackages = [
      pytorchScope.torch
      pytorchScope."flash-attn"
    ];
    python                  = "3.13";
    cuda                    = "12.8";
    torch                   = "2.8";
    allowBuildingFromSource = false;
  };

  # ── Test: flash-attn from source, Python 3.13, CUDA 12.8 ─────────────────
  # flash-attn 2.8.3 has no py313 wheel for torch >= 2.10, so a source
  # build is required.  causal-conv1d is intentionally excluded.
  testFlashAttnSourceCu128Result = concretise {
    inherit pkgs;
    mlPackages = [
      pytorchScope.torch
      pytorchScope."flash-attn"
    ];
    python                  = "3.13";
    cuda                    = "12.8";
    torch                   = "2.10";
    allowBuildingFromSource = true;
  };

  # ── Test: all three packages, Python 3.13, CUDA 12.8 ─────────────────────
  # causal-conv1d requires a source build with torch 2.10.
  testAllCu128Result = concretise {
    inherit pkgs;
    mlPackages = [
      pytorchScope.torch
      pytorchScope."flash-attn"
      pytorchScope."causal-conv1d"
    ];
    python                  = "3.13";
    cuda                    = "12.8";
    torch                   = "2.10";
    allowBuildingFromSource = true;
  };

  # ── Test: mamba-ssm binary wheel, Python 3.13, CUDA 12.8 ─────────────────
  # mamba-ssm 2.3.0 has py313 wheels for torch 2.7 on cu12.
  testMambaCu128Result = concretise {
    inherit pkgs;
    mlPackages = [
      pytorchScope.torch
      pytorchScope."causal-conv1d"
      pytorchScope."mamba-ssm"
    ];
    python                  = "3.13";
    cuda                    = "12.8";
    torch                   = "2.7";
    allowBuildingFromSource = false;
  };

  # ── Test: mamba-ssm from source, Python 3.13, CUDA 12.8 ──────────────────
  # mamba-ssm 2.3.0 has no py313 wheel for torch >= 2.8, so a source build
  # is required.
  testMambaSourceCu128Result = concretise {
    inherit pkgs;
    mlPackages = [
      pytorchScope.torch
      pytorchScope."causal-conv1d"
      pytorchScope."mamba-ssm"
    ];
    python                  = "3.13";
    cuda                    = "12.8";
    torch                   = "2.10";
    allowBuildingFromSource = true;
  };

in
{
  packages = {
    default                                    = defaultResult.env;
    test-example                               = exampleResult.env;
    test-torch-py313-cu128                     = testTorchCu128Result.env;
    test-causal-conv1d-py313-cu128             = testCausalCu128Result.env;
    test-causal-conv1d-from-source-py313-cu128 = testCausalCu128FromSourceResult.env;
    test-flash-attn-bin-py313-cu128            = testFlashAttnBinCu128Result.env;
    test-flash-attn-source-py313-cu128         = testFlashAttnSourceCu128Result.env;
    test-all-py313-cu128                       = testAllCu128Result.env;
    test-mamba-py313-cu128                     = testMambaCu128Result.env;
    test-mamba-source-py313-cu128              = testMambaSourceCu128Result.env;
  };

  devShells = {
    default                                    = defaultResult.devShell;
    test-example                               = exampleResult.devShell;
    test-torch-py313-cu128                     = testTorchCu128Result.devShell;
    test-causal-conv1d-py313-cu128             = testCausalCu128Result.devShell;
    test-causal-conv1d-from-source-py313-cu128 = testCausalCu128FromSourceResult.devShell;
    test-flash-attn-bin-py313-cu128            = testFlashAttnBinCu128Result.devShell;
    test-flash-attn-source-py313-cu128         = testFlashAttnSourceCu128Result.devShell;
    test-all-py313-cu128                       = testAllCu128Result.devShell;
    test-mamba-py313-cu128                     = testMambaCu128Result.devShell;
    test-mamba-source-py313-cu128              = testMambaSourceCu128Result.devShell;
  };

  apps = {
    default                                    = makeTestApp defaultResult.env                    "default";
    test-example                               = makeTestApp exampleResult.env                    "test-example";
    test-torch-py313-cu128                     = makeTestApp testTorchCu128Result.env             "test-torch-py313-cu128";
    test-causal-conv1d-py313-cu128             = makeTestApp testCausalCu128Result.env            "test-causal-conv1d-py313-cu128";
    test-causal-conv1d-from-source-py313-cu128 = makeTestApp testCausalCu128FromSourceResult.env  "test-causal-conv1d-from-source-py313-cu128";
    test-flash-attn-bin-py313-cu128            = makeTestApp testFlashAttnBinCu128Result.env      "test-flash-attn-bin-py313-cu128";
    test-flash-attn-source-py313-cu128         = makeTestApp testFlashAttnSourceCu128Result.env   "test-flash-attn-source-py313-cu128";
    test-all-py313-cu128                       = makeTestApp testAllCu128Result.env               "test-all-py313-cu128";
    test-mamba-py313-cu128                     = makeTestApp testMambaCu128Result.env             "test-mamba-py313-cu128";
    test-mamba-source-py313-cu128              = makeTestApp testMambaSourceCu128Result.env       "test-mamba-source-py313-cu128";
  };
}
