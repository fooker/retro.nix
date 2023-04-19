{
  inputs = { };

  outputs = { self, ... }: {
    nixosModules = {
      retro = import ./.;
      default = self.nixosModules.retro;
    };

    nixosModule = self.nixosModules.default;
  };
}