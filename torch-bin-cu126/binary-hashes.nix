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
      hash = "sha256-iECkQ5ZoytRJYZM87e6bEkLrZ9qT7EnBq1UvTbzhC7s=";
    };
    x86_64-linux-311-cuda12_6 = {
      name = "torch-2.9.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu126/torch-2.9.1%2Bcu126-cp311-cp311-manylinux_2_28_x86_64.whl#sha256=57e4f908dda76a6d5bf7138727d95fcf7ce07115bc040e7ed541d9d25074b28d";
      hash = "sha256-V+T5CN2nam1b9xOHJ9lfz3zgcRW8BA5+1UHZ0lB0so0=";
    };
    x86_64-linux-312-cuda12_6 = {
      name = "torch-2.9.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu126/torch-2.9.1%2Bcu126-cp312-cp312-manylinux_2_28_x86_64.whl#sha256=67e9b1054f435d33af6fa67343f93d73dc2d37013623672d6ffb24ce39b666c2";
      hash = "sha256-Z+mxBU9DXTOvb6ZzQ/k9c9wtNwE2I2ctb/skzjm2ZsI=";
    };
    x86_64-linux-313-cuda12_6 = {
      name = "torch-2.9.1-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu126/torch-2.9.1%2Bcu126-cp313-cp313t-manylinux_2_28_x86_64.whl#sha256=ad0d5dd90f8e43c5a739e662b0542448e36968002efc4c2a11c5ad3b01faf04b";
      hash = "sha256-rQ1d2Q+OQ8WnOeZisFQkSONpaAAu/EwqEcWtOwH68Es=";
    };
    x86_64-linux-314-cuda12_6 = {
      name = "torch-2.9.1-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu126/torch-2.9.1%2Bcu126-cp314-cp314t-manylinux_2_28_x86_64.whl#sha256=a18e6b0eccee2163f90cc894d0a12ed0a83cf009c8597063a05237f2606438d0";
      hash = "sha256-oY5rDszuIWP5DMiU0KEu0Kg88AnIWXBjoFI38mBkONA=";
    };
  };
}
