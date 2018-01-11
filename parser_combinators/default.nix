with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "generate_data.py";
  buildInputs = [ python36 ];
  output = "data.log";
  shellHook = ''
    it () {
      ${python36}/bin/python3 ${name} > ${output}
    }
  '';
}
