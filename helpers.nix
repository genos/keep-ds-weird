let
  makeLeinFromGitHub = pkgs: { name, owner, repo, rev, sha256, cd }:
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
  makeSbtFromGitHub = pkgs: { name, owner, repo, rev, sha256 }:
  pkgs.stdenv.mkDerivation {
    name = name;
    src = pkgs.fetchFromGitHub {
      owner = owner;
      repo = repo;
      rev = rev;
      sha256 = sha256;
    };
    buildInputs = [ pkgs.sbt ];
    # https://github.com/teozkr/Sbtix/blob/master/plugin/nix-exprs/sbtix.nix
    SBT_OPTS = ''
       -Dsbt.ivy.home=./.ivy2/
       -Dsbt.boot.directory=./.sbt/boot/
       -Dsbt.global.base=./.sbt
       -Dsbt.global.staging=./.staging
    '';
    buildPhase = ''
      ${pkgs.sbt}/bin/sbt package
    '';
    installPhase = ''
      cp target/scala-*/*.jar $out
    '';
  };
in
  {
    makeLeinFromGitHub = makeLeinFromGitHub;
    makeSbtFromGitHub  = makeSbtFromGitHub;
  }
