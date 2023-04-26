{ lib, ... }: 

with lib;

let
  retro = config;
in {
  options.inputs = let
    mkKeyMapOption = name: mkOption {
      description = "Input '${name}'";
      type = types.nullOr (types.submodule {
        options = {
          key = mkOption {
            description = "Key to bind to input";
            type = types.nullOr (types.enum (attrNames (import ../keycodes.nix)));
            default = null;
          };

          axis = mkOption {
            description = "Axis to bind to input";
            type = types.nullOr (types.strMatching ''[\+-][[:digit:]]+'');
            apply = mapNullable (s: {
              direction = substring 0 1 s;
              index = toIntBase10 (substring 1 ((stringLength s) - 1) s);
            });
            default = null;
          };

          button = mkOption {
            description = "Button to bind to input";
            type = types.nullOr types.ints.unsigned;
            default = null;
          };
        };
      });
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