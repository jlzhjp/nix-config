{ pkgs, ... }:

{
  systemd.user.services.rclone-onedrive-wallpapers = {
    Unit = {
      Description = "Mount OneDrive Wallpapers with rclone";
      Documentation = "man:rclone(1)";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";
      ExecCondition = "${pkgs.runtimeShell} -c '${pkgs.rclone}/bin/rclone listremotes | ${pkgs.gnugrep}/bin/grep -Fx onedrive:'";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Wallpapers";
      ExecStart = "${pkgs.rclone}/bin/rclone mount onedrive:Wallpapers %h/Wallpapers --vfs-cache-mode writes";
      ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u %h/Wallpapers";
      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install.WantedBy = [ "default.target" ];
  };
}
