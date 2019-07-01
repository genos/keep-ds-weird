let inherit (import ../../helpers.nix) pkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "parseLog.R";
  buildInputs = [ pkgs.R pkgs.rPackages.Ramble ];
  shellHook = ''
    it () {
      ${pkgs.R}/bin/Rscript ${name}
    }
  '';
}
