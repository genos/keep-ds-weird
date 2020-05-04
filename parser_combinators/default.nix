let inherit (import ../pkgs.nix) pkgs;
in pkgs.stdenv.mkDerivation rec {
  name = "generate_data.py";
  buildInputs = [ pkgs.python38 ];
  output = "data.log";
  shellHook = ''
    it () {
      python3 ${name} > ${output}
    }
  '';
}
