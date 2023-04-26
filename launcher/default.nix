{ lib, pkgs, ... }: config:

with lib;

let
  systems = pkgs.callPackage ./systems.nix { inherit config; };

  gamelists = pkgs.callPackage ./gamelists.nix { inherit config; };
  
  inputs = pkgs.callPackage ./inputs.nix { inherit config; };

  settings = pkgs.callPackage ./settings.nix { inherit config; };

  themes = pkgs.callPackage ./themes.nix { inherit config; };
  
  home = pkgs.linkFarm "retro-config" ([
    { name = ".emulationstation/es_systems.cfg"; path = systems; }
    { name = ".emulationstation/gamelists"; path = gamelists; }
    { name = ".emulationstation/es_input.cfg"; path = inputs; }
    { name = ".emulationstation/es_settings.cfg"; path = settings; }
    { name = ".emulationstation/themes"; path = themes; }
    { name = ".emulationstation/es_log.txt"; path = "/tmp/es_log.txt"; }
  ] ++ (map (game: {
    name = "roms/${game.system}/${game.file}";
    inherit (game) path;
  }) config.games));

  emulationstation = pkgs.callPackage ../pkgs/emulationstation.nix { };

in pkgs.runCommandLocal "launcher" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
} ''
  makeWrapper "${emulationstation}/bin/emulationstation" "$out/bin/retro" \
    --add-flags "--home ${home}" \
    --add-flags "--force-kid" \
    --add-flags "--force-disable-filters" \
    --add-flags "--no-exit" \
    --add-flags "--no-splash" \
    --add-flags "--gamelist-only"
  
  ln -s "${home}" "$out/home"
''
