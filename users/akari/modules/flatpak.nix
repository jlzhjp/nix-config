_:

{
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    packages = [
      "com.github.tchx84.Flatseal"
      "com.github.xournalpp.xournalpp"
      "com.obsproject.Studio"
      "org.qbittorrent.qBittorrent"

      "org.kde.kdenlive"
      "info.smplayer.SMPlayer"

      "net.ankiweb.Anki"
      "md.obsidian.Obsidian"
      "com.rustdesk.RustDesk"
      "org.sqlitebrowser.sqlitebrowser"
      "org.libreoffice.LibreOffice"

      "com.qq.QQ"
      "com.tencent.WeChat"
      "com.tencent.wemeet"
      "org.telegram.desktop"

      "com.valvesoftware.Steam"
      "net.lutris.Lutris"
      "com.github.Matoking.protontricks"
      "net.davidotek.pupgui2"
      "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/25.08"

    ];
  };
}
