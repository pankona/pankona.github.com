{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/7fd307937db70af23b956c4539033542809ae263";
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
              hugo
              go_1_20
              gnumake
              coreutils
              peco
              typos
              dprint
              actionlint
              nil
              nixpkgs-fmt
            ];
          };
      });
}
