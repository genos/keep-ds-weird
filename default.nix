let inherit (import ./helpers.nix) pkgs;
in pkgs.stdenv.mkDerivation {
  name = "run_all_the_things";
  buildInputs = [ pkgs.fd pkgs.lolcat ];
  shellHook = ''
    it () {
      for f in $(${pkgs.fd}/bin/fd default.nix */); do
        echo $f | lolcat
        cd $(dirname $f)
        nix-shell --pure --run it
        cd - > /dev/null
      done
    }
  '';
}
