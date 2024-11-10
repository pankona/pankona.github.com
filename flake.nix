{
  inputs = {
    # How to update the revision: `nix flake update --commit-lock-file`
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            # Realize nixd pkgs version inlay hints for stable channel instead of latest
            NIX_PATH = "nixpkgs=${pkgs.path}";

            buildInputs = with pkgs; [
              # https://github.com/NixOS/nix/issues/730#issuecomment-162323824
              bashInteractive
              coreutils
              findutils # xargs
              nixfmt-rfc-style
              nixd

              gnumake
              peco
              typos
              imagemagick
              actionlint
              vim

              dprint

              hugo
              go_1_22
              dart-sass

              markdownlint-cli2
            ];
          };
        }
      );

      apps = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          hugo-nix = {
            type = "app";
            program = pkgs.lib.getExe (
              pkgs.writeShellApplication {
                name = "hugo-with-dependencies";
                runtimeInputs = with pkgs; [
                  hugo
                  go_1_22
                  dart-sass
                ];
                text = ''
                  hugo "$@"
                '';
              }
            );
          };
        }
      );
    };
}
