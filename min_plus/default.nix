let inherit (import ../pkgs.nix) pkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "MinPlus.hs";
  buildInputs = [ pkgs.ghc ];
  shellHook = ''
    it () {
      runhaskell ${name}
    }
  '';
}
