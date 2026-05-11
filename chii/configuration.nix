{
  imports = [
    ../common/configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "chii";

  systemd.tmpfiles.rules = [
    "d /mnt/data/home 0755 root root -"
    "d /mnt/data/home/akari/Desktop 0755 akari akari -"
    "d /mnt/data/home/akari/Documents 0755 akari akari -"
    "d /mnt/data/home/akari/Downloads 0755 akari akari -"
    "d /mnt/data/home/akari/Music 0755 akari akari -"
    "d /mnt/data/home/akari/Pictures 0755 akari akari -"
    "d /mnt/data/home/akari/Public 0755 akari akari -"
    "d /mnt/data/home/akari/Templates 0755 akari akari -"
    "d /mnt/data/home/akari/Videos 0755 akari akari -"
    "L /home/akari/Desktop - - - - /mnt/data/home/akari/Desktop"
    "L /home/akari/Documents - - - - /mnt/data/home/akari/Documents"
    "L /home/akari/Downloads - - - - /mnt/data/home/akari/Downloads"
    "L /home/akari/Music - - - - /mnt/data/home/akari/Music"
    "L /home/akari/Pictures - - - - /mnt/data/home/akari/Pictures"
    "L /home/akari/Public - - - - /mnt/data/home/akari/Public"
    "L /home/akari/Templates - - - - /mnt/data/home/akari/Templates"
    "L /home/akari/Videos - - - - /mnt/data/home/akari/Videos"
  ];

  system.stateVersion = "25.11";
}
