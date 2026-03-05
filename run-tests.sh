#!/usr/bin/env bash
# run-tests.sh
#
# Phase 1 – build all test packages in one shot (--keep-going, continue on failure)
# Phase 2 – rebuild each package individually so per-package errors are isolated
# Phase 3 – run each test app (skipped when the corresponding build failed)
#
# Everything is tee'd into run-tests.log next to this script.
#
# Start in a detached screen:
#   screen -dmS nix-tests bash /path/to/run-tests.sh

set -o pipefail   # no -e and no -u: collect all failures, tolerate unset vars

REPO="$(cd "$(dirname "$0")" && pwd)"
LOG="$REPO/run-tests.log"

# Truncate log for this run
: > "$LOG"

# Tee everything from here on
exec > >(tee -a "$LOG") 2>&1

NIX_BUILD_FLAGS="--max-jobs 6 --cores 4 --keep-going"
NIX_RUN_FLAGS="--max-jobs 6 --cores 4"

PACKAGES=(
  test-torch-py313-cu128
  test-causal-conv1d-py313-cu128
  test-flash-attn-bin-py313-cu128
  test-mamba-py313-cu128
  test-causal-conv1d-from-source-py313-cu128
  test-flash-attn-source-py313-cu128
  test-mamba-source-py313-cu128
  test-all-py313-cu128
)

stamp()  { date '+%Y-%m-%d %H:%M:%S'; }
sep()    { echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; }
header() { sep; echo "$(stamp)  $*"; sep; }

header "run-tests.sh started"
echo "  repo : $REPO"
echo "  log  : $LOG"
echo

# ─────────────────────────────────────────────────────────────────────────────
# Phase 1 – bulk build (keep going on individual failures)
# ─────────────────────────────────────────────────────────────────────────────
header "PHASE 1 – bulk build (keep-going)"

INSTALLABLES=""
for pkg in "${PACKAGES[@]}"; do
  INSTALLABLES="$INSTALLABLES .#packages.x86_64-linux.$pkg"
done

BULK_RC=0
# shellcheck disable=SC2086
nix build $INSTALLABLES $NIX_BUILD_FLAGS || BULK_RC=$?
true  # ensure pipefail does not trip on the || above

if [[ $BULK_RC -eq 0 ]]; then
  echo "$(stamp)  ✓  bulk build succeeded"
else
  echo "$(stamp)  ✗  bulk build had failures (exit $BULK_RC) – will retry individually"
fi

# ─────────────────────────────────────────────────────────────────────────────
# Phase 2 – individual (re-)builds
# ─────────────────────────────────────────────────────────────────────────────
header "PHASE 2 – individual builds"

declare -A BUILD_RC
BUILD_OVERALL=0

# Pre-initialise every entry to 1 (failed) so Phase 3 reads a safe value
# even if the loop below is interrupted.
for pkg in "${PACKAGES[@]}"; do
  BUILD_RC[$pkg]=1
done

for pkg in "${PACKAGES[@]}"; do
  echo
  echo "$(stamp)  ── $pkg ──"
  rc=0
  # shellcheck disable=SC2086
  nix build ".#packages.x86_64-linux.$pkg" $NIX_BUILD_FLAGS || rc=$?
  true  # ensure pipefail does not trip on the || above
  BUILD_RC[$pkg]=$rc
  if [[ $rc -eq 0 ]]; then
    echo "$(stamp)  ✓  $pkg"
  else
    echo "$(stamp)  ✗  $pkg  FAILED (exit $rc)"
    BUILD_OVERALL=1
  fi
done

# ─────────────────────────────────────────────────────────────────────────────
# Phase 3 – run test apps
# nix run .#apps.x86_64-linux.<name> uses the apps output; the app program
# runs the Python test script inside the built env.
# --impure is needed because nix run reads the flake from a dirty worktree.
# ─────────────────────────────────────────────────────────────────────────────
header "PHASE 3 – run test apps"

declare -A RUN_RC
RUN_OVERALL=0

# Pre-initialise to SKIP so an interrupted loop leaves a readable value.
for pkg in "${PACKAGES[@]}"; do
  RUN_RC[$pkg]="SKIP"
done

for pkg in "${PACKAGES[@]}"; do
  echo
  echo "$(stamp)  ── $pkg ──"
  if [[ "${BUILD_RC[$pkg]:-1}" -ne 0 ]]; then
    echo "$(stamp)  SKIP (build failed)"
    RUN_RC[$pkg]="SKIP"
    continue
  fi
  rc=0
  # shellcheck disable=SC2086
  nix run ".#$pkg" $NIX_RUN_FLAGS --impure || rc=$?
  true  # ensure pipefail does not trip on the || above
  RUN_RC[$pkg]=$rc
  if [[ $rc -eq 0 ]]; then
    echo "$(stamp)  ✓  $pkg"
  else
    echo "$(stamp)  ✗  $pkg  FAILED (exit $rc)"
    RUN_OVERALL=1
  fi
done

# ─────────────────────────────────────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────────────────────────────────────
header "SUMMARY"

printf "  %-48s  %-8s  %-8s\n" "package" "build" "run"
printf "  %-48s  %-8s  %-8s\n" "-------" "-----" "---"
for pkg in "${PACKAGES[@]}"; do
  b_rc="${BUILD_RC[$pkg]:-?}"
  r_val="${RUN_RC[$pkg]:-?}"

  if [[ "$b_rc" == "0" ]]; then b_str="OK"; else b_str="FAIL($b_rc)"; fi
  case "$r_val" in
    0)    r_str="OK" ;;
    SKIP) r_str="SKIP" ;;
    *)    r_str="FAIL($r_val)" ;;
  esac

  printf "  %-48s  %-8s  %-8s\n" "$pkg" "$b_str" "$r_str"
done

echo
FINAL=0
[[ $BUILD_OVERALL -eq 0 ]] || FINAL=1
[[ $RUN_OVERALL   -eq 0 ]] || FINAL=1

if [[ $FINAL -eq 0 ]]; then
  echo "$(stamp)  ✓  ALL builds and runs PASSED"
else
  echo "$(stamp)  ✗  Some builds or runs FAILED – see above and $LOG"
fi

echo
echo "$(stamp)  run-tests.sh finished  (exit $FINAL)"
sep

exit $FINAL
