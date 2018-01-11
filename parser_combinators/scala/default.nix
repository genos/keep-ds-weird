with import ../../common.nix;
with pkgs;
let
  scalaParserCombinators = sbtFromGitHub {
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
        ${scala}/bin/scala -classpath "${scalaParserCombinators}" ${name}
      }
    '';
  }
