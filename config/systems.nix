{ lib, pkgs, ... }:

with lib;

let
  # config file for RetroArch with overrides
  writeRetroArchConfig = overrides: pkgs.writeText "retroarch.cfg" (concatStringsSep "\n"
    (mapAttrsToList
      ({ name, value }: "${name} = \"${value}\"")
      (recursiveUpdate {
        
      } overrides)));

  mkRetroArchEmulator = {
    enable,
    description,
    core,
    overrides ? {}
  }: let
    pkg = pkgs.retroarch.override {
      cores = singleton pkgs.libretro.${core};
    };
  in {
    inherit enable description;
    command = "${pkg}/bin/retroarch -L ${core} --config ${writeRetroArchConfig overrides} %ROM%";
  };

in {
  systems = {
    snes = {
      fullName = "Super Nintendo";
      fileExtensions = [ "smc" "sfc" "swc" "mgd" ];

      emulators = {
        "libretro-snes9x" = mkRetroArchEmulator {
          enable = true;
          description = "Super Nintendo emu - Snes9x (current) port for libretro";
          core = "snes9x";
        };
      };

      defaultEmulator = "libretro-snes9x";
    };
  };
}