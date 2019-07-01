let inherit (import ./helpers.nix) pkgs;
in pkgs.stdenv.mkDerivation {
  name = "run_all_the_things";
  buildInputs = [ pkgs.fd ];
  shellHook = ''
    it () {
      for f in $(${pkgs.fd}/bin/fd default.nix */); do
        echo $f
        cd $(dirname $f)
        nix-shell --pure --run it
        cd - > /dev/null
      done
    }
  '';
}
