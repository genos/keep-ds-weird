let
  inherit (import ../../helpers.nix) pkgs sbtFromGitHub;
  scalaParserCombinators = sbtFromGitHub {
    name = "scalaParserCombinators";
    owner = "scala";
    repo = "scala-parser-combinators";
    rev = "889495f76b09257467319d4da3867d00a1ba2263";
    sha256 = "1vpv6512wfh4jzwzhway4ajf1qwl3fjqkb99i3a69chdp0hdhly5";
  };
in pkgs.stdenv.mkDerivation rec {
  name = "ParseLog.sc";
  buildInputs = [ pkgs.scala ];
  shellHook = ''
    it () {
      ${pkgs.scala}/bin/scala -classpath "${scalaParserCombinators}" ${name}
    }
  '';
}
