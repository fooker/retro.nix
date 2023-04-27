{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }: rec {
    nixosModules = rec {
      retro = import ./module.nix;
      default = retro;
    };
    nixosModule = nixosModules.default;

  } // (flake-utils.lib.eachDefaultSystem (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    scrape = gamesDir: pkgs.callPackage ./scrape.nix { inherit gamesDir; };
  }));
}