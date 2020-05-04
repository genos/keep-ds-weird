let
  inherit (import ../../pkgs.nix) pkgs;
  leinFromGitHub = { name, owner, repo, rev, sha256, cd ? "." }:
    pkgs.stdenv.mkDerivation {
      name = name;
      src = pkgs.fetchFromGitHub {
        owner = owner;
        repo = repo;
        rev = rev;
        sha256 = sha256;
      };
      buildInputs = [ pkgs.leiningen ];
      # https://blog.jeaye.com/2017/07/30/nixos-revisited/
      buildPhase = ''
        export LEIN_HOME=$PWD/.lein
        mkdir -p $LEIN_HOME
        echo "{:user {:local-repo \"$LEIN_HOME\"}}" > $LEIN_HOME/profiles.clj
        cd ${cd}
        LEIN_SNAPSHOTS_IN_RELEASE=1 ${pkgs.leiningen}/bin/lein uberjar
      '';
      installPhase = ''
        cp target/${repo}*-standalone.jar $out
      '';
    };
  tesser = leinFromGitHub {
    name = "tesser";
    owner = "aphyr";
    repo = "tesser";
    rev = "f3b92c56fa47d02bd57ed816289dcc6250814173"; # release 1.0.3
    sha256 = "1b1zx09b0q7k0fgcv7g9ryfl90d91bamis3lcbwhr9x2bk47bjz5";
    cd = "core";
  };
  matrix = leinFromGitHub {
    name = "matrix";
    owner = "mikera";
    repo = "core.matrix";
    rev = "b69ff31bf1da73a7210f7f9c6f6dd62f325f7d16"; # release 0.62.0
    sha256 = "0033704l7h4hgnjhncwkv79nfph60cshm1nvbmk5qx6dml3wfzl3";
  };
in pkgs.stdenv.mkDerivation rec {
  name = "fourier-transform.clj";
  buildInputs = [ pkgs.clojure pkgs.jdk ];
  shellHook = ''
    it () {
      java -cp ${tesser}:${matrix} clojure.main ${name}
    }
  '';
}
