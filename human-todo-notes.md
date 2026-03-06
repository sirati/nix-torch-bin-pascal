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

further for the torch binary-hashes files the currently do not include the information that is used to name their file. it probably is better to not have a information dependency on file structure.


instead of having an optional arg preferBin, i would like to have allowBuildingFromSource being mandatory

we need to add information of the python defined dependencies
i.e. if a pkg in python defines that torch = >=2.8 we need to translate that into a nix expression, best via another python script. further we need to be able to manually restrict this further, if we detect a future incompatibility

for wheels this is also relevant, as wheels may have a direct binary based dependency on other wheels, which may become incompatible for future versions (i.e. already incompatible now, but was not known when that version was released.)

in pkgs/default.nix I can see the following `  fix = f: let x = f x; in x;` i thought there is an existing fix provided by nix (maybe that is only provided by nixpkgs so we cannot use it)


as part of the source process besides binary-hashes we need to have a source-hashes folder that contains whats needed for building a python packages from source, e.g. fetchFromGitHub requires the following attrset as argument
```
{
    owner = "Dao-AILab";
    repo = "causal-conv1d";
    tag = "v${version}";
    hash = "sha256-hFaF/oMdScDpdq+zq8WppWe9GONWppEEx2pIcnaALiI=";
  };
```
so we need to probably rename generate-binary-hashes folder to generate-hashes, and then in new files add the code for generating source-hashes, based on tagged commits.


causal-conv1d and flash-attn both have an override.nix that shares a lot of code, this is probably true for most pytorch dep. python packages. that code should go into a shared file outside of the pkgs folder.


please stop using cuda12.6 in all examples. the current standard is cuda12.8, always use that.

currently the error checking and messages for buildSource in all high-level.nix are the same more less. this shared code must be extracted into hld-helpers.nix



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



```
these 5 derivations will be built:
  /nix/store/k7w5dmdlqs3gnr4pl6h5bhndqrdd4dw4-python3.13-flash-attention-2.8.3.drv
  /nix/store/7gpbaq0blmqb193nrvswngcb0pzc5b2r-python3-3.13.11-env.drv
  /nix/store/bh0r13v3vc5yavqckc5hhx37ir4fgrgm-python3.13-mamba-ssm-2.3.0.drv
  /nix/store/95xxba1xip7f140lw2qss5jmysqs3bb4-python3-3.13.11-env.drv
  /nix/store/gbwj8nvlxad03sz7xqypwk214c2fyhkg-python3-3.13.11-env.drv
building '/nix/store/k7w5dmdlqs3gnr4pl6h5bhndqrdd4dw4-python3.13-flash-attention-2.8.3.drv'...
building '/nix/store/bh0r13v3vc5yavqckc5hhx37ir4fgrgm-python3.13-mamba-ssm-2.3.0.drv'...
```
It would be great if build python packages via HDL contain in the store path the torch, cuda, and pascal version, as well as adding a -bin for wheel build ones.

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



it would be more appropirate for triton binary-hashes files to be named by and separated by the triton version not any.nix


```
TRITON_LIBCUDA_PATH = "/run/opengl-driver/lib";
```
I think its best to remove these, its unexpected that concretise makes such modifications, also if the fix has to always work 



currently HDLs already specify their origin-type (rename to originType) and other data needed for the theit generate-hashes.py. the generate-hashes.py have a lot of common code, please refactor it so more code lives in generate-hashes.py, further we just refactored HLD (with help of flake.nix) to allow invoking e.g. nix run .#default.flash-attn.gen-hashes -- --tag v2.8.1
As nearly every specific information needed in already in the HDL, please refactor this invokation method so that the available info in the HDL is used and not dublicated between the HDL and the generate-hashes.py. i.e. most common code needs to live in /generate-hashes/ the generate-hashes.py does not define its own main instead, it is imported by the main living in /generate-hashes/ this way allowing custom python code. the regex should be moved to the HDL.
keep in mind that torch/triton and flash-attn/causal-conv1d/mamba-ssm work quite differently, so your refactor needs to keep this modularity. as before assume that for torch/triton we do not set defaults or we set the default conditionally on originType being github-releases vs torch-website.


i have noticed calling generate-hashes will corrupt the missing-digests file, if called e.g. for a specific tag. missing-digests instead should be updated.
