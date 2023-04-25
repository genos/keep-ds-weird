{
  description = "Keep Data Science Weird";

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
      formatter = pkgs.alejandra;
      apps.${system}.default = {
        type = "app";
        program = "${self}.packages/bin/run";
      };
      packages.default = pkgs.writeScriptBin "run" ''
        for f in $(fd flake.nix */); do
          echo $f | lolcat
          pushd $(dirname $f) > /dev/null
          nix run
          popd > /dev/null
        done
      '';
    });
}
