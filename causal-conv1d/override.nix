# causal-conv1d-bin: pre-built wheel derivation for causal-conv1d.
#
# This replaces the from-source nixpkgs causal-conv1d with a pre-built binary
# wheel from the official GitHub releases, avoiding the CUDA compilation step.
#
# The wheel selection is automatic:
#   - Torch major.minor version is extracted from the `torch` argument.
#   - If an exact compat key exists in binary-hashes.nix it is used directly;
#     otherwise the highest available compat key that is <= the torch version
#     is chosen as a fallback (causal-conv1d wheels are generally ABI-compatible
#     with later torch minor releases of the same major version).
#   - Python version and platform are detected from pkgs.python3 / stdenv.
#
# cxx11abi handling:
#   The default is "TRUE" (new C++11 ABI), matching the standard PyTorch pip
#   wheels on Linux.  Pass cxx11abi = "FALSE" only if you are using a PyTorch
#   build compiled with -D_GLIBCXX_USE_CXX11_ABI=0 (old / pre-cxx11 ABI).
#   When cxx11abi = "FALSE" the wheel is taken from the `precx11abi` attribute
#   of the leaf node; if that attribute is absent no pre-built wheel exists for
#   the requested platform and an evaluation error is raised.
#
# Arguments:
#   pkgs                 - nixpkgs package set (pkgs.python3 must be the target Python)
#   torch                - the torch (or torch-bin) derivation to depend on
#   causalConv1dVersion  - causal-conv1d version string (default: "1.6.0")
#   cudaVersion          - CUDA version the wheel was compiled against (default: "cu12")
#                          Used as the top-level key in binary-hashes.nix.
#                          Typical values: "cu11", "cu12", "cu13".
#   cxx11abi             - "TRUE" or "FALSE" (default: "TRUE", matching standard
#                          PyTorch pip wheels on Linux)

{ pkgs
, torch
, causalConv1dVersion ? "1.6.0"
, cudaVersion         ? "cu12"
, cxx11abi            ? "TRUE"
}:

let
  inherit (pkgs) lib;

  inherit (import ../generate-binary-hashes/lib.nix { inherit pkgs; })
    pythonVersion pyVer os arch versionLE versionLT;

  # ── Platform validation ───────────────────────────────────────────────────

  _assertLinux = if os == "linux" then true
    else throw "causal-conv1d pre-built wheels are only available for Linux (got: ${os})";

  # ── binary-hashes lookup ──────────────────────────────────────────────────

  # binary-hashes.nix is a function: cudaVersion -> attrset keyed by causal-conv1d version.
  # Each version value is an attrset keyed by torchCompat.
  versionData = (import ./binary-hashes.nix cudaVersion).${causalConv1dVersion};

  # All torch compat keys present in binary-hashes.nix for this combination.
  availableCompat = builtins.attrNames versionData;   # e.g. [ "2.5" "2.6" "2.7" "2.8" ]

  # ── Torch version -> compat key resolution ────────────────────────────────

  # Extract major.minor from the torch derivation's version, e.g. "2.8.1" -> "2.8"
  torchVerParts   = lib.strings.splitString "." torch.version;
  torchMajorMinor = "${lib.elemAt torchVerParts 0}.${lib.elemAt torchVerParts 1}";

  # Check whether a given compat key has a wheel for the current
  # pyVer / os / arch combination (and, for FALSE ABI, a precx11abi entry).
  compatHasWheel = compat:
    builtins.hasAttr compat versionData                          &&
    builtins.hasAttr pyVer  versionData.${compat}                &&
    builtins.hasAttr os     versionData.${compat}.${pyVer}       &&
    builtins.hasAttr arch   versionData.${compat}.${pyVer}.${os} &&
    (cxx11abi == "TRUE" ||
     builtins.hasAttr "precx11abi" versionData.${compat}.${pyVer}.${os}.${arch});

  # Select the best compat key: walk candidates from highest to lowest and
  # pick the first one that actually has a wheel for our platform triple.
  # Candidates are all compat keys numerically <= torchMajorMinor.
  torchCompat =
    let
      candidates = lib.sort (a: b: versionLT b a)   # descending numeric order
        (lib.filter (k: versionLE k torchMajorMinor) availableCompat);

      findFirst = cs:
        if cs == []
        then throw (
          "causal-conv1d ${causalConv1dVersion} (${cudaVersion}): no compatible pre-built wheel found for "
          + "torch ${torchMajorMinor}, Python ${pythonVersion}, "
          + "cxx11abi ${cxx11abi}, ${os}/${arch}. "
          + "Available compat keys: ${builtins.toString availableCompat}"
        )
        else if compatHasWheel (lib.head cs) then lib.head cs
        else findFirst (lib.tail cs);
    in
    findFirst candidates;

  # ── Wheel lookup ──────────────────────────────────────────────────────────

  # The leaf node contains the TRUE-ABI wheel at the top level.
  # When cxx11abi = "FALSE" we use the nested precx11abi attribute instead.
  wheelLeaf = versionData.${torchCompat}.${pyVer}.${os}.${arch};

  wheelData =
    if cxx11abi == "TRUE" then
      # Strip precx11abi (if present) so fetchurl only sees name/url/hash.
      { inherit (wheelLeaf) name url hash; }
    else
      # compatHasWheel already verified precx11abi exists at this point.
      wheelLeaf.precx11abi;

in
assert _assertLinux;
pkgs.python3Packages.buildPythonPackage {
  pname   = "causal-conv1d";
  version = causalConv1dVersion;

  format = "wheel";

  src = pkgs.fetchurl {
    inherit (wheelData) url hash;
    name = wheelData.name;
  };

  # Pre-built wheel: no compilation needed
  build-system  = [];
  buildInputs   = [];

  # Runtime Python dependencies
  dependencies = [
    torch
  ];

  # Binary wheel: no test suite to run here
  doCheck = false;

  pythonImportsCheck = [ "causal_conv1d" ];

  meta = {
    description = "Efficient implementation of a causal 1D convolution for autoregressive models (pre-built wheel)";
    homepage    = "https://github.com/Dao-AILab/causal-conv1d";
    changelog   = "https://github.com/Dao-AILab/causal-conv1d/releases/tag/v${causalConv1dVersion}";
    license     = lib.licenses.bsd3;
    platforms   = [ "x86_64-linux" "aarch64-linux" ];
    broken      = false;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
