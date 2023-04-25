{
  description = "Fourier Transform in Python";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      leinFromGitHub = {
        name,
        owner,
        repo,
        rev,
        sha256,
        cd ? ".",
      }:
        pkgs.stdenv.mkDerivation {
          name = name;
          src = pkgs.fetchFromGitHub {
            owner = owner;
            repo = repo;
            rev = rev;
            sha256 = sha256;
          };
          buildInputs = [pkgs.leiningen];
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
        rev = "d82895390264d8f6bf012fa4053a2003a500b574"; # release 1.0.4
        sha256 = "0k2shy6ccig00lc9y6y8lyh7bnd250xxp5nh8fz254f2kq8ib4mn";
        cd = "core";
      };
      matrix = leinFromGitHub {
        name = "matrix";
        owner = "mikera";
        repo = "core.matrix";
        rev = "07cb88b1b43ccc07f3f7e8634e1eccdb6986049b"; # develop branch as of 2021-11-19
        sha256 = "1dn5hy5mdgl2bcmav8qll3qxqbscb340c462kkj728sfpk4ch5xd";
      };
    in {
      packages.default = pkgs.writeShellApplication rec {
        name = "fourier-transform.clj";
        runtimeInputs = [pkgs.clojure pkgs.jdk];
        text = ''
          java -cp ${tesser}:${matrix} clojure.main ${name}
        '';
      };
    });
}
