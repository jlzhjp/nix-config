{
  lib,
  pkgs,
  ...
}:

{
  boot = {
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        editor = false;
        enable = lib.mkForce false;
      };
    };
    tmp = {
      useZram = true;
      zramSettings.compression-algorithm = "zstd";
    };
  };

  console.useXkbConfig = true;

  environment.systemPackages = with pkgs; [
    efibootmgr
    google-chrome
    neovim
    smartmontools
  ];

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-mozc
        fcitx5-rime
        qt6Packages.fcitx5-configtool
        rime-data
      ];
    };
  };

  networking.networkmanager.enable = true;

  nix.settings = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];
    substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  security.rtkit.enable = true;

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    libinput.enable = true;
    mihomo = {
      configFile = "/etc/mihomo/config.yaml";
      enable = true;
      tunMode = true;
    };
    pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };
      enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
    udisks2.enable = true;
    xserver.xkb = {
      layout = "us";
      options = "caps:swapescape";
    };
  };

  systemd.oomd.enable = true;

  time.timeZone = "Asia/Tokyo";

  users.users = {
    akari = {
      description = "Akari";
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      shell = pkgs.fish;
    };
    root.hashedPassword = "!";
  };

  zramSwap = {
    algorithm = "zstd";
    enable = true;
    memoryPercent = 50;
  };
}
