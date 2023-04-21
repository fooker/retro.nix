{ lib, config, ... }:

with lib;

mkIf config.retro.autostart.enable {
  users = {
    users.retro = {
      isSystemUser = true;
      group = "retro";
      extraGroups = [ "input" "video" ];
    };
    groups.retro = { };
  };

  systemd.services."reto" = {
    description = "Retro Gaming";
    after = [ "systemd-user-sessions.service" "sound.target" ];
    conflicts = [ "getty@tty1.service" ];

    serviceConfig = {
      ExecStart = "${config.retro.launcher}/bin/retro";
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
