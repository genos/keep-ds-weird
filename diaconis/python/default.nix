with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "diaconis.py";
  buildInputs = [ python36 python36Packages.numpy ];
  shellHook = ''
    it () {
      python3 ${name}
    }
  '';
}
