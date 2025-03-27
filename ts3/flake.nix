{
  description = "Nim development environment";

  inputs = {
    # Latest commit in the branch nixos-24.11
    nixpkgs.url = "github:nixos/nixpkgs/de6bff00ff533dced917a3a1a437c5dea6ad23b1";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (
      system: f {
        pkgs = import nixpkgs { inherit system; };
      }
    );
  in {
    devShells = forEachSupportedSystem (
      { pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nim
            nimble
            nph
            zig
            libsForQt5.qt5.qtbase
            libsForQt5.qt5.qttools
            libsForQt5.qt5.qtwayland
            sqlite
          ];
        };
      }
    );
  };
}
