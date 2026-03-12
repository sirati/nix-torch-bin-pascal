{ pkgs }:

let
  devPythonPackages = python-pkgs: with python-pkgs; [
    pip
    ruff
  ];

  devPackages = with pkgs; [
    basedpyright
    nil
    nixd
    vscode-json-languageserver
    bash-language-server
    basedpyright
  ];

  makeShell = { pascal, deploymentPythonPackages, deploymentPackages }: pkgs.mkShell {
    packages = [
      (pkgs.python313.withPackages (
        python-pkgs: (deploymentPythonPackages pascal python-pkgs) ++ (devPythonPackages python-pkgs)
      ))
    ]
    ++ deploymentPackages
    ++ devPackages;

  };

in
{
  inherit makeShell;
}
