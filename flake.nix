{
  inputs = {
    # How to update the revision: `nix flake update --commit-lock-file`
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        formatter = pkgs.nixfmt-rfc-style;
        devShells.default =
          with pkgs;
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
              nixfmt-rfc-style
              vim

              dprint

              hugo
              go_1_22
              dart-sass
            ];
          };

        apps = {
          hugo-nix = {
            type = "app";
            program =
              with pkgs;
              lib.getExe (writeShellApplication {
                name = "hugo-with-dependencies";
                runtimeInputs = [
                  hugo
                  go_1_22
                  dart-sass
                ];
                text = ''
                  hugo "$@"
                '';
              });
          };
        };
      }
    );
}
