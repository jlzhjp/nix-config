{
  pkgs,
  ...
}:

{
  # Import hardware configuration.
  # imports = [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Define your hostname.
  networking.hostName = "nixos";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Muscle memory.
  services.xserver.xkb.options = "caps:swapescape";
  console.useXkbConfig = true;

  # Enable flakes.
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  # Configure mirror.
  nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    groups.akari.gid = 1000;
    users.akari = {
      description = "Akari";
      extraGroups = [
        "wheel"
      ];
      group = "akari";
      isNormalUser = true;
      uid = 1000;
    };
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    sbctl
    git
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
