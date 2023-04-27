{ lib, config, pkgs, ... }:

with lib;

{
  options.retro = mkOption {
    description = "Retro Gaming Configuration";
    type = types.submodule ({ config, ... }: {
      options = {
        enable = mkEnableOption "retro gaming";

        autostart = {
          enable = mkEnableOption "automatic start";
        };

        launcher = mkOption {
          description = "Launcher path";
          type = types.package;
          readOnly = true;
          default = (pkgs.callPackage ./launcher { }) config;
        };

        scrape = mkOption {
          description = "Paths to scrape for games";
          type = types.listOf types.path;
          default = [];
        };
      };
      
      imports = [ ./config ./systems ];

      config = {
        _module.args = {
          inherit pkgs lib;
        };

        games = concatMap
          (path: pkgs.callPackage ./scrape.nix { gamesDir = path; })
          config.scrape;
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
