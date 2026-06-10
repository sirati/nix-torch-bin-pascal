# nvidia-cutlass-dsl binary wheel derivation.
#
# Installs the whole CuTeDSL wheel family from pinned PyPI wheels:
#
#   cuda-pathfinder  →  cuda-bindings  →  cuda-python (meta)
#                                              │
#   nvidia-cutlass-dsl-libs-base  ─────────────┘  (+ numpy, typing-extensions)
#   nvidia-cutlass-dsl-libs-cu13                  (cu130 only)
#   nvidia-cutlass-dsl (meta wheel, this derivation's pname)
#
# The meta wheel is metadata-only; it exists so that dependants whose
# dist-metadata requires "nvidia-cutlass-dsl" (quack-kernels, sonic-moe) see
# the correctly-named distribution installed.
#
# The cuda-python chain is installed here (rather than taken from nixpkgs)
# because nixpkgs does not package cuda-python.  Hashes and pinned versions
# live in binary-hashes/cuda-deps-cu12.nix / cuda-deps-cu13.nix.
#
# Arguments:
#   overlayInfo  - common package context attrset from high-level.nix
#   cudaLabel    - e.g. "cu126", "cu128", "cu130"; selects the cuda-python
#                  major line and (for cu130) adds the libs-cu13 wheel

{ overlayInfo, cudaLabel }:

let
  pkgs = overlayInfo.pkgs;
  version = overlayInfo.version;
  changelog = overlayInfo.changelog or null;

  lib = pkgs.lib;
  pp = pkgs.python3Packages;

  inherit (import ../../generate-hashes/lib.nix { inherit pkgs; }) pyVer os arch;

  hashes = import (./binary-hashes + "/v${version}.nix");

  isCu13 = cudaLabel == "cu130";
  cudaDeps = import (
    if isCu13 then ./binary-hashes/cuda-deps-cu13.nix else ./binary-hashes/cuda-deps-cu12.nix
  );

  # section: pyVer -> os -> arch -> { name, url, hash }
  lookupWheel =
    sectionName: section:
    section.${pyVer}.${os}.${arch} or (throw (
      "nvidia-cutlass-dsl ${version}: no ${sectionName} wheel for "
      + "${pyVer}/${os}/${arch}"
    ));

  # Minimal wheel-install derivation; all CuTeDSL family members are plain
  # wheel installs with no compilation step.
  mkWheelPkg =
    {
      pname,
      version,
      wheel,
      dependencies ? [ ],
      pythonImportsCheck ? [ ],
      description,
    }:
    pp.buildPythonPackage {
      inherit
        pname
        version
        dependencies
        pythonImportsCheck
        ;
      format = "wheel";

      src = pkgs.fetchurl {
        inherit (wheel) url hash;
        name = wheel.name;
      };

      build-system = [ ];

      # Patch libstdc++ & co. into the bundled MLIR/cython libraries' RPATH.
      # libcuda.so.1 (the driver) stays unresolved — it is found at runtime
      # via /run/opengl-driver (cuda-pathfinder / driverLink).
      nativeBuildInputs = [ pkgs.autoPatchelfHook ];
      buildInputs = [ pkgs.stdenv.cc.cc.lib ];
      autoPatchelfIgnoreMissingDeps = true;

      doCheck = false;

      meta = {
        inherit description;
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      };
    };

  # ── cuda-python dependency chain ──────────────────────────────────────────
  # Prefer the nixpkgs cuda-bindings: nixpkgs' torch-bin propagates it, and
  # reusing the same derivation avoids pythonCatchConflicts duplicates in
  # environments that also contain torch.  Fall back to the pinned PyPI chain
  # (cuda-pathfinder → cuda-bindings → cuda-python) on nixpkgs revisions that
  # do not package cuda-bindings.

  cuda-pathfinder = mkWheelPkg {
    pname = "cuda-pathfinder";
    version = cudaDeps._cudaPathfinderVersion;
    wheel = cudaDeps."cuda-pathfinder";
    description = "Runtime locator for NVIDIA CUDA libraries (pre-built wheel)";
  };

  cuda-bindings = mkWheelPkg {
    pname = "cuda-bindings";
    version = cudaDeps._cudaBindingsVersion;
    wheel = lookupWheel "cuda-bindings" cudaDeps."cuda-bindings";
    dependencies = [ cuda-pathfinder ];
    description = "Low-level Python bindings for the CUDA driver and runtime APIs (pre-built wheel)";
  };

  cuda-python = mkWheelPkg {
    pname = "cuda-python";
    version = cudaDeps._cudaPythonVersion;
    wheel = cudaDeps."cuda-python";
    dependencies = [
      cuda-bindings
      cuda-pathfinder
    ];
    description = "CUDA Python metapackage (pre-built wheel)";
  };

  cudaPythonChain =
    if pp ? cuda-bindings then [ pp.cuda-bindings ] else [ cuda-python ];

  # ── CuTeDSL wheels ─────────────────────────────────────────────────────────

  libs-base = mkWheelPkg {
    pname = "nvidia-cutlass-dsl-libs-base";
    inherit version;
    wheel = lookupWheel "libs-base" hashes.base;
    dependencies = cudaPythonChain ++ [
      pp.numpy
      pp.typing-extensions
    ];
    description = "CUTLASS CuTeDSL core libraries (pre-built wheel)";
  };

  libs-cu13 = mkWheelPkg {
    pname = "nvidia-cutlass-dsl-libs-cu13";
    inherit version;
    wheel = lookupWheel "libs-cu13" (
      hashes.cu13 or (throw "nvidia-cutlass-dsl ${version}: no libs-cu13 wheels published for this version (required for ${cudaLabel})")
    );
    description = "CUTLASS CuTeDSL CUDA 13 toolkit libraries (pre-built wheel)";
  };

in
pp.buildPythonPackage {
  pname = overlayInfo.pname;
  inherit version;
  format = "wheel";

  src = pkgs.fetchurl {
    inherit (hashes.meta) url hash;
    name = hashes.meta.name;
  };

  build-system = [ ];

  dependencies = [ libs-base ] ++ lib.optional isCu13 libs-cu13;

  doCheck = false;

  # libs-base uses a .pth-redirect layout (cutlass lives under
  # nvidia_cutlass_dsl/python_packages/, exposed via nvidia_cutlass_dsl.pth).
  # .pth files are processed for site dirs (and for NIX_PYTHONPATH via the
  # nixpkgs sitecustomize in the final env) but NOT for plain PYTHONPATH,
  # which is what pythonImportsCheck uses — so run a site-aware import check
  # instead.  `import cutlass` loads the bundled MLIR libraries but does not
  # touch the GPU/driver, so it is safe inside the build sandbox.
  postInstall = ''
    echo "checking cutlass import (site-aware) …"
    python -c "
import os, site
for p in os.environ.get('PYTHONPATH', \"\").split(':'):
    if p:
        site.addsitedir(p)
import cutlass
print('cutlass imported from', cutlass.__file__)
"
  '';

  meta = {
    description = "NVIDIA CUTLASS CuTeDSL Python DSL (pre-built wheel)";
    homepage = "https://github.com/NVIDIA/cutlass";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    broken = (overlayInfo.isBinBuildBroken or (_: false)) overlayInfo;
  }
  // lib.optionalAttrs (changelog != null) { inherit changelog; };
}
