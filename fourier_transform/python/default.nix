with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "fourier_transform.py";
  buildInputs = [ python36 python36Packages.numpy ];
  shellHook = ''
    it () {
      ${python36}/bin/python3 ${name}
    }
  '';
}
