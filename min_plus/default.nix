with import <nixpkgs> {};
pkgs.stdenv.mkDerivation rec {
  name = "MinPlus.hs";
  buildInputs = [ haskell.compiler.ghc863 ];
  shellHook = ''
    it () {
      ${haskell.compiler.ghc863}/bin/runhaskell ${name}
    }
  '';
}
