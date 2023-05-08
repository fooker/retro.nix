{ lib
, config
, writeText
, writeScript
, ncurses
, ... }:

with lib;

# The systems ROM path leverages home path expansion to ensure the actual ROMs are located inside the path

let

  command = system: emulator: writeScript "launcher-${system.id}" ''
    # Hide cursor and clear screen
    ${ncurses}/bin/tput civis
    ${ncurses}/bin/clear

    exec ${system.emulators.${emulator}.command}
  '';

in writeText "emulationstation-systems.cfg" ''
  <systemList>
  ${concatMapStringsSep "\n" (system: with system; ''
    <system>
      <name>${system.id}</name>
      <fullname>${system.fullName}</fullname>
      <path>~/roms/${system.id}</path>
      <extension>${concatMapStringsSep " " (ext: ".${ext}") system.fileExtensions}</extension>
      <command>${command system system.defaultEmulator}</command>
      <platform>${system.id}</platform>
      <theme>${system.id}</theme>
    </system>
  '') (filter (system: system.enable) (attrValues config.systems))}
  </systemList>
''
