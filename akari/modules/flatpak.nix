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
      "org.qbittorrent.qBittorrent"
      "org.telegram.desktop"
    ];
  };
}
