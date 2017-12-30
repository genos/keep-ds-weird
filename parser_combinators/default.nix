with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "ParseLog.hs";
  src = ./.;
  buildInputs = [ haskell.compiler.ghc822 ];
  shellHook = ''
    it () {
      runhaskell ${name}
    }
  '';
}
