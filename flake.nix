{
  inputs = {
    # How to update the revision: `nix flake update --commit-lock-file`
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = with pkgs;
          mkShell {
            buildInputs = [
              # https://github.com/NixOS/nix/issues/730#issuecomment-162323824
              bashInteractive

              hugo
              go_1_21
              gnumake
              coreutils
              peco
              typos
              dprint
              yamlfmt
              imagemagick
              actionlint
              nil
              nixpkgs-fmt
              vim
            ];
          };
      });
}
