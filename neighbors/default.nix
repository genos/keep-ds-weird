with import <nixpkgs> {};
pkgs.stdenv.mkDerivation rec {
  name = "nearest_neighbors.py";
  buildInputs = [ python37 python37Packages.numpy ];
  shellHook = ''
    it () {
      ${python37}/bin/python3 ${name}
    }
  '';
}
