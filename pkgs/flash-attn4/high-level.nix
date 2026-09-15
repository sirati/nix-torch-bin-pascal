# High-level derivation for FlashAttention 4 beta.
#
# FlashAttention 4 is published from Dao-AILab/flash-attention using tags like
# fa4-v4.0.0.beta30.  Unlike the existing flash-attn HLD, this package is
# source-only in this flake: the upstream wheels are pure Python wrappers, and
# the useful runtime kernels come from CuTeDSL / QuACK dependencies.

{ torch
, nvidia-cutlass-dsl
, apache-tvm-ffi
, torch-c-dlpack-ext
, quack-kernels
, hldHelpers
, packageName
}:

assert hldHelpers.isHLD torch;
assert hldHelpers.isHLD nvidia-cutlass-dsl;
assert hldHelpers.isHLD apache-tvm-ffi;
assert hldHelpers.isHLD torch-c-dlpack-ext;
assert hldHelpers.isHLD quack-kernels;

let
  minBeta = "30";

  betaVersionFromFile =
    n:
    let
      m = builtins.match "v(fa4-v4[.]0[.]0[.]beta([0-9]+))[.]nix" n;
    in
    if m == null then null else {
      version = builtins.elemAt m 0;
      beta = builtins.elemAt m 1;
    };
in
{
  originType = "github-releases";

  pname = "flash-attn-4";
  srcOwner = "Dao-AILab";
  srcRepo = "flash-attention";

  mkChangelog = v:
    "https://github.com/Dao-AILab/flash-attention/releases/tag/${v}";

  torchAgnostic = true;

  highLevelDeps = {
    inherit torch nvidia-cutlass-dsl apache-tvm-ffi torch-c-dlpack-ext quack-kernels;
  };

  versionConstraints = {
    # Upstream permits Quack >= 0.5.3 and DSL >= 4.6.2. Quack 0.5.3
    # pins an older DSL, so use the compatible 0.6.5 / DSL >= 4.7 pair.
    nvidia-cutlass-dsl = { minVersion = "4.7"; };
    apache-tvm-ffi = { minVersion = "0.1.12"; maxVersion = "0.1.99"; };
    quack-kernels = { minVersion = "0.6.5"; };
  };

  getVersions =
    _cudaLabel: pyVer:
    if builtins.match "py3(1[0-9]|[2-9][0-9]).*" pyVer != null then
      let
        files = builtins.attrNames (builtins.readDir ./source-hashes);
        parsed = builtins.filter (x: x != null) (map betaVersionFromFile files);
        supported = builtins.filter
          (x: builtins.compareVersions x.beta minBeta >= 0)
          parsed;
      in
      map (x: x.version) supported
    else
      [ ];

  canBuildBin = _: false;

  buildBin = _:
    throw "flash-attn4: source-only package; use allowBuildingFromSource = true";

  buildSource =
    { mkOverlayInfo, pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      v =
        if version == null then
          throw "flash-attn4 buildSource: no buildable version resolved; minimum supported tag is fa4-v4.0.0.beta30 and Python >= 3.10 is required."
        else
          hldHelpers.requireSourceHash
            "flash-attn4" "pkgs/flash-attn4" ./source-hashes
            { inherit version cudaLabel; };
    in
    import ./overlay-source.nix {
      overlayInfo = mkOverlayInfo { inherit pkgs cudaPackages resolvedDeps; version = v; };
      nvidia-cutlass-dsl = resolvedDeps."nvidia-cutlass-dsl";
      apache-tvm-ffi = resolvedDeps."apache-tvm-ffi";
      torch-c-dlpack-ext = resolvedDeps."torch-c-dlpack-ext";
      quack-kernels = resolvedDeps."quack-kernels";
    };
}
