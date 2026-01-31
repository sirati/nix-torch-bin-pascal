# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.9.1" = {
    x86_64-linux-310-cuda12_6 = {
      name = "torch-2.9.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu126/torch-2.9.1%2Bcu126-cp310-cp310-manylinux_2_28_x86_64.whl#sha256=8840a4439668cad44961933cedee9b1242eb67da93ec49c1ab552f4dbce10bbb";
      hash = "sha256-1fqbw6y4sbsmmg0lkv4kv9kynhhjkgpfsg4kc54x9jk8jr1s8h48=";
    };
    x86_64-linux-311-cuda12_6 = {
      name = "torch-2.9.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu126/torch-2.9.1%2Bcu126-cp311-cp311-manylinux_2_28_x86_64.whl#sha256=57e4f908dda76a6d5bf7138727d95fcf7ce07115bc040e7ed541d9d25074b28d";
      hash = "sha256-13djfi8d5na1smz0w15w2mqy0z6gbzcjg1qkyxdnssm7vl4gkr2p=";
    };
    x86_64-linux-312-cuda12_6 = {
      name = "torch-2.9.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu126/torch-2.9.1%2Bcu126-cp312-cp312-manylinux_2_28_x86_64.whl#sha256=67e9b1054f435d33af6fa67343f93d73dc2d37013623672d6ffb24ce39b666c2";
      hash = "sha256-1hk6nqwww97vdwnnf8rn04vjvp3k7pwl6wx6dypk6pa39w2v3sb7=";
    };
    x86_64-linux-313-cuda12_6 = {
      name = "torch-2.9.1-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu126/torch-2.9.1%2Bcu126-cp313-cp313t-manylinux_2_28_x86_64.whl#sha256=ad0d5dd90f8e43c5a739e662b0542448e36968002efc4c2a11c5ad3b01faf04b";
      hash = "sha256-0jzhz80kpbf524m4rz1f01l6kqs84iab0qp676kwahwf1zcms3dd=";
    };
    x86_64-linux-314-cuda12_6 = {
      name = "torch-2.9.1-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu126/torch-2.9.1%2Bcu126-cp314-cp314t-manylinux_2_28_x86_64.whl#sha256=a18e6b0eccee2163f90cc894d0a12ed0a83cf009c8597063a05237f2606438d0";
      hash = "sha256-1l1qcihg4dsjl1ip0nf817q3ra6h5shx15681kwn68gfrh76p3m1=";
    };
  };
}
