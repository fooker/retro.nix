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

    exec ${emulators.${emulator}.command}
  '';

in writeText "emulationstation-systems.cfg" ''
  <systemList>
  ${concatMapStringsSep "\n" (system: with system; ''
    <system>
      <name>${id}</name>
      <fullname>${fullName}</fullname>
      <path>~/roms/${id}</path>
      <extension>${concatMapStringsSep " " (ext: ".${ext}") fileExtensions}</extension>
      <command>${command system defaultEmulator}</command>
      <platform>${id}</platform>
      <theme>${id}</theme>
    </system>
  '') (filter (system: system.enable) (attrValues config.systems))}
  </systemList>
''
