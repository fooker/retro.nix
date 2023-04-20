{ lib, pkgs, ... }: config:

with lib;

let
  emulationstationSystemsConfig = pkgs.writeText "emulationstation-systems.cfg" ''
    <systemList>
    ${concatMapStringsSep "\n" (system: with system; ''
      <system>
        <name>${id}</name>
        <fullname>${fullName}</fullname>
        <path>~/roms/${id}</path>
        <extension>${concatMapStringsSep " " (ext: ".${ext}") fileExtensions}</extension>
        <command>${emulators.${defaultEmulator}.command}</command>
        <platform>${id}</platform>
        <theme>${id}</theme>
      </system>
    '') (attrValues config.systems)}
    </systemList>
  '';

  emulationstationConfig = pkgs.linkFarm "emulationstation-config" {
    "es_systems.cfg" = emulationstationSystemsConfig;
  };

  emulationstation = pkgs.callPackage ./pkgs/emulationstation.nix { };

in pkgs.runCommandLocal "launcher" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
} ''
  mkdir -p "$out/etc"

  ln -s "${emulationstationConfig}" "$out/etc/emulationstation"

  makeWrapper "${emulationstation}/bin/emulationstation" "$out/bin/retro" \
    --set LD_PRELOAD "${pkgs.libredirect}/lib/libredirect.so" \
    --set NIX_REDIRECTS "/etc/emulationstation=$out/etc/emulationstation"
''
