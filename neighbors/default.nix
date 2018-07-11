with import <nixpkgs> {};
pkgs.stdenv.mkDerivation rec {
  name = "nearest_neighbors.py";
  buildInputs = [ python36 python36Packages.numpy ];
  shellHook = ''
    it () {
      ${python36}/bin/python3 ${name}
    }
  '';
}
