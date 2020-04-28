let inherit (import ../helpers.nix) pkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "generate_data.py";
  buildInputs = [ pkgs.python38 ];
  output = "data.log";
  shellHook = ''
    it () {
      ${pkgs.python38}/bin/python3 ${name} > ${output}
    }
  '';
}
