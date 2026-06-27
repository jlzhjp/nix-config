{
  config,
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
    symbola
    cascadia-code
    monaspace
    newcomputermodern
    nerd-fonts.fira-code
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.iosevka-term-slab
    nerd-fonts.symbols-only
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

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

  networking = {
    networkmanager.enable = true;
    nftables.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [
        "docker0"
        "virbr0"
        "br-*"
        config.services.tailscale.interfaceName
      ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

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
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  programs = {
    chromium = {
      enable = true;
      enablePlasmaBrowserIntegration = true;
    };

    firefox = {
      enable = true;
      package = pkgs.firefox-bin;
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };

    fish.enable = true;

    nix-ld.enable = true;

    wireshark = {
      enable = true;
      package = pkgs.wireshark;
      dumpcap.enable = true;
    };

    virt-manager.enable = true;
  };

  security.rtkit.enable = true;

  services = {
    cloudflare-warp.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings.main = {
          capslock = "overload(control, esc)";
          esc = "capslock";
        };
      };
    };
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
    tailscale.enable = true;
    udisks2.enable = true;
  };

  systemd = {
    oomd.enable = true;
    network.wait-online.enable = false;
    services = {
      tailscaled.serviceConfig.Environment = [ "TS_DEBUG_FIREWALL_MODE=nftables" ];
    };
  };

  time.timeZone = "Asia/Tokyo";

  users = {
    groups.akari.gid = 1000;

    users = {
      akari = {
        description = "Akari";
        extraGroups = [
          "docker"
          "wheel"
          "wireshark"
          "libvirtd"
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
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };
  };

  zramSwap = {
    algorithm = "zstd";
    enable = true;
    memoryPercent = 50;
  };
}
