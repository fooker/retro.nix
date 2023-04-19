{ lib, config, ... }:

with lib;

mkIf config.retro.autostart.enable {
  users = {
    mutableUsers = false;
    users.root = {
      openssh.authorizedKeys.keys =
        let
          keys = pkgs.callPackage sshkeys { };
        in
        concatLists (attrValues keys.keys);
    };

    users.retroarch = {
      isSystemUser = true;
      group = "retroarch";
      extraGroups = [ "input" "video" ];
    };
    groups.retroarch = { };
  };

  systemd.services."emulationstation" = {
    description = "EmulationStation";
    after = [ "systemd-user-sessions.service" "sound.target" ];
    conflicts = [ "getty@tty1.service" ];

    serviceConfig = {
      ExecStart = "${emulationstation}/bin/emulationstation";
      Restart = "always";

      User = "retro";
      Group = "retro";

      PAMName = "login";
      TTYPath = "/dev/tty1";
      StandardInput = "tty";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
