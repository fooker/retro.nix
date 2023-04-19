{ lib, config, pkgs, ... }:

with lib;

let
  systemsConfig = pkgs.writeText "emulationstation-systems.xml" ''
    <systemList>
    ${concatMapStringsSep "\n" (system: with system; ''
      <system>
        <name>${id}</name
        <fullname>${fullName}</fullname>
        <path>~/roms/${id}</path>
        <extension>${concatMapStringsSep " " (ext: ".${ext}") fileExtensions}</extension>
        <command>${emulators.${defaultEmulator}.command}</command>
        <platform>${id}</platform>
        <theme>${id}</theme>
      </system>
    '') (attrValues config.retro.systems)}
    </systemList>
  '';

in mkIf config.retro.enable {
  environment.etc.emulationstation = {
    target = "emulationstation";
    source = traceVal (toString (pkgs.linkFarm "emulationstation-config" {
      "es_systems.cfg" = systemsConfig;
    }));
  };
}