{
  description = "nix-alien";

  inputs = {
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, nix-index-database }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      apps = forAllSystems (
        system:
        let
          genNixAlienApp = name: {
            type = "app";
            program = nixpkgs.lib.getExe' self.package.${system} name;
          };
        in
        rec {
          default = nix-alien;
          nix-alien = genNixAlienApp "nix-alien";
          nix-alien-ld = genNixAlienApp "nix-alien-ld";
          nix-alien-find-libs = genNixAlienApp "nix-alien-find-libs";
        }
      );

      package = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
          pkgs.callPackage ./nix-alien.nix {
            nix-index = nix-index-database.packages.${system}.nix-index-with-db;
          };
      );
    };
}
