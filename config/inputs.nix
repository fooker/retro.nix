{ lib, ... }: 

with lib;

let
  retro = config;
in {
  options.inputs = let
    mkController = player: mkOption {
      description = "";
      type = types.nullOr (types.submodule ({ config, ... }: {
        options = {
          port = mkOption {
            description = "Port of the controller";
            type = types.ints.positive;
            readOnly = true;
            default = player;
          };

          type = mkOption {
            description = "Type of controller";
            type = types.enum [
              "keyboard"
              "cec"
              "joystick"
            ];
          };

          device = mkOption {
            description = "Device name of controller";
            type = types.str;
            default = {
              keyboard = "Keyboard";
              cec = "CEC";
            }.${config.type} or null;
          };

          input = mkOption {
            description = "Assigned inputs";
            type = type.attrsOf (types.submodule ({ name, ... }: {
              options = {
                name = mkOption {
                  description = "Name of the input";
                  type = types.str; # TODO: make this an enum of well-known names?
                  readOnly = true;
                  default = name;
                };

                type = mkOption {
                  description = "Type of controller input";
                  type = types.enum [
                    "axis"
                    "button"
                    "hat"
                    "key"
                    "cec-button"
                  ];
                };

                id = mkOption {
                  description = "ID of the assigned controller input";
                  type = types.ints.unsigned;
                };

                value = mkOption {
                  description = "Value triggering the input";
                  type = types.ints.unsigned;
                };
              };
            }));
          };
        };
      }));
      default = null;
    };
    
  in {
    player1 = mkController 1;
    player2 = mkController 2;
    player3 = mkController 3;
    player4 = mkController 4;
  };
}