{ lib, config, ... }:

with lib;

let
  retro = config;
in {
  options.games = mkOption {
    description = "Games";
    type = types.listOf (types.submodule ({ config, ... }: {
      options = {
        name = mkOption {
          description = "Name of the game";
          type = types.str;
        };

        file = mkOption {
          description = "Filename of the game";
          type = types.str;
        };

        path = mkOption {
          description = "Path of the game ROM";
          type = types.path;
        };

        system = mkOption {
          description = "System to play on";
          type = types.enum (attrNames (filterAttrs
            (_: system: system.enable)
            retro.systems));
        };

        description = mkOption {
          description = "Description of the game";
          type = types.str;
          default = "";
        };

        image = mkOption {
          description = "Image of the game";
          type = types.nullOr types.path;
          default = null;
        };

        thumbnail = mkOption {
          description = "Thumbnail image of the game";
          type = types.nullOr types.path;
          default = config.image; # TODO: Generate scaled-down version of the image
        };
      };
    }));
    default = [ ];
  };
}
