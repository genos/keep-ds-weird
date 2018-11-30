with import <nixpkgs> {};
pkgs.stdenv.mkDerivation rec {
  name = "generate_data.py";
  buildInputs = [ python37 ];
  output = "data.log";
  shellHook = ''
    it () {
      ${python37}/bin/python3 ${name} > ${output}
    }
  '';
}
