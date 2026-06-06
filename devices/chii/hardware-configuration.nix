{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
      luks.devices = {
        "cryptroot".device = "/dev/disk/by-uuid/80376b50-6e84-44da-8f03-80b05e73f451";
        "cryptdata".device = "/dev/disk/by-uuid/77f8ddc9-0c6d-483a-af27-45f0a4e53455";
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/5494-3ACF";
      fsType = "vfat";
      options = [
        "fmask=0177"
        "dmask=0077"
      ];
    };

    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "noatime"
        "compress=zstd:3"
      ];
    };

    "/home" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "noatime"
        "compress=zstd:3"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "noatime"
        "compress=zstd:3"
      ];
    };

    "/mnt/data/home" = {
      device = "/dev/mapper/cryptdata";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "noatime"
        "compress=zstd:3"
      ];
    };
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
