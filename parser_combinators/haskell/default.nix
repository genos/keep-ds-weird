with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "ParseLog.hs";
  buildInputs = [ haskell.compiler.ghc822 ];
  shellHook = ''
    it () {
      ${haskell.compiler.ghc822}/bin/runhaskell ${name}
    }
  '';
}
