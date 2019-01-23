let
  inherit (import ../../helpers.nix) pkgs leinFromGitHub;
  tesser = leinFromGitHub {
    name = "tesser";
    owner = "aphyr";
    repo = "tesser";
    rev = "b7b67dfaf25f1764c70c90dc6681dd333d24d6a4";
    sha256 = "1vma6ram4qs7llnfn84d4xvpn0q7kmzmkmsjpnkpqnryff9w2gvr";
    cd = "core";
  };
  matrix = leinFromGitHub {
    name = "matrix";
    owner = "mikera";
    repo = "core.matrix";
    rev = "f864c29d4e85d35de018295a87a295fc3df632a6";
    sha256 = "1dywj2av5rwnv7qhh09lpx9c2kx7wvgllwyssvyr75cb6fa6smvg";
    cd = ".";
    };
in
  pkgs.stdenv.mkDerivation rec {
    name = "fourier-transform.clj";
    buildInputs = [ pkgs.clojure pkgs.jdk ];
    shellHook = ''
      it () {
        ${pkgs.jdk}/bin/java \
          -cp ${tesser}:${matrix}:${pkgs.clojure}/share/java/clojure.jar \
          clojure.main ${name}
      }
    '';
  }
