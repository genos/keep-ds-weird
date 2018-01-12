with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "MinPlus.hs";
  buildInputs = [ haskell.compiler.ghc822 ];
  shellHook = ''
    it () {
      ${haskell.compiler.ghc822}/bin/runhaskell ${name}
    }
  '';
}
