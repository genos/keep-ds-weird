let inherit (import ../../pkgs.nix) pkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "fourier_transform.py";
  buildInputs = [ pkgs.python39 pkgs.python39Packages.numpy ];
  shellHook = ''
    it () {
      python3 ${name}
    }
  '';
}
