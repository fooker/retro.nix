{ lib, pkgs, ... }:

with lib;

{
  options.retro = {
    enable = mkEnableOption "retro gaming";

    autostart = {
      enable = mkEnableOption "automatic start";
    };

    systems = mkOption {
      description = "Emulated Systems";
      type = types.attrsOf (types.submodule ({ name, config, ... }: {
        options = {
          id = mkOption {
            description = "ID of the system";
            type = types.nonEmptyStr;
            readOnly = true;
            default = name;
          };

          enable = mkEnableOption "System ${name}";

          fullName = mkOption {
            description = "Full name of the system";
            type = types.str;
          };

          fileExtensions = mkOption {
            description = "Supported file name extensions (without leading dot)";
            type = types.listOf types.nonEmptyStr;
          };

          emulators = mkOption {
            description = "Emulators for this system";
            type = types.attrsOf (types.submodule ({ name, config, ... }: {
              options = {
                id = mkOption {
                  description = "ID of the system";
                  type = types.nonEmptyString;
                  readOnly = true;
                  default = name;
                };

                enable = mkEnableOption "Emulator ${name}";
                
                description = mkOption {
                  description = "Description of the emulator";
                  type = types.str;
                };

                command = mkOption {
                  description = "Command used to launch the emulator (use `%ROM%` as a placeholder)";
                  type = types.str;
                };
              };
            }));
          };

          defaultEmulator = mkOption {
            description = "Default emulator for this system";
            type = types.enum (attrNames (filterAttrs
              (_: emulator: emulator.enable)
              config.emulators));
          };
        };
      }));
    };
  };

  imports = [
    ./systems.nix
    ./emulationstation.nix
    ./autostart.nix
  ];

  config = mkIf config.retro.enable {
  };

  # TODO: Add assertion to check emulator names are globally unique
}