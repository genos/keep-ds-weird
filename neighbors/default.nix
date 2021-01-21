let inherit (import ../pkgs.nix) pkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "nearest_neighbors.py";
  buildInputs = [ pkgs.python39 pkgs.python39Packages.numpy ];
  shellHook = ''
    it () {
      python3 ${name}
    }
  '';
}
