with import <nixpkgs> {};
let
  tesser = stdenv.mkDerivation {
    name = "tesser";
    src = fetchFromGitHub {
      owner = "aphyr";
      repo = "tesser";
      rev = "b7b67dfaf25f1764c70c90dc6681dd333d24d6a4";
      sha256 = "1vma6ram4qs7llnfn84d4xvpn0q7kmzmkmsjpnkpqnryff9w2gvr";
    };
    buildInputs = [ leiningen ];
    buildPhase = ''
      # https://blog.jeaye.com/2017/07/30/nixos-revisited/
      # For leiningen
      export HOME=$PWD
      export LEIN_HOME=$HOME/.lein
      mkdir -p $LEIN_HOME
      echo "{:user {:local-repo \"$LEIN_HOME\"}}" > $LEIN_HOME/profiles.clj
      cd core
      LEIN_SNAPSHOTS_IN_RELEASE=1 ${leiningen}/bin/lein uberjar
    '';
    installPhase = ''
      cp target/tesser.core-*-standalone.jar $out
    '';
  };
  matrix = stdenv.mkDerivation {
    name = "matrix";
    src = fetchFromGitHub {
      owner = "mikera";
      repo = "core.matrix";
      rev = "f864c29d4e85d35de018295a87a295fc3df632a6";
      sha256 = "1dywj2av5rwnv7qhh09lpx9c2kx7wvgllwyssvyr75cb6fa6smvg";
    };
    buildInputs = [ leiningen ];
    buildPhase = ''
      # https://blog.jeaye.com/2017/07/30/nixos-revisited/
      # For leiningen
      export HOME=$PWD
      export LEIN_HOME=$HOME/.lein
      mkdir -p $LEIN_HOME
      echo "{:user {:local-repo \"$LEIN_HOME\"}}" > $LEIN_HOME/profiles.clj
      ${leiningen}/bin/lein uberjar
    '';
    installPhase = ''
      cp target/core.matrix-*-SNAPSHOT-standalone.jar $out
    '';
  };
in
  stdenv.mkDerivation {
    name = "diaconis.clj";
    src = ./.;
    buildInputs = [ clojure jdk ];
    shellHook = ''
      it () {
        ${jdk}/bin/java -cp ${tesser}:${matrix}:${clojure}/share/java/clojure.jar clojure.main ${./diaconis.clj}
      }
    '';
  }
