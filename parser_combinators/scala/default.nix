with import <nixpkgs> {};
let
  buildSbtFromGitHub = { name, owner, repo, rev, sha256 } :
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
  scalaParserCombinators = buildSbtFromGitHub {
    name = "scalaParserCombinators";
    owner = "scala";
    repo = "scala-parser-combinators";
    rev = "16b7c0c78e419fefd73d161fdd52ee6ad3f644cf";
    sha256 = "1mjy1q96kc16dp3f6088l86aw6kl162dww2brq0ymszxd6j674s0";
  };
in
  stdenv.mkDerivation rec {
    name = "ParseLog.sc";
    buildInputs = [ scala ];
    shellHook = ''
      it () {
        scala -classpath "${scalaParserCombinators}" ${name}
      }
    '';
  }
