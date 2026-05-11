{
  imports = [
    ../common/configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "chii";
  system.stateVersion = "25.11";
}
