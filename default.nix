with import <nixpkgs> {};
pkgs.stdenv.mkDerivation rec {
  name = "run_all_the_things";
  shellHook = ''
    it () {
      for f in $(find . -mindepth 2 -name default.nix -print | sort); do
        echo $f
        cd $(dirname $f)
        nix-shell --pure --run it
        cd - > /dev/null
      done
    }
  '';
}
