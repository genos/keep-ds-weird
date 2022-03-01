let inherit (import ../../pkgs.nix) pkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "fourier_transform.py";
  buildInputs = [ pkgs.python310 pkgs.python310Packages.numpy ];
  shellHook = ''
    it () {
      python3 ${name}
    }
  '';
}
