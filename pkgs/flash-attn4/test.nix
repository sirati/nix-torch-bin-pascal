{ pkgs, pytorchScope, concretise }:
concretise {
  inherit pkgs;
  mlPackages = with pytorchScope; [ torch flash-attn flash-attn4 ];
  python = "3.13";
  cuda = "12.8";
  torch = "2.10";
  allowBuildingFromSource = true;
}
