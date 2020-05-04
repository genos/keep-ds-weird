let inherit (import ../pkgs.nix) pkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "nearest_neighbors.py";
  buildInputs = [ pkgs.python38 pkgs.python38Packages.numpy ];
  shellHook = ''
    it () {
      python3 ${name}
    }
  '';
}
