✅
old binary-hashes.nix for github packages starts with
```
cudaVersion:
builtins.getAttr cudaVersion {
  cu12 = {
```

new ones however do:
```
{
  cu12 = {
```

✅
further for the torch binary-hashes files the currently do not include the information that is used to name their file. it probably is better to not have a information dependency on file structure.


✅

we need to add information of the python defined dependencies
i.e. if a pkg in python defines that torch = >=2.8 we need to translate that into a nix expression, best via another python script. further we need to be able to manually restrict this further, if we detect a future incompatibility

for wheels this is also relevant, as wheels may have a direct binary based dependency on other wheels, which may become incompatible for future versions (i.e. already incompatible now, but was not known when that version was released.)


The real current failure is **triton version conflict**:
- `pkgs.python3Packages.triton` → 3.5.1 (nixpkgs)
- torch 2.10.0 already propagates triton 3.6.0
i.e. rn this is done manually in override-source:
  dependencies = [
    torch
    causal-conv1d
    pkgs.python3Packages.einops
    pkgs.python3Packages.transformers
    pkgs.python3Packages.triton
  ];
instead this needs to be handles via hdl and concretise. in an hdl we need to define which packages we depend on in an hld independent way. instead when the fix point could not resolve dependencies, we then fallback by a) checking that a python package exist with that name. b) during concretissation some of these may be set already via functions of hdls. if after that it still is not resolved we fallback on the existing one in the nixpkgs python pkgs.python3Packages.<package_name>, this was if we later add a new hdl for an existing pkgs.python3Packages.<package_name> then we do not need to adjust other hdls.
Further as long as hdls define all such dependencies the hdl can then provide default behaviour for the override.nix and override-source.nix further reducing boilerplate. 




✅
lets add test cases for cuda 12.6 and cuda 13.0

concretise should support applying an overlay/override AFTER HDLs are solved but before python packages that no HDL depends on are resolved.  


doing
```
torchPackages.concretise {
          inherit pkgs;
          mlPackages = with torchPackages; [ torch flash-attn mamba-ssm ];
          python = "3.13";
          cuda = "12.8";
          torch = "2.10";
          pascal = false;
          allowBuildingFromSource = true;
          extraPythonPackages =
            ps: with ps; [
              einops
            ];
        };
```
fails with
```
Last 5 log lines:
> pkgs.buildEnv error: two given paths contain a conflicting subpath:
>   `/nix/store/167inkjn2rh9q32shkg22gn85g41h9q9-python3.13-einops-0.8.1/lib/python3.13/site-packages/einops/__pycache__/_backends.cpython-313.opt-1.pyc' and
>   `/nix/store/z5rpvp3n48xda8d112isiw7h4d2bqkhl-python3.13-einops-0.8.1/lib/python3.13/site-packages/einops/__pycache__/_backends.cpython-313.opt-1.pyc'
> hint: this may be caused by two different versions of the same package in buildEnv's `paths` parameter
> hint: `pkgs.nix-diff` can be used to compa
```
so that means the code detecting such dublications does not work yet.
this is probably due to:
```
in
wheelHelpers.buildBinWheel {
  inherit overrideInfo cudaVersion cxx11abi;
  binaryHashesDir    = ./binary-hashes;
  extraDependencies  = [ pkgs.python3Packages.einops ];
```  
which takes einops from the unmodified python3Packages, instead this needs to be updates, so that we use the python environment that concretise is building rn, i.e. use the dependency of our own python 
  


lets change overlay.nix to overlay-bin.nix everywhere to make clear that one is source and one is bin


i have noticed for running binary-hashed with a tag, it does all the parsing, and then realised the file already exists, and discards the work. instead when run explicitly with a tag, it should always replace the file. when run without a tag, it should only do fetching and parsing, if the file does not exist already.


```
 buildBin = { pkgs, cudaPackages, cudaLabel, resolvedDeps, version, wrappers ? null }:
    let
      # Triton wheels are CUDA-agnostic; any.nix covers all CUDA versions.
      binaryHashes = import ./binary-hashes/any.nix;
      perVersionPath = ./binary-hashes + "/v${version}.nix";
      legacyAnyPath  = ./binary-hashes + "/any.nix";

      # Prefer the per
```
i have noticed that some code expects hashes files to have a specific name. this shouldnt be a file inside /binary-hashes/ or /source-hashes/ should be able to have any name and all information must be contained in the content and not depend on the file name. the naming is there more for the hash generator to detected done work and for git commits, do not be as noisy (generated files may change a lot, but if the file is not touched because the generation only touches separate content and places it into a new file, this becomes a none-concern)


```
warning: Git tree '/home/sirati/devel/python/ml-project' is dirty
these 19 derivations will be built:
  /nix/store/9ka8bib47a4xw04y9jsdb182rf9fsbkb-python3.13.11-triton-3.6.0-torch210-cu128-bin.drv
  /nix/store/jfk6xva8i3c5yzj2gnf7pgida83ckj33-python3.13.11-torch-2.10.0-torch210-cu128-bin.drv
  /nix/store/5arjag2v0z3x35vi1rvgsf19gsmlr3j8-python3.13.11-flash-attention-2.8.3-torch210-cu128.drv
  /nix/store/mjwm64dzvp60naa4ivvp84hrskmm9asj-python3.13.11-causal-conv1d-1.6.0-torch210-cu128.drv
  /nix/store/jf1j0lzlqsxdg1ks3wzwsn88y4yxsw09-python3.13.11-mamba-ssm-2.3.0-torch210-cu128.drv
```
as triton does not depend on cuda or torch, please make sure that the derivation is independent of them i.e. python3.13.11-torch-2.10.0-torch210-cu128-bin, python3.13.11-torch-2.10.0-torch210-cu126-bin, python3.13.11-torch-2.9.3-torch209-cu128-bin should all depend on the same triton!, further for the torch derivation name, it should not include torch again


```
let
  # ── Package identity ───────────────────────────────────────────────────────
  # pname and nixpkgsAttr both equal packageName ("mamba-ssm") and are
  # therefore omitted from the returned attrset; hld-type.nix validate fills
  # them in with packageName automatically.

  # GitHub source coordinates.  Provide defaults; override-source.nix reads
  # srcInfo.owner / srcInfo.repo first and falls back to these.
  srcOwner = "state-spaces";
  srcRepo  = "mamba";

  # Changelog URL template (receives the resolved version string).
  mkChangelog = hldHelpers."github-release-tag" srcOwner srcRepo;

  # ── overrideInfo constructor ───────────────────────────────────────────────
  # Standard implementation from hldHelpers.  Builds the common context attrset
  # consumed by override.nix and override-source.nix.  Called once per
  # buildBin / buildSource invocation with the concretise-supplied pkgs,
  # cudaPackages, resolved version, and deps.
  mkOverrideInfo = hldHelpers.mkOverrideInfo {
    pname       = packageName;
    nixpkgsAttr = packageName;
    inherit srcOwner srcRepo mkChangelog;
  };

in
{
  # ── Origin type ────────────────────────────────────────────────────────────
  originType = "github-releases";

  # ── Identity fields ────────────────────────────────────────────────────────
  # pname and nixpkgsAttr are omitted here (both equal packageName);
  # hld-type.nix validate fills them in automatically.
  inherit srcOwner srcRepo mkChangelog mkOverrideInfo;
```
most HDLs contain all these variables that i believe do not need to be defined via let and then inherited. also mkChangelog should be the default for originType = "github-releases"; like this, and mkOverrideInfo should take the values for pname and nixpkgsAttr directly from the HDL in the default implementation.
