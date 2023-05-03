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
            type = "key";
            id = keycodes.${mapping.key}.emulationstation;
            value = 1;
          })
        player.keymap)))
    (attrVals [ "player1" "player2" "player3" "player4" ] config.inputs);

  joystickMappings = listToAttrs (map
    (player: nameValuePair
      "" # player.joystickName
      (concatLists (
        (mapAttrsToList
          (name: mapping: optional (mapping != null && mapping.button != null) {
            inherit name;
            type = "button";
            id = mapping.button;
            value = 1;
          })
          player.keymap)
      ++
        (mapAttrsToList
          (name: mapping: optional (mapping != null && mapping.axis != null) {
            inherit name;
            type = "axis";
            id = mapping.axis.index;
            value = { "+" = 1; "-" = -1; }.${mapping.axis.direction};
          })
          player.keymap)
      )))
    (filter
      (player: player != null)
      (attrVals [ "player1" "player2" "player3" "player4" ] config.inputs)));

in writeText "emulationstation-input.cfg" (let
  input = mapping: ''
    <input name="${mapping.name}" type="${mapping.type}" id="${toString mapping.id}" value="${toString mapping.value}" />
  '';
in ''
  <?xml version="1.0"?>
  <inputList>
    <inputConfig type="keyboard" deviceName="Keyboard" deviceGUID="-1">
    ${concatMapStringsSep "\n" input keyboardMappings}
    </inputConfig>

  ${concatStringsSep "\n" (mapAttrsToList (device: mappings: ''
    <inputConfig type="joystick" deviceName="DragonRise inc. Generic USB Joystick" deviceGUID="">
    ${concatMapStringsSep "\n" input mappings}
    </inputConfig>
  '') joystickMappings)}
  </inputList>
'')
