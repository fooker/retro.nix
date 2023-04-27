{ lib
, config
, linkFarm
, writeText
, ... }:

with lib;

let
  
in linkFarm "emulationstation-gamelists" (mapAttrs'
  (system: games: nameValuePair "${system}/gamelist.xml" (writeText "emulationstation-gamelists-${system}" ''
    <gameList>
    ${concatMapStringsSep "\n" (game: with game; ''
      <game>
        <path>${game.file}</path>
        <name>${name}</name>
        <desc>${description}</desc>
        ${optionalString (image != null) ''<image>${image}</image>''}
        ${optionalString (thumbnail != null) ''<thumbnail>${thumbnail}</thumbnail>''}
      </game>
    '') games}
    </gameList>
  ''))
  (groupBy
    (game: game.system)
    (config.games)))
