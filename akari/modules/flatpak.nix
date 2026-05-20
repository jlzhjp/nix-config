_:

{
  services.flatpak = {
    enable = true;

    update.onActivation = true;
    uninstallUnmanaged = true;

    packages = [
      "com.github.tchx84.Flatseal"
      "com.github.xournalpp.xournalpp"
      "com.obsproject.Studio"
      "com.qq.QQ"
      "com.tencent.WeChat"
      "com.tencent.wemeet"
      "org.qbittorrent.qBittorrent"
      "org.telegram.desktop"
      "com.valvesoftware.Steam"
      "net.lutris.Lutris"
      "com.github.Matoking.protontricks"
      "net.davidotek.pupgui2"
      "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/25.08"
    ];
  };
}
