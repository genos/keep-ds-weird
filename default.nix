let inherit (import ./pkgs.nix) pkgs;
in pkgs.stdenv.mkDerivation {
  name = "run_all_the_things";
  buildInputs = [ pkgs.fd pkgs.lolcat pkgs.nix ];
  shellHook = ''
    it () {
      for f in $(fd default.nix */); do
        echo $f | lolcat
        cd $(dirname $f)
        nix-shell --pure --run it
        cd - > /dev/null
      done
    }
  '';
}
