{ lib
, config
, writeText
, ... }:

with lib;

# The systems ROM path leverages home path expansion to ensure the actual ROMs are located inside the path

writeText "emulationstation-systems.cfg" ''
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
  '') (filter (system: system.enable) (attrValues config.systems))}
  </systemList>
''
