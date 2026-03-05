# Immediate TODOs

## Check run-tests.sh results (first thing tomorrow)

The screen session `nix-tests` was started at end of session.  It runs:
  - Phase 1: bulk build of all 8 test packages (keep-going)
  - Phase 2: individual rebuild of each package (for isolated error output)
  - Phase 3: nix run for each app (runs test-torch.py inside the built env)

Full log: `./run-tests.log`

Check log:
  screen -r nix-tests          # attach if still running
  cat run-tests.log            # or just read the log

### Likely failures to investigate

- Source builds (flash-attn, mamba-ssm, causal-conv1d from source) were
  building when the session ended — they may have completed or may have failed.
  Check the SUMMARY table in run-tests.log for build/run status of each.

- If any `nix run` step fails, check whether it is a runtime error (e.g.
  pythonImportsCheck failure, wrong module name) or a GPU test failure (no
  CUDA device on the build host).  Runtime-only GPU failures are expected on
  a headless build machine; import-check failures need fixing.

### Known issues already fixed this session

- All upstream nixpkgs derivations for causal-conv1d, flash-attn, mamba-ssm
  carry `meta.broken = true`.  Fixed by:
    - `wheel-helpers.nix`: `broken = (overrideInfo.isBinBuildBroken or (_: false)) overrideInfo`
    - `concretise/source-build-helpers.nix`: same with `isSourceBuildBroken`
  Default is always `false`, overriding nixpkgs.  HLDs can set custom broken
  predicates via new HLD fields `isBinBuildBroken` / `isSourceBuildBroken`
  (both added to `pkgs/hld-type.nix` with `default = _: false`).

## After verifying run-tests.sh results

- Mark build/run checklist items below as done or record failures.
- If any test is still failing, fix the root cause before moving on.

## Build / runtime verification checklist

- [ ] Binary wheel install: `test-causal-conv1d-py313-cu128`
- [ ] Binary wheel install: `test-flash-attn-bin-py313-cu128`
- [ ] Binary wheel install: `test-mamba-py313-cu128`
- [ ] Source build: `test-causal-conv1d-from-source-py313-cu128`
- [ ] Source build: `test-flash-attn-source-py313-cu128`
- [ ] Source build: `test-mamba-source-py313-cu128`
- [ ] Torch only: `test-torch-py313-cu128`
- [ ] All-packages: `test-all-py313-cu128`

## Next work item (after checklist is green)

Next item from refactor_impl.md: HLD Python package dependency resolution.