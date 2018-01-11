with import ../../common.nix;
with pkgs;
stdenv.mkDerivation rec {
  name = "parseLog.R";
  buildInputs = [ R rPackages.Ramble ];
  shellHook = ''
    it () {
      ${R}/bin/Rscript ${name}
    }
  '';
}
