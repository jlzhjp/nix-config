{
  imports = [
    ../common/configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "atri";
  system.stateVersion = "25.11";
}
