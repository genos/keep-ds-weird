with import ../common.nix;
with pkgs;
stdenv.mkDerivation rec {
  name = "generate_data.py";
  buildInputs = [ python36 ];
  output = "data.log";
  shellHook = ''
    it () {
      python3 ${name} > ${output}
    }
  '';
}
