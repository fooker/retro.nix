{ lib, config, pkgs, ... }:

with lib;

let
  launcher = (pkgs.callPackage ./launcher.nix { }) config.retro;

in {
  options.retro = mkOption {
    description = "Retro Gaming Configuration";
    type = types.submodule ({
      options = {
        enable = mkEnableOption "retro gaming";

        autostart = {
          enable = mkEnableOption "automatic start";
        };
      };
      
      imports = [ ./config ];

      config = {
        _module.args = {
          inherit pkgs lib;
        };
      };
    });
  };

  config = mkIf config.retro.enable {
    environment.systemPackages = [
      launcher
    ];
  };

  imports = [
    ./autostart.nix
  ];
}
