{
  inputs = {
    # How to update the revision: `nix flake update --commit-lock-file`
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    edge-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, edge-nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        edge-pkgs = edge-nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = with pkgs;
          mkShell {
            buildInputs = [
              # https://github.com/NixOS/nix/issues/730#issuecomment-162323824
              bashInteractive

              gnumake
              coreutils
              peco
              yamlfmt
              typos
              imagemagick
              actionlint
              nil
              nixpkgs-fmt
              vim

              edge-pkgs.hugo
              edge-pkgs.go_1_22
              edge-pkgs.dprint
            ];
          };
      });
}
