let
  pkgs = import
    (fetchTarball "https://github.com/NixOS/nixpkgs/archive/20.03.tar.gz") { };
in {
  leinFromGitHub = { name, owner, repo, rev, sha256, cd }:
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
  pkgs = pkgs;
}
