{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Import the torch override with CUDA 12.6 support
  torchWithCuda126 = import ./torch-bin-cu126/override.nix {
    inherit pkgs;
    cudaPackages = pkgs.cudaPackages_12_6;
  };

  # Helper function to trace values with proper type handling (recursive)
  traceValue = name: value:
    let
      serializeValue = v:
        let
          vType = builtins.typeOf v;
          output = if vType == "list" then builtins.toJSON (map serializeValue v)
            else if vType == "set" then
              if v ? outPath then toString v
              else if v ? pname then v.pname
              else if v ? name then v.name
              else builtins.toJSON (builtins.attrNames v)
            else if vType == "bool" then toString v
            else if vType == "null" then "null"
            else if vType == "int" then toString v
            else if vType == "string" then v
            else toString v;
        in
          "(type ${vType}) ${output}";
    in
      builtins.trace "${name}: ${serializeValue value}" value;

in
{
  # Apply overlay to all Python package sets
  overlays = [
    (final: prev: {
      python313Packages = prev.python313Packages.overrideScope (pyFinal: pyPrev: {
        torch-bin-cuda-126 = import ./torch-bin-cu126/override.nix {
          pkgs = final;
          cudaPackages = final.cudaPackages_12_6;
        };
      });
      python312Packages = prev.python312Packages.overrideScope (pyFinal: pyPrev: {
        torch-bin-cuda-126 = import ./torch-bin-cu126/override.nix {
          pkgs = final;
          cudaPackages = final.cudaPackages_12_6;
        };
      });
      python311Packages = prev.python311Packages.overrideScope (pyFinal: pyPrev: {
        torch-bin-cuda-126 = import ./torch-bin-cu126/override.nix {
          pkgs = final;
          cudaPackages = final.cudaPackages_12_6;
        };
      });
      python310Packages = prev.python310Packages.overrideScope (pyFinal: pyPrev: {
        torch-bin-cuda-126 = import ./torch-bin-cu126/override.nix {
          pkgs = final;
          cudaPackages = final.cudaPackages_12_6;
        };
      });
    })
  ];

  languages = {
    python = {
      enable = true;
      version = "3.13";
      #package = pkgs.python313;
    };
  };

  # Add torch and CUDA packages
  packages = with pkgs; [
  ] ++ (with pkgs.python313Packages; [
    torch-bin-cuda-126
  ]);

  # Configure Cachix caches
  cachix = {
    pull = [ "cuda-maintainers" ];
  };


}
