{ lib, ... }: 

with lib;

let
  retro = config;
in {
  options.inputs = let
    mkKeyMapOption = name: mkOption {
      description = "Input '${name}'";
      type = types.nullOr (types.oneOf (let
        mkInputType = type: module: types.submodule [ module {
          options = {
            type = mkOption {
              description = "Type of input";
              type = types.enum [ "key" "button" "axis" ];
              readOnly = true;
              default = type;
            };
          };
        } ];
      in [
        (mkInputType "key" {
          options = {
            key = mkOption {
              description = "Key to bind to input";
              type = types.enum (attrNames (import ../keycodes.nix));
            };
          };
        })
        
        (mkInputType "axis" {
          options = {
            axis = mkOption {
              description = "Axis to bind to input";
              type = types.int.unsigned;
            };

            direction = mkOption {
              description = "Axis direction for input";
              type = types.enum [ "+" "-" ];
            };
          };
        })

        (mkInputType "button" {
          options = {
            button = mkOption {
              description = "Butotn to bind to input";
              type = types.int.unsigned;
            };
          };
        })
      ]));
      default = null;
    };

    mkPlayerOption = index: mkOption {
      description = "Inputs for Player ${toString (index + 1)}";
      type = types.nullOr (types.submodule ({ config, ... }: {
        options = {
          index = mkOption {
            description = "Index of the player";
            type = types.ints.unsigned;
            readOnly = true;
            default = index;
          };

          port = mkOption {
            description = "Port index of the controller assigned to this player";
            type = types.ints.unsigned;
            default = index;
          };

          keymap = genAttrs [
            "a" "b"
            "x" "y"
            "l" "r"
            "select"
            "start"
            "up" "down"
            "left" "right"
          ] mkKeyMapOption;
        };
      }));
      default = null;
    };
    
  in {
    player1 = mkPlayerOption 0;
    player2 = mkPlayerOption 1;
    player3 = mkPlayerOption 2;
    player4 = mkPlayerOption 3;
  };
}