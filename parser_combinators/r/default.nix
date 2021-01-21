let inherit (import ../../pkgs.nix) pkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "parseLog.R";
  buildInputs = [ pkgs.R pkgs.rPackages.Ramble pkgs.rPackages.tidyverse ];
  shellHook = ''
    it () {
      Rscript ${name}
    }
  '';
}
