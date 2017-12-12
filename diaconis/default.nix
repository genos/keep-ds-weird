with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "diaconis.clj";
  src = ./.;
  buildInputs = [ boot ];
  shellHook = ''
    it () {
      boot -q -f ${./diaconis.clj}
    }
  '';
}
