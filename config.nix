{ lib, pkgs, ... }:

with lib;

rec {
  eval = config: lib.evalModules {
    modules = (singleton module) ++ (toList config);
  };

  module = { ... }: {
    imports = [ ./config ./systems ];
    config = {
      _module.args = {
        inherit pkgs lib;
      };
    };
  };

  launcher = config:
    (pkgs.callPackage ./launcher { })
    (eval config).config;
}