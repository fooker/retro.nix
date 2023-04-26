{ lib, pkgs, config, ... }:

with lib;

let
  retroArchBaseConfig = {
    "config_save_on_exit" = false;
    
    "video_fullscreen" = true;
    "video_aspect_ratio_auto" = true;
    "video_shader_enable" = false;

    "input_autodetect_enable" = false;
    "input_enable_hotkey" = null;
    "input_exit_emulator" = "escape";  # TODO: get this from config
    "input_menu_toggle" = "F1"; # TODO: get this from config
    "input_joypad_driver" = "udev";

    "quit_press_twice" = false;

    # Disable rewind feature
    "rewind_enable" = false;

    # Remove rarely used entries from quick menu
    "quick_menu_show_close_content" = false;
    "quick_menu_show_add_to_favorites" = false;
    "quick_menu_show_replay" = false;
    "quick_menu_show_start_recording" = false;
    "quick_menu_show_start_streaming" = false;
    "menu_show_overlays" = false;
    "menu_unified_controls" = true;
    "menu_show_load_content_animation" = false;

    # Disable core cache file
    "core_info_cache_enable" = false;
  };
  
  retroArchInputConfig = player: let
    mkInput = name: keymap: optional (keymap != null) {
      "key" = nameValuePair
        "input_player${toString (player.index + 1)}_${name}"
        keymap.key;
      "button" = nameValuePair
        "input_player${toString (player.index + 1)}_${name}_btn"
        keymap.button;
      "axis" = nameValuePair
        "input_player${toString (player.index + 1)}_${name}"
        "${keymap.direction}${keymap.axis}";
    }.${keymap.type};
  in optionalAttrs
    (player != null)
    (listToAttrs (concatLists [
      (mkInput "a" player.keymap.a)
      (mkInput "b" player.keymap.b)
      (mkInput "x" player.keymap.x)
      (mkInput "y" player.keymap.y)
      (mkInput "l" player.keymap.l)
      (mkInput "r" player.keymap.r)
      (mkInput "select" player.keymap.select)
      (mkInput "start" player.keymap.start)
      (mkInput "up" player.keymap.up)
      (mkInput "down" player.keymap.down)
      (mkInput "left" player.keymap.left)
      (mkInput "right" player.keymap.right)
    ]));
  
  retroarchDataConfig = let
    retroarch-database = pkgs.callPackage ../pkgs/retroarch-database.nix {};
    retroarch-assets = pkgs.callPackage ../pkgs/retroarch-assets.nix {};
    retroarch-core-info = pkgs.callPackage ../pkgs/retroarch-core-info.nix {};
  in {
    "content_database_path" = "${retroarch-database}/share/retroarch/database/rdb";
    "cursor_directory" = "${retroarch-database}/share/retroarch/database/cursor";
    "cheat_database_path" = "${retroarch-database}/share/retroarch/database/cht";
    "assets_directory" = "${retroarch-assets}/share/retroarch/assets";
    "libretro_info_path" = "${retroarch-core-info}";
  };

  # Write config file for RetroArch
  writeRetroArchConfig = configs: pkgs.writeText "retroarch.cfg" (concatStringsSep "\n"
    (mapAttrsToList
      (name: value: let 
        writer = type: getAttr type {
          "string" = toString;
          "bool" = boolToString;
          "int" = toString;
          "float" = toString;
          "null" = const "nul";
        };
      in "${name} = \"${writer (builtins.typeOf value) value}\"")
      (foldl (a: b: a // b) {} configs)));

  mkRetroArchEmulator = {
    enable,
    description,
    core,
    overrides ? {}
  }: let
    pkg = pkgs.retroarch.override {
      cores = singleton pkgs.libretro.${core};
    };
    
    configFile = writeRetroArchConfig [
      retroArchBaseConfig
      retroarchDataConfig
      (retroArchInputConfig config.inputs.player1)
      (retroArchInputConfig config.inputs.player2)
      (retroArchInputConfig config.inputs.player3)
      (retroArchInputConfig config.inputs.player4)
      overrides
    ];
  in {
    inherit enable description;
    command = "${pkg}/bin/retroarch -L ${core} --config ${configFile} %ROM%";
  };

in {
  config.systems = {
    snes = {
      fullName = "Super Nintendo";
      fileExtensions = [ "smc" "sfc" "swc" "mgd" ];

      emulators = {
        "libretro-snes9x" = mkRetroArchEmulator {
          enable = true;
          description = "Super Nintendo emu - Snes9x (current) port for libretro";
          core = "snes9x";
        };
        "libretro-snes9x2010" = mkRetroArchEmulator {
          enable = true;
          description = "Super Nintendo emu - Snes9x (1.52) port for libretro";
          core = "snes9x2010";
        };
      };

      defaultEmulator = mkDefault "libretro-snes9x";
    };
  };
}