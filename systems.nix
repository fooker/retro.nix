{ lib, config, pkgs, ... }:

with lib;

let
  # config file for RetroArch with overrides
  retroArchConfig = overrides: pkgs.writeText "retroarch.cfg" (concatStringsSep "\n"
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
    retroarch = pkgs.retroarch.override {
      cores = singleton pkgs.libretro.${core};
    };
    config = retroArchConfig overrides;
  in {
    inherit enable description;
    command = "${retroarch}/bin/retroarch -L ${core} --config ${config} %ROM%";
  };

in {
  retro.systems = {
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