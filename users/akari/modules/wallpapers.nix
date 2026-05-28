{ pkgs, ... }:

{
  systemd.user.services.rclone-onedrive-wallpapers = {
    Unit = {
      Description = "Sync OneDrive Wallpapers with rclone";
      Documentation = "man:rclone(1)";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecCondition = "${pkgs.runtimeShell} -c '${pkgs.rclone}/bin/rclone listremotes | ${pkgs.gnugrep}/bin/grep -Fx onedrive:'";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Wallpapers";
      ExecStart = "${pkgs.rclone}/bin/rclone sync onedrive:Wallpapers %h/Wallpapers";
    };

    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.timers.rclone-onedrive-wallpapers = {
    Unit.Description = "Sync OneDrive Wallpapers every 30 minutes";

    Timer = {
      OnUnitActiveSec = "30min";
      Unit = "rclone-onedrive-wallpapers.service";
    };

    Install.WantedBy = [ "timers.target" ];
  };
}
