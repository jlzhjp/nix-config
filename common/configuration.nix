{
  lib,
  pkgs,
  ...
}:

{
  boot = {
    initrd.systemd.enable = true;
    kernelModules = [ "tcp_bbr" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl = {
      "kernel.dmesg_restrict" = 1;
      "kernel.kptr_restrict" = 2;
      "kernel.sysrq" = 1;
      "kernel.unprivileged_bpf_disabled" = 1;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "vm.swappiness" = 10;
    };
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
    sbctl
    git
    google-chrome
    neovim
    smartmontools
  ];

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
    geist-font
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
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

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      sandbox = true;
      substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  programs.chromium = {
    enable = true;
    enablePlasmaBrowserIntegration = true;
  };

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

  users = {
    groups.akari.gid = 1000;

    users = {
      akari = {
        description = "Akari";
        extraGroups = [
          "docker"
          "wheel"
        ];
        group = "akari";
        isNormalUser = true;
        shell = pkgs.fish;
        uid = 1000;
      };
      root.hashedPassword = "!";
    };
  };

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  zramSwap = {
    algorithm = "zstd";
    enable = true;
    memoryPercent = 50;
  };
}
