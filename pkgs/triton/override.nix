# Generic triton override for pre-built wheels.
#
# This is the shared implementation called by triton/high-level.nix buildBin.
# It imports the appropriate binary-hashes file and fetches the matching
# pre-built wheel, then applies NixOS compatibility patches in postFixup:
#
#   1. Mirror nixpkgs patch 0002-nvidia-driver-short-circuit-before-ldconfig:
#      Insert an os.path.exists check for the CUDA stubs dir immediately before
#      the /sbin/ldconfig call in triton/backends/nvidia/driver.py.
#      If the stubs dir exists, return it directly — this provides libcuda.so.1
#      for triton's JIT kernel compilation without needing /sbin/ldconfig.
#      /sbin/ldconfig does not exist on NixOS, so without this patch every
#      triton kernel dispatch raises FileNotFoundError.
#
#   2. C compiler path (build.py):
#      triton/runtime/build.py looks for "cc" / "gcc" / "clang" on PATH to
#      compile a small C extension (driver.c) on first use.  On NixOS those
#      names are not on PATH outside a build sandbox.
#      The fix replaces the bare os.environ.get("CC") call with a fallback
#      to the Nix-provided gcc, so triton can always compile driver.c even
#      when run via `nix run` or from a plain shell.
#
#   3. ptxas symlink: the upstream triton-bin postFixup already links ptxas
#      from cudaPackages.cuda_nvcc into triton/third_party/cuda/bin/.
#      The wheel also bundles its own ptxas at backends/nvidia/bin/ptxas
#      (patched by autoPatchelfHook), which is the path knobs.py uses as
#      default.  No additional symlink is required here.
#
# Arguments:
#   pkgs            - nixpkgs package set (pkgs.python3 must be the target Python)
#   cudaPackages    - the CUDA package set to link against at runtime
#   tritonVersion   - Triton version string, e.g. "3.6.0"
#   versionHashes   - plain attrset imported from binary-hashes/v{version}.nix
#                     (keyed by pyVer → os → arch; no outer version key)

{ pkgs, cudaPackages, tritonVersion, versionHashes }:

let
  inherit (import ../../generate-hashes/lib.nix { inherit pkgs; })
    pyVer os arch;

  # Look up wheel data from the per-version attrset (pyVer -> os -> arch).
  # Sentinel keys like _version are never valid pyVer values so no filtering is needed.
  wheelData =
    if builtins.hasAttr pyVer versionHashes then
      let pyData = versionHashes.${pyVer}; in
      if builtins.hasAttr os pyData then
        let osData = pyData.${os}; in
        if builtins.hasAttr arch osData then
          osData.${arch}
        else throw "Unsupported architecture for triton ${tritonVersion}: ${arch} (available: ${builtins.toString (builtins.attrNames osData)})"
      else throw "Unsupported OS for triton ${tritonVersion}: ${os} (available: ${builtins.toString (builtins.attrNames pyData)})"
    else throw "Unsupported Python version for triton ${tritonVersion}: ${pyVer} (available: ${builtins.toString (builtins.attrNames versionHashes)})";

  # CUDA stubs dir — provides libcuda.so.1 for triton's JIT kernel linker.
  # Mirrors the @libcudaStubsDir@ substitution in nixpkgs patch 0002.
  cudaStubsDir = "${pkgs.lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs";

  # Nix-provided C compiler used by triton/runtime/build.py to compile
  # driver.c on first use.  Hard-coded so it is found even outside a build
  # sandbox (e.g. `nix run`, plain shell with a Nix Python env).
  nixCC = "${pkgs.gcc}/bin/gcc";

in
# Override wheel source on the upstream triton-bin derivation.
# The upstream postFixup (inherited via old.postFixup) already symlinks ptxas
# from cudaPackages.cuda_nvcc into triton/third_party/cuda/bin/.
(pkgs.python3Packages.triton-bin.override {
  inherit cudaPackages;
}).overrideAttrs (old: {
  version = tritonVersion;
  src     = pkgs.fetchurl wheelData;

  postFixup = (old.postFixup or "") + ''
    sitePackages="$out/lib/python${pkgs.python3.pythonVersion}/site-packages"

    # ── Patch 1: ldconfig short-circuit (driver.py) ────────────────────────
    #
    # Mirrors nixpkgs 0002-nvidia-driver-short-circuit-before-ldconfig.patch.
    #
    # libcuda_dirs() calls /sbin/ldconfig -p to find libcuda.so.1.
    # On NixOS /sbin/ldconfig does not exist → FileNotFoundError on every
    # triton kernel dispatch.
    #
    # Insert an os.path.exists() guard for the CUDA stubs dir immediately
    # before the ldconfig call.  The stubs dir always exists in a Nix CUDA
    # build and contains libcuda.so.1 (stub, used for -lcuda linking).
    # The real libcuda.so.1 is provided at runtime by the NVIDIA driver via
    # addDriverRunpath / LD_LIBRARY_PATH.
    driverPath="$sitePackages/triton/backends/nvidia/driver.py"
    if [ -f "$driverPath" ]; then
      ${pkgs.gnused}/bin/sed -i \
        's|    libs = subprocess\.check_output(\["/sbin/ldconfig", "-p"\])\.decode(errors="ignore")|    if os.path.exists("${cudaStubsDir}"):\n        return ["${cudaStubsDir}"]\n\n    libs = subprocess.check_output(["/sbin/ldconfig", "-p"]).decode(errors="ignore")|' \
        "$driverPath"
    fi

    # ── Patch 2: C compiler path (build.py) ────────────────────────────────
    #
    # triton/runtime/build.py compiles a small C extension (driver.c) on
    # first use.  It looks for "gcc" / "clang" via shutil.which(), which
    # fails on NixOS because those names are not on PATH outside a sandbox.
    #
    # Replace the bare os.environ.get("CC") with a fallback to the
    # Nix-provided gcc so the extension can always be compiled.
    buildPyPath="$sitePackages/triton/runtime/build.py"
    if [ -f "$buildPyPath" ]; then
      ${pkgs.gnused}/bin/sed -i \
        's|    cc = os\.environ\.get("CC")|    cc = os.environ.get("CC", "${nixCC}")|' \
        "$buildPyPath"
    fi
  '';
})
