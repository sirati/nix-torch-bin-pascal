# WARNING: Auto-generated file. Do not edit manually!
# Source:  https://pypi.org/project/nvidia-cutlass-dsl/
# To regenerate: nix run .#default.nvidia-cutlass-dsl.gen-hashes [-- --tag 4.8.0.dev0]
#
# nvidia-cutlass-dsl 4.8.0.dev0 binary-wheel hashes.
#
# Structure:
#   meta = { name, url, hash }                  (metadata-only meta wheel)
#   base = pyVer -> os -> arch -> { name, url, hash }   (libs-base wheels)
#   cu12 = pyVer -> os -> arch -> { name, url, hash }   (libs-cu12, 4.6.0+)
#   cu13 = pyVer -> os -> arch -> { name, url, hash }   (libs-cu13, optional)
#   core = { name, url, hash }                  (libs-core frontend wheel, 4.6.0+)
#   nvdisasm = os -> arch -> { name, url, hash }   (nvidia-cuda-nvdisasm, 4.6.0+)

{
  _version = "4.8.0.dev0";
  meta = {
    name = "nvidia_cutlass_dsl-4.8.0.dev0-py3-none-any.whl";
    url = "https://files.pythonhosted.org/packages/9a/f3/e972434f058c0166a7dd4fe5b441805eef653d0579297ebf3ef78f4165c4/nvidia_cutlass_dsl-4.8.0.dev0-py3-none-any.whl";
    hash = "sha256-4eyqP9I747NYH8eeWa4TV9qQkloSCFZQqCWEEBaHaoQ=";
  };
  core = {
    name = "nvidia_cutlass_dsl_libs_core-4.8.0.dev0-py3-none-any.whl";
    url = "https://files.pythonhosted.org/packages/10/a0/5e4beaa3da5452fb68c0fc90355386c16848f6c08bdb0bc4934517a50008/nvidia_cutlass_dsl_libs_core-4.8.0.dev0-py3-none-any.whl";
    hash = "sha256-jLMV/gep//AAXEJudJilhjTExJiawVjpufaWfIAD+JQ=";
  };
  base = {
    py310 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp310-cp310-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/3a/e2/1e9b2aa7c4fb0f6228eb4df6efe841375c5d3350e88ec34f66cd48ac18e2/nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp310-cp310-manylinux_2_28_aarch64.whl";
          hash = "sha256-U3DxM27eA/TqH5IhZasuSRLaXPCOl6Mgav1lx90dyYI=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp310-cp310-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/6b/25/a8c1ed72bd673dc060e282a98327ae2b59bcded82a29d5a7fa768157cca7/nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp310-cp310-manylinux_2_28_x86_64.whl";
          hash = "sha256-jn0pi7eh5MW7EG71TVffE26gBQcCAOTwpBoqvAzrC/M=";
        };
      };
    };
    py311 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp311-cp311-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/1f/89/936bd0ce077d85affa829d6c825578f8fac65ff3a0b226dd5e0ef057d8d9/nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp311-cp311-manylinux_2_28_aarch64.whl";
          hash = "sha256-jeQQdndb7I2FihQphOqLYBj6+IdqS2hgUCb3hyS8FC0=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp311-cp311-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/99/32/a6c3acb7883752d3ee1d67b5cac712faec179b44216bb0392f5e5f4367cc/nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp311-cp311-manylinux_2_28_x86_64.whl";
          hash = "sha256-AEJVPYCcBObHT8UTidLXjWP1Be3NXAnvxI1SVZEJAjM=";
        };
      };
    };
    py312 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp312-cp312-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/57/44/6dd69ce88e7a9041fc31e17e14f6b57282e22b99863d1b7363da2a21834d/nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp312-cp312-manylinux_2_28_aarch64.whl";
          hash = "sha256-q0mW2WHEzmmq5xrzbvPXfjteVZNRIIwiMpDwtSwl/0g=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp312-cp312-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/b0/83/7128d78a07b2f3acf73057d92396787417e175ecf7726bfbca125360a9c9/nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp312-cp312-manylinux_2_28_x86_64.whl";
          hash = "sha256-ZzvuxhoU8SLGkwFj6IMK3s/ogET+SZj2mXSy/4gqAcc=";
        };
      };
    };
    py313 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp313-cp313-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/83/38/4c11a8e8ae7669748de5061f3d2d1ed943ba35c8a8fee9e09f988d6f97b0/nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp313-cp313-manylinux_2_28_aarch64.whl";
          hash = "sha256-RdTLFxTux65l1e2fq3gluqU2oLcpByb5d7mlGpwqqOA=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp313-cp313-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/69/24/3c3fba9b030c8ca35e08ebd7735ac34de0f621c7b39981044c32a88fe491/nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp313-cp313-manylinux_2_28_x86_64.whl";
          hash = "sha256-AP9Klc90PTcPHd/WbTuyLZrdng5D5Bn/hbmLxZmDxiU=";
        };
      };
    };
    py314 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp314-cp314-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/a3/c0/4ca348c5c73b1a51cc22a81784313783068a44de6da1bd123e3038bfd4f7/nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp314-cp314-manylinux_2_28_aarch64.whl";
          hash = "sha256-dAfgO+BzBKZiWkHY85WbOY2tTZ6bR1RhsY5kmE9HilQ=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp314-cp314-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/55/3e/e82f6df679375d54ea1863be4b5915fb2f93312dfe21e64ad79ac2ce8ffd/nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp314-cp314-manylinux_2_28_x86_64.whl";
          hash = "sha256-OzZ5MoupTXiA2sUAHCh3Ge8LR3+4vAOgeQaDz39GrU4=";
        };
      };
    };
    "py314-freethreaded" = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp314-cp314t-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/0f/49/fcaa882d4c2a32050e644f1c86aae9ae0f9d9f61a3abc2374510c249d89b/nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp314-cp314t-manylinux_2_28_aarch64.whl";
          hash = "sha256-DuHHFfstQhe5/GmpElzeBrt1+VjbuYmwBUd+nAKpJtM=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp314-cp314t-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/2d/57/5e1dc136a9ecc657760823d5a6a5e34372ed3b861cd0f4f924b06624a95c/nvidia_cutlass_dsl_libs_base-4.8.0.dev0-cp314-cp314t-manylinux_2_28_x86_64.whl";
          hash = "sha256-beWRdb3YwJGQt6EbokR6rUOwhEhcf5iZ6vlGu4ruryU=";
        };
      };
    };
  };
  cu12 = {
    py310 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp310-cp310-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/62/64/ddea14f985abf6a0c5452dcc231c05c185a4ffb940a2499c389b42d9b5fb/nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp310-cp310-manylinux_2_28_aarch64.whl";
          hash = "sha256-aEuyNvf8cZKmS/wlHCFkUX9jdJBTof1F+GYbL11JDPk=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp310-cp310-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/45/43/cffea56cbf4e9e736b114289aef64d53c9ceb3ad9b8b1ee9632616a1d649/nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp310-cp310-manylinux_2_28_x86_64.whl";
          hash = "sha256-VbotDUY/yJPhVRXx/bVCj+BXVz3kWuJnkFZoqNAFyHk=";
        };
      };
    };
    py311 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp311-cp311-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/34/ec/06d6d1f6ce7a20777160fdfc910f42d67b1fa3e0b0519f5120a18b8223fb/nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp311-cp311-manylinux_2_28_aarch64.whl";
          hash = "sha256-UidCmGTD4H3YyD8t/pxxrhRvqo+2Prid2iSpqN75hxY=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp311-cp311-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/00/4a/a3ee0552cb7cbf958472e0a1e893659e9d296975cbf4f16b83fa45603dc3/nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp311-cp311-manylinux_2_28_x86_64.whl";
          hash = "sha256-mxkOgepib1WjbeiVU3wAj0DaoZMm6uWnCwC34d/795Y=";
        };
      };
    };
    py312 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp312-cp312-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/62/50/802833042ecf4d66d4e857f3d03303f6a74dfd0eff9c6b2bfdad7d844784/nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp312-cp312-manylinux_2_28_aarch64.whl";
          hash = "sha256-KrtgKJp5C3j6aF268L4LqV/blsr+8v5RpxW7XCAwRK8=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp312-cp312-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/5a/9b/f86c2844bbfadcc45798fe56cb657e44bce343bb1af5a486ccf5ff016af2/nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp312-cp312-manylinux_2_28_x86_64.whl";
          hash = "sha256-nsq7nOXkGUvBgO2LqVNf4WGOGvm0EV5KT71q+FQ3O/0=";
        };
      };
    };
    py313 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp313-cp313-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/57/42/3fe2298e00979a0348f46a2e4d7c01d1d9725c36eda15815711cf0456723/nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp313-cp313-manylinux_2_28_aarch64.whl";
          hash = "sha256-Gof32U3QnFkcOIXumgOGaebLfjBC7tX17d8265yEUVk=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp313-cp313-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/f5/82/de384934a05bb96e9497454a0b870418c748da103c88305b81836c11d2ad/nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp313-cp313-manylinux_2_28_x86_64.whl";
          hash = "sha256-648z+liC+22eQknmTVMi5wDgfYDTGJD2jeDxwnm7ubw=";
        };
      };
    };
    py314 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp314-cp314-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/4d/9b/2d3829708260e1ee1ce76621400308d65e5fbacd2ea3463daadf5f96c99f/nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp314-cp314-manylinux_2_28_aarch64.whl";
          hash = "sha256-Es6BiXDQr7vPtBJoMjZdWemHRTwKuvpRkToBvAWhwDQ=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp314-cp314-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/ff/9f/1a451e905c2da8f7feced71c017034a9d4eaa10b24de7ef1fa8b23134cae/nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp314-cp314-manylinux_2_28_x86_64.whl";
          hash = "sha256-s/lSaTLf2PjcgwzIOgey6ih8D0KBVdqVa7IpH0/MjHo=";
        };
      };
    };
    "py314-freethreaded" = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp314-cp314t-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/27/15/b0c323e7529be25bafd50cf5785389617c0bc8e3a6fd30ed18f16a83a138/nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp314-cp314t-manylinux_2_28_aarch64.whl";
          hash = "sha256-6LVO+VPnxpC/InqsWz3sXY7DuojiIuFFHCwwgMBbWhw=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp314-cp314t-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/a1/a8/f9aed74b72ee2f891b9d1b32390b7e6af01ddb17659d4fc73cb3e099a250/nvidia_cutlass_dsl_libs_cu12-4.8.0.dev0-cp314-cp314t-manylinux_2_28_x86_64.whl";
          hash = "sha256-nguwkOy6REGQdPZChhW0P6TpYvf190h425UZ8I0NTxM=";
        };
      };
    };
  };
  cu13 = {
    py310 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp310-cp310-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/45/04/4d15e288f51212c144f7d840d231de2ff4a40150d96d9d42ded72b813edb/nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp310-cp310-manylinux_2_28_aarch64.whl";
          hash = "sha256-58qUGhzO69HRIsLIiep1TmF9Ol1zGiFrZzehxhP2Lrk=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp310-cp310-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/19/ce/75f2c51e13b82b58c63540eca3fd3672fd8f87b94f1455922f2fa97b136b/nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp310-cp310-manylinux_2_28_x86_64.whl";
          hash = "sha256-Z9BEMz9SCuEpsN3fKVnLbxRk1urpM1MGh2TKco2ILTw=";
        };
      };
    };
    py311 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp311-cp311-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/9a/e6/69b3db5016f6bf88951d71bffa5f875f810c025af2757f12af0ba71901a9/nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp311-cp311-manylinux_2_28_aarch64.whl";
          hash = "sha256-gKU53sE+WSrHXMY2KjPuJsJZ8hF+fJwzVZLqA4OxcmI=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp311-cp311-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/02/92/b8a3f523924b91fe0077f9389bb6213e27794f83adbb541412be56d9f9ba/nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp311-cp311-manylinux_2_28_x86_64.whl";
          hash = "sha256-nk+74PSCYN4FaPwE/TFgRyEtAnA1LXePNIZCHyfYTMI=";
        };
      };
    };
    py312 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp312-cp312-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/fa/db/dddbb3de14de18443a5416f4f46fffa77da2e5177b75d3a6b34b7280d024/nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp312-cp312-manylinux_2_28_aarch64.whl";
          hash = "sha256-xgEqXK5gsPYEX7Tc3oD6KNMoFjFNKdqS1IPK29R3xl4=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp312-cp312-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/e3/5d/b0b24f1d27d5eeff754703b6c164e86fce99e09b17cd80ad44ed62e26795/nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp312-cp312-manylinux_2_28_x86_64.whl";
          hash = "sha256-3yBUKcmsWMzIRqdEzgq4hwW0YLDLkdCsJ+QIMS1hAAk=";
        };
      };
    };
    py313 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp313-cp313-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/21/d5/7394de360dc4d14d75247d3353caa8b1b9cd4176f46e6a7d33b75ee2bcce/nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp313-cp313-manylinux_2_28_aarch64.whl";
          hash = "sha256-sTPa1QXEd4/57l0dk3nlsN+L/gQWZ4JlK7G2clxtwQs=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp313-cp313-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/e9/ca/4d8207a874a9252ec03203949ee091272994c17f3afd3a3ec4dd38eff67e/nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp313-cp313-manylinux_2_28_x86_64.whl";
          hash = "sha256-ZY7GqMen7VY9E8n2LTJb7BqjEypc3B+9kXlkqpRG+Bo=";
        };
      };
    };
    py314 = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp314-cp314-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/6a/06/cd605ee0a69986fbeee6ee6c41c7390f7cff73b147857c9d7e09844c76af/nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp314-cp314-manylinux_2_28_aarch64.whl";
          hash = "sha256-dtmFmTnKXSbhZQq/7gmmdJq3VJn03si9VHifO/i6fGk=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp314-cp314-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/14/8f/71c93e1fe401c9a13dcdfc09cafc25d4049fb352c8306ed2a525803c78e2/nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp314-cp314-manylinux_2_28_x86_64.whl";
          hash = "sha256-0RAU8hsFomNC/AG7PDK2cGyCABfqT8F07QOeBRIOik0=";
        };
      };
    };
    "py314-freethreaded" = {
      linux = {
        aarch64 = {
          name = "nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp314-cp314t-manylinux_2_28_aarch64.whl";
          url = "https://files.pythonhosted.org/packages/f3/ff/124bca20e409a822df6a59c1af33884b8ff9c22623dcedc7be2367cc34fa/nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp314-cp314t-manylinux_2_28_aarch64.whl";
          hash = "sha256-3vHAfvoTnW0AUGpDWra7plL9+Cfm6Q8aQk2c5NDZnkc=";
        };
        x86_64 = {
          name = "nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp314-cp314t-manylinux_2_28_x86_64.whl";
          url = "https://files.pythonhosted.org/packages/b5/10/8998d7bc5f7e173181a3065a4d2887e44cab3c3e59620001771985fef561/nvidia_cutlass_dsl_libs_cu13-4.8.0.dev0-cp314-cp314t-manylinux_2_28_x86_64.whl";
          hash = "sha256-JLFxXOjSqPd6ejRtDTTxH1ozopsspnMH4i/agdwiZVE=";
        };
      };
    };
  };
  nvdisasm = {
    linux = {
      aarch64 = {
        name = "nvidia_cuda_nvdisasm-13.3.73-py3-none-manylinux2014_aarch64.manylinux_2_17_aarch64.whl";
        url = "https://files.pythonhosted.org/packages/92/be/e9de501cb71b10f7654381a485fa4ebf470ea25c3dce018cccaecf8a8f9a/nvidia_cuda_nvdisasm-13.3.73-py3-none-manylinux2014_aarch64.manylinux_2_17_aarch64.whl";
        hash = "sha256-3UdRiE+QFrm22/AHq961aB0KLtxzHdPS/anW2Hjoj3M=";
      };
      x86_64 = {
        name = "nvidia_cuda_nvdisasm-13.3.73-py3-none-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
        url = "https://files.pythonhosted.org/packages/86/3e/88460ebd737e559e8e9843db7a63f8ced9ec7be1882344438819dd13aebc/nvidia_cuda_nvdisasm-13.3.73-py3-none-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
        hash = "sha256-+hcISwfA3KaKQokvdxtLG0D76bkWYCCWI+Yc6mEcrow=";
      };
    };
  };
}
