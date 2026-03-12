# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://github.com/Dao-AILab/flash-attention/releases
# To regenerate: nix run .#default.flash-attn.gen-hashes [-- --skip-source --tag v2.7.3]
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
  _version = "2.7.3";
  cu12 = {

    # ── torch 2.8 ─────────────────────────────────────────────────────────
    "2.8" = {
      py310 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.7.3+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.3/flash_attn-2.7.3%2Bcu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl";
            hash = "sha256-jFINYJP5EVLcj9oemvdmF9x9GND/NMz87YUirws4Bmo=";
            precx11abi = {
              name = "flash_attn-2.7.3+cu12torch2.8cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.3/flash_attn-2.7.3%2Bcu12torch2.8cxx11abiFALSE-cp310-cp310-linux_x86_64.whl";
              hash = "sha256-T5l6xsmL3cCL9IqUYtQ67knSxSkAV7OWkhKLrbKLH8I=";
            };
          };
        };
      };
      py311 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.7.3+cu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.3/flash_attn-2.7.3%2Bcu12torch2.8cxx11abiTRUE-cp311-cp311-linux_x86_64.whl";
            hash = "sha256-qwZBi0BdKU44N/tnTr5GoNbziGf7zXADlUQHkbzfNrs=";
            precx11abi = {
              name = "flash_attn-2.7.3+cu12torch2.8cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.3/flash_attn-2.7.3%2Bcu12torch2.8cxx11abiFALSE-cp311-cp311-linux_x86_64.whl";
              hash = "sha256-jjQ9VAZIz89RwBzXVdf4gyONAnQE8mmCITOZCelzKlw=";
            };
          };
        };
      };
      py312 = {
        linux = {
          x86_64 = {
            name = "flash_attn-2.7.3+cu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.3/flash_attn-2.7.3%2Bcu12torch2.8cxx11abiTRUE-cp312-cp312-linux_x86_64.whl";
            hash = "sha256-Vnvdyub3wTP9lkvtmYiSb+equt21i/YqdEsveCp9Qmk=";
            precx11abi = {
              name = "flash_attn-2.7.3+cu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              url = "https://github.com/Dao-AILab/flash-attention/releases/download/v2.7.3/flash_attn-2.7.3%2Bcu12torch2.8cxx11abiFALSE-cp312-cp312-linux_x86_64.whl";
              hash = "sha256-wAv981Y8b+l8UCVKFTz7fY2fQrc/BrAKdTy9wJveJhA=";
            };
          };
        };
      };
    };
  };
}
