let inherit (import ../helpers.nix) pkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "generate_data.py";
  buildInputs = [ pkgs.python37 ];
  output = "data.log";
  shellHook = ''
    it () {
      ${pkgs.python37}/bin/python3 ${name} > ${output}
    }
  '';
}
