let
  inherit (import ../../helpers.nix) pkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "ParseLog.scala";
  buildInputs = [ pkgs.ammonite ];
  shellHook = ''
    it () {
      ${pkgs.ammonite}/bin/amm ${name}
    }
  '';
}
