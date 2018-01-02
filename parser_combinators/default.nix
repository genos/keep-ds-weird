with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "generate_data.py";
  buildInputs = [ python36 ];
  shellHook = ''
    it () {
      python3 ${name} > input.log
    }
  '';
}
