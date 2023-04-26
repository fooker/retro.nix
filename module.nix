{ lib, config, pkgs, ... }:

with lib;

{
  options.retro = mkOption {
    description = "Retro Gaming Configuration";
    type = types.submodule ({
      options = {
        enable = mkEnableOption "retro gaming";

        autostart = {
          enable = mkEnableOption "automatic start";
        };

        launcher = mkOption {
          description = "Launcher path";
          type = types.package;
          readOnly = true;
          default = (pkgs.callPackage ./launcher { }) config.retro;
        };
      };
      
      imports = [ ./config ./systems ];

      config = {
        _module.args = {
          inherit pkgs lib;
        };
      };
    });
  };

  config = mkIf config.retro.enable {
    environment.systemPackages = [
      config.retro.launcher
    ];
  };

  imports = [
    ./autostart.nix
  ];
}
