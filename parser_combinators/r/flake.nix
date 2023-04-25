{
  description = "R Parser Combinator";

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
      r = pkgs.rWrapper.override {packages = with pkgs.rPackages; [Ramble];};
    in {
      packages.default = pkgs.writeShellApplication rec {
        name = "parseLog.R";
        text = ''
          ${r}/bin/Rscript ${name}
        '';
      };
    });
}
