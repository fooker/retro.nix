{ lib, pkgs, config, ... }:

with lib;

let
  keycodes = import ../keycodes.nix;

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

    # Disable all other hotkeys by default
    "input_reset" = null;
    "input_toggle_fast_forward" = null;
    "input_hold_fast_forward" = null;
    "input_toggle_slowmotion" = null;
    "input_hold_slowmotion" = null;
    "input_close_content" = null;
    "input_rewind" = null;
    "input_pause_toggle" = null;
    "input_frame_advance" = null;
    "input_audio_mute" = null;
    "input_volume_up" = null;
    "input_volume_down" = null;
    "input_load_state" = null;
    "input_save_state" = null;
    "input_state_slot_increase" = null;
    "input_state_slot_decrease" = null;
    "input_play_replay" = null;
    "input_record_replay" = null;
    "input_halt_replay" = null;
    "input_replay_slot_increase" = null;
    "input_replay_slot_decrease" = null;
    "input_disk_eject_toggle" = null;
    "input_disk_next" = null;
    "input_disk_prev" = null;
    "input_shader_toggle" = null;
    "input_shader_next" = null;
    "input_shader_prev" = null;
    "input_cheat_toggle" = null;
    "input_cheat_index_plus" = null;
    "input_cheat_index_minus" = null;
    "input_screenshot" = null;
    "input_recording_toggle" = null;
    "input_streaming_toggle" = null;
    "input_grab_mouse_toggle" = null;
    "input_game_focus_toggle" = null;
    "input_toggle_fullscreen" = null;
    "input_desktop_menu_toggle" = null;
    "input_toggle_vrr_runloop" = null;
    "input_runahead_toggle" = null;
    "input_preempt_toggle" = null;
    "input_fps_toggle" = null;
    "input_toggle_statistics" = null;
    "input_ai_service" = null;
    "input_movie_record_toggle" = null;
    "input_netplay_game_watch" = null;
    "input_netplay_player_chat" = null;
    "input_osk_toggle" = null;
    "input_send_debug_info" = null;

    "quit_press_twice" = false;

    "auto_remaps_enable" = false;

    "all_users_control_menu" = true;
    "menu_unified_controls" = true;

    # Disable rewind feature
    "rewind_enable" = false;

    # Remove rarely used entries from quick menu
    "quick_menu_show_close_content" = false;
    "quick_menu_show_add_to_favorites" = false;
    "quick_menu_show_replay" = false;
    "quick_menu_show_start_recording" = false;
    "quick_menu_show_start_streaming" = false;
    "menu_show_overlays" = false;
    "menu_show_load_content_animation" = false;

    # Disable core cache file
    "core_info_cache_enable" = false;

    # Audio settings
    "audio_driver" = "alsa";
    "audio_enable" = true;
    "audio_fastforward_mute" = false;
    "audio_sync" = true;
    "audio_volume" = "1.000000";
  };

  retroArchInputConfig = player: let
    mkInput = name: mapping: optionals (mapping != null) concatLists [
      (optional (mapping.key != null) (nameValuePair
        "input_player${toString (player.index + 1)}_${name}"
        keycodes.${mapping.key}.retroarch))
      (optional (mapping.button != null) (nameValuePair
        "input_player${toString (player.index + 1)}_${name}_btn"
        mapping.button))
      (optional (mapping.axis != null) (nameValuePair
        "input_player${toString (player.index + 1)}_${name}_axis"
        "${mapping.axis.direction}${toString mapping.axis.index}"))
    ];
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

  mkRetroArchEmulator = core: overrides: let
    corePkg = pkgs.libretro.${core};

    pkg = pkgs.retroarch.override {
      cores = singleton corePkg;
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
    enable = mkDefault true;
    inherit (corePkg) description;
    command = "${pkg}/bin/retroarch -L ${core} --config ${configFile} %ROM%";
  };

in {
  config.systems = {
    snes = {
      fullName = "Super Nintendo";
      fileExtensions = [ "smc" "sfc" "swc" "mgd" ];

      emulators = {
        "libretro-snes9x" = mkRetroArchEmulator "snes9x" { };
        "libretro-snes9x2010" = mkRetroArchEmulator "snes9x2010" { };
      };

      defaultEmulator = mkDefault "libretro-snes9x";
    };
    nes = {
      fullName = "Nintendo";
      fileExtensions = [ "nes" ];

      emulators = {
        "libretro-fceumm" = mkRetroArchEmulator "fceumm" { };
        "libretro-nestopia" = mkRetroArchEmulator "nestopia" { };
      };

      defaultEmulator = mkDefault "libretro-fceumm";
    };
    gba = {
      fullName = "GameBoy Advance";
      fileExtensions = [ ".gb" ".gbc" "gba" ];

      emulators = {
        "libretro-mgba" = mkRetroArchEmulator "mgba" { };
        "libretro-gpsp" = mkRetroArchEmulator "gpsp" { };
      };

      defaultEmulator = mkDefault "libretro-mgba";
    };
  };
}

