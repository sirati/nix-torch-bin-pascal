# inject-wrappers.nix
#
# Injects retry wrappers into any derivation via overrideAttrs.
#
# Type:  wrappers -> drv -> drv
#
# The returned derivation is identical to the input except that:
#   • wrappers is prepended to nativeBuildInputs
#   • ${wrappers}/bin is prepended to PATH in both preConfigure and preBuild
#
# One-liner usage at call sites:
#   # (import ../../nix-retry-wrapper/inject-wrappers.nix wrappers) base

wrappers: drv:
drv.overrideAttrs (old: {
  nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ wrappers ];
  preConfigure      = ''export PATH="${wrappers}/bin:$PATH"'' + "\n" + (old.preConfigure or "");
  preBuild          = ''export PATH="${wrappers}/bin:$PATH"'' + "\n" + (old.preBuild     or "");
})
