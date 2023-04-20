{ lib, pkgs, ... }:

with lib;

rec {
  eval = config: lib.evalModules {
    modules = (singleton module) ++ (toList config);
  };

  module = { ... }: {
    imports = [ ./config ];
    config = {
      _module.args = {
        inherit pkgs lib;
      };
    };
  };

  launcher = config:
    (pkgs.callPackage ./launcher.nix { })
    (eval config).config;
}