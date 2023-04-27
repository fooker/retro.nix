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
    pkgs = nixpkgs.legacy.${system};
  in {
    scrape = pkgs.callPackage ./scrape.nix { };
  }));
}