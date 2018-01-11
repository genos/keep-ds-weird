with import <nixpkgs> {};
let
  leinFromGitHub = { name, owner, repo, rev, sha256, cd }:
  stdenv.mkDerivation {
    name = name;
    src = fetchFromGitHub {
      owner = owner;
      repo = repo;
      rev = rev;
      sha256 = sha256;
    };
    buildInputs = [ leiningen ];
    # https://blog.jeaye.com/2017/07/30/nixos-revisited/
    buildPhase = ''
        export LEIN_HOME=$PWD/.lein
        mkdir -p $LEIN_HOME
        echo "{:user {:local-repo \"$LEIN_HOME\"}}" > $LEIN_HOME/profiles.clj
        cd ${cd}
        LEIN_SNAPSHOTS_IN_RELEASE=1 ${leiningen}/bin/lein uberjar
    '';
    installPhase = ''
        cp target/${repo}*-standalone.jar $out
    '';
  };
  sbtFromGitHub = { name, owner, repo, rev, sha256 }:
  stdenv.mkDerivation {
    name = name;
    src = fetchFromGitHub {
      owner = owner;
      repo = repo;
      rev = rev;
      sha256 = sha256;
    };
    buildInputs = [ sbt scala ];
    # https://github.com/teozkr/Sbtix/blob/master/plugin/nix-exprs/sbtix.nix
    SBT_OPTS = ''
       -Dsbt.ivy.home=./.ivy2/
       -Dsbt.boot.directory=./.sbt/boot/
       -Dsbt.global.base=./.sbt
       -Dsbt.global.staging=./.staging
    '';
    buildPhase = ''
      ${sbt}/bin/sbt package
    '';
    installPhase = ''
      cp target/scala-*/*.jar $out
    '';
  };
in
  {
    leinFromGitHub = leinFromGitHub;
    sbtFromGitHub = sbtFromGitHub;
  }