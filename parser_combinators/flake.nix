{
  description = "Data Generation";

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
      output = "data.log";
      python = pkgs.python311;
    in {
      packages.default = pkgs.writeShellApplication rec {
        name = "generate_data.py";
        text = ''
          ${python}/bin/python3 ${name} > ${output}
        '';
      };
    });
}
