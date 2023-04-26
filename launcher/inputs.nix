{ lib
, config
, writeText
, ... }:

with lib;

let
  keycodes = import ../keycodes.nix;

  # Map all player input keymaps to a single keyoard input config list
  keyboardMappings = concatMap
    (player: optionals
      (player != null)
      (concatLists (mapAttrsToList
        (name: mapping: optional
          (mapping != null && mapping.key != null)
          {
            inherit name;
            inherit (mapping) key;
          })
        player.keymap)))
    (attrVals [ "player1" "player2" "player3" "player4" ] config.inputs);

in writeText "emulationstation-input.cfg" ''
  <?xml version="1.0"?>
  <inputList>
    <inputConfig type="keyboard" deviceName="Keyboard" deviceGUID="-1">
    ${concatMapStringsSep "\n" (mapping: ''
      <input name="${mapping.name}" type="key" id="${toString keycodes.${mapping.key}.emulationstation}" value="1" />
    '') keyboardMappings}
    </inputConfig>
  </inputList>
''
