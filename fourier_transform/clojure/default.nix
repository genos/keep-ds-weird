let
  inherit (import ../../helpers.nix) pkgs leinFromGitHub;
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
    cd = ".";
  };
in pkgs.stdenv.mkDerivation rec {
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
