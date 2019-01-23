let
  inherit (import ../helpers.nix) pkgs;
in
  pkgs.stdenv.mkDerivation rec {
    name = "MinPlus.hs";
    buildInputs = [ pkgs.ghc ];
    shellHook = ''
      it () {
        ${pkgs.ghc}/bin/runhaskell ${name}
      }
    '';
  }
