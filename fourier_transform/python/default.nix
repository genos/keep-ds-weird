let
  inherit (import ../../helpers.nix) pkgs;
in
  pkgs.stdenv.mkDerivation rec {
    name = "fourier_transform.py";
    buildInputs = [ pkgs.python37 pkgs.python37Packages.numpy ];
    shellHook = ''
      it () {
        ${pkgs.python37}/bin/python3 ${name}
      }
    '';
  }
