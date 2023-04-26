{
  inputs = { };

  outputs = { ... }: rec {
    nixosModules = rec {
      retro = import ./module.nix;
      default = retro;
    };
    nixosModule = nixosModules.default;
  };
}