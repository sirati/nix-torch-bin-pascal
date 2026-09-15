# FA2 wheels vendor an older FA4 tree. Keep the native extension unchanged
# while giving the separately versioned flash-attn4 package sole ownership.
{ pkgs, package }:
pkgs.stdenvNoCC.mkDerivation (finalAttrs: let
  # Concretise stamps the final name. Apply that same stamp to the original
  # package so splitting the namespace reuses the existing compiled output.
  nativePackage = package.overrideAttrs (_: { name = finalAttrs.name; });
  python = pkgs.python3;
in {
  inherit (package) name pname version meta;
  propagatedBuildInputs = package.propagatedBuildInputs or [ ];
  passthru = (package.passthru or { }) // {
    inherit (package) pythonModule;
    originalNativePackage = nativePackage;
  };
  buildCommand = ''
    mkdir -p "$out"
    ${pkgs.lndir}/bin/lndir -silent ${nativePackage} "$out"
    ${python.interpreter} ${./split_namespace.py} "$out/${python.sitePackages}"
  '';
})
