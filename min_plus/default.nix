with import <nixpkgs> {};
pkgs.stdenv.mkDerivation rec {
  name = "MinPlus.hs";
  buildInputs = [ haskell.compiler.ghc844 ];
  shellHook = ''
    it () {
      ${haskell.compiler.ghc844}/bin/runhaskell ${name}
    }
  '';
}
