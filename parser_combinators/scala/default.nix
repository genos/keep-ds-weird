let inherit (import ../../pkgs.nix) pkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "ParseLog.scala";
  buildInputs = [ pkgs.ammonite ];
  shellHook = ''
    it () {
      amm ${name}
    }
  '';
}
