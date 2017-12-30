with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "nearest_neighbors.py";
  buildInputs = [ python36 python36Packages.numpy ];
  shellHook = ''
    it () {
      python3 ${name}
    }
  '';
}
