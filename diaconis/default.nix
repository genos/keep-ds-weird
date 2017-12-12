with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "diaconis.clj";
  src = ./.;
  buildInputs = [ clojure ];
  shellHook = ''
    it() {
      clojure ${./diaconis.clj}
    }
  '';
}
