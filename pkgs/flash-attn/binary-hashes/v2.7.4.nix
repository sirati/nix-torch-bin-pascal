# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/Dao-AILab/flash-attention/releases
# To regenerate: nix run .#default.flash-attn.gen-hashes [-- --skip-source --tag v2.7.4]
#
# Structure: cudaVersion -> torchCompat -> pyVer -> os -> arch
#
#   cudaVersion: CUDA major[minor] the wheel was compiled against (e.g. cu12, cu126).
#   torchCompat: torch major.minor the wheel was compiled against.
#   pyVer:       py39, py310, …  (CPython only; no free-threaded variants).
#   os:          linux  (only Linux wheels provided as pre-built binaries)
#   arch:        x86_64, aarch64
#
# Each leaf node contains the TRUE cxx11abi (new ABI) wheel data:
#   { name, url, hash }
# When a FALSE cxx11abi (pre-cxx11 ABI) wheel also exists it is embedded as:
#   { name, url, hash, precx11abi = { name, url, hash }; }

{
  _version = "2.7.4";
  cu12 = {

    # ── torch 2.7 ─────────────────────────────────────────────────────────
    "2.7" = {
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.7.4.post1+cu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.4.post1/flash_attn-2.7.4.post1%2Bcu12torch2.7cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-LRgZBwUEtvnY8RfEU4FYNcZzCpCwGqJdyhP20rU8Px4=";
            precx11abi = {
              name = "flash_attn-2.7.4.post1+cu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.4.post1/flash_attn-2.7.4.post1%2Bcu12torch2.7cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-8Jko8sfk375u/KWpl4YomElSY8h6/mYsGPsZNusZLqs=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.7.4.post1+cu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.4.post1/flash_attn-2.7.4.post1%2Bcu12torch2.7cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-IgE7jHSmP8cOab4eEP8C5K2P7ISkNgC9yme0NO1BcRM=";
            precx11abi = {
              name = "flash_attn-2.7.4.post1+cu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.4.post1/flash_attn-2.7.4.post1%2Bcu12torch2.7cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-QrOKV8s+gLDbC4eSeTcedVK9Y9o7gNRhTnzO6LmDTic=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.7.4.post1+cu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.4.post1/flash_attn-2.7.4.post1%2Bcu12torch2.7cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-dOXyF0MLMBTbcP4IWwsOP0tDCc06JsWz2R8h9YruVAU=";
            precx11abi = {
              name = "flash_attn-2.7.4.post1+cu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.4.post1/flash_attn-2.7.4.post1%2Bcu12torch2.7cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-kFdMwe1MtR701/urfpRUFIx7lCg+J650TehsDSFEgyI=";
            };
          };
        };
      };
    };
  };
}
