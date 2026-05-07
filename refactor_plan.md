## Issues

I have worked on getting ML packages to work privately for the past month, and I do think I have gained some understanding on how the build process works. I have identified the following issues:

derivation do not properly check that the build environment is valid: CUDA is picky when it comes to compiler versions, using the wrong compiler creates crashes that are sporadic, hard to debug, and usually happen after 100% CPU add RAM utilisation of up-to multiple hours. We must fail early.

nix derivations sometimes depend on specific version of a dependency, even though they would support a never version. This fails because we end up pulling in the same dependency of different versions or worse same version but different derivation inputs. We must separate the nix derivation dependency tree and the python package dependency tree, so that this can be resolved without having to recompile expensive packages.

Currently only the main Cuda version supported by pytorch is available in nixpkgs, this unfortunately means that some GPUs are too old and cannot be used with NixOS for ML development

cudaPackages is not as straight forward as assumed in nixpkgs, some CUDA toolchain parts have their own restrictions in supported compute capability and supported architectures (yes they are separate, ik…)

while there is shared code for different python version, this completely lacks for CUDA specific differences, but because CUDA dependencies exist and are messy this is really required.

Updating part of the ML packages should not easily allow for making the current nixpkgs bugged, i.e. that the supported packages are incompatible with each other, as currently frequently happens and then requires manual intervention.

## What I imagine the solution looks like:

Each python package derivation is split into four derivations:a) source-only derivationb) build derivation (this has two flavours: build from source, or use existing wheel/bin)c) high-level derivationd) python-level derivation

build derivation depend only on packages that they MUST have for building. this way we can avoid having to expensively recompile these (this is especially relevant to build servers as otherwise this exploded combinatorially). This means they may depend on other source-only derivations preferably, or if need be other build derivations. build derivation always depend on their own source’s source-only derivation

high-level derivation do not depend on anything but other high-level derivation. They do not do any hard work, perform fail-early validation if possible to do in a built-in-specific manner. They also by themselves do not provide any build results (as they cannot). In other words, to create a python environment, they must be passed to a function that concretises them.

python-level derivations are created by the concretise function that resolves high-level derivation into  build derivation, and makes the specific instance of the python-level derivation depend on both its high-level derivation and concrete build derivation.

the concretise function is always called by the end user. It can only be called with a set of high-level derivations, cuda version (or absense of cuda support), compiler set, required compute capability, and python version. If possible if a expression contains packages created via two calls to the concretise function this should be detected, and result is an early-fail.

### Unsupported
I do not plan to ever support building torch from sources. It would be possible to support linking to previous version of upstream that declared how to build torch from sources, and explicitly only support those.
