{
  description = "Nearest Neighbors Numpy";

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
      python = pkgs.python311.withPackages (ps: with ps; [ps.numpy]);
    in {
      packages.default = pkgs.writeShellApplication rec {
        name = "nearest_neighbors.py";
        text = ''
          ${python}/bin/python3 ${name}
        '';
      };
    });
}
