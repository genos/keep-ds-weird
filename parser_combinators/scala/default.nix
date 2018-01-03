with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "ParseLog.sc";
  buildInputs = [ ammonite ];
  shellHook = ''
    it () {
      amm ${name}
    }
  '';
}
