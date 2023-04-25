{
  description = "Min-Plus Semiring";

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
    in {
      packages.default = pkgs.writeShellApplication rec {
        name = "MinPlus.hs";
        runtimeInputs = [pkgs.ghc];
        text = ''
          runhaskell ${name}
        '';
      };
    });
}
