with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "diaconis.py";
  src = ./.;
  buildInputs = [ python36 python36Packages.numpy ];
  shellHook = ''
    it () {
      python3 ${./diaconis.py}
    }
  '';
}
