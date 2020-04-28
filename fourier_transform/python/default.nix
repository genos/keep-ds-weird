let inherit (import ../../helpers.nix) pkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "fourier_transform.py";
  buildInputs = [ pkgs.python38 pkgs.python38Packages.numpy ];
  shellHook = ''
    it () {
      ${pkgs.python38}/bin/python3 ${name}
    }
  '';
}
