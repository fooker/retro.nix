{ lib, pkgs, ... }:

with lib;

let
  retro = config;
  
  systems = [
    "3do"
    "amiga"
    "amstradcpc"
    "apple2"
    "arcade"
    "atari800"
    "atari2600"
    "atari5200"
    "atari7800"
    "atarilynx"
    "atarist"
    "atarijaguar"
    "atarijaguarcd"
    "atarixe"
    "colecovision"
    "c64"
    "intellivision"
    "macintosh"
    "xbox"
    "xbox360"
    "msx"
    "neogeo"
    "ngp"
    "ngpc"
    "n3ds"
    "n64"
    "nds"
    "nes"
    "gb"
    "gba"
    "gbc"
    "gc"
    "wii"
    "wiiu"
    "pc"
    "sega32x"
    "segacd"
    "dreamcast"
    "gamegear"
    "genesis"
    "mastersystem"
    "megadrive"
    "saturn"
    "psx"
    "ps2"
    "ps3"
    "ps4"
    "psvita"
    "psp"
    "snes"
    "pcengine"
    "wonderswan"
    "wonderswancolor"
    "zxspectrum"
  ];

in {
  options.systems = mkOption {
    description = "Emulated Systems";
    type = types.attrsOf (types.submodule ({ name, config, ... }: {
      options = {
        id = mkOption {
          description = "ID of the system";
          type = types.enum systems;
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
          default = { };
        };

        defaultEmulator = mkOption {
          description = "Default emulator for this system";
          type = types.enum (attrNames (filterAttrs
            (_: emulator: emulator.enable)
            config.emulators));
        };

        games = mkOption {
          description = "Games for this system";
          type = types.listOf (types.submodule ({ ... }: {
            options = {
              
            };
          }));
          default = [ ];
        };
      };
    }));
    default = { };
  };
}
