{
  imports = [
    ../../packages/common-configuration/module.nix
    ./hardware-configuration.nix
    ../../packages/mihomo-config-fetcher/module.nix
  ];

  networking.hostName = "atri";

  services.mihomo-config-fetcher.enable = true;

  system.stateVersion = "25.11";
}
