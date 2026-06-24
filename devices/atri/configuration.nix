{ pkgs, ... }:

let
  lidEvent = pkgs.writeShellApplication {
    name = "atri-lid-event";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.evemu
      pkgs.gnugrep
    ];
    text = ''
      state_path=/proc/acpi/button/lid/LID0/state
      event_path=/dev/input/by-path/pci-0000:00:14.3-platform-PNP0C0D:00-event

      read_state() {
        if grep -q closed "$state_path"; then
          printf closed
        else
          printf open
        fi
      }

      while [ ! -e "$event_path" ]; do
        sleep 1
      done

      last_state="$(read_state)"

      while true; do
        sleep 1
        state="$(read_state)"

        if [ "$state" = "$last_state" ]; then
          continue
        fi

        case "$state" in
          closed)
            evemu-event --sync "$event_path" --type EV_SW --code SW_LID --value 1
            ;;
          open)
            evemu-event --sync "$event_path" --type EV_SW --code SW_LID --value 0
            ;;
        esac

        last_state="$state"
      done
    '';
  };
in

{
  imports = [
    ../../packages/common-configuration/module.nix
    ./hardware-configuration.nix
    ../../packages/mihomo-config-fetcher/module.nix
  ];

  networking.hostName = "atri";

  services.mihomo-config-fetcher.enable = true;

  systemd.services.atri-lid-event = {
    description = "Generate missing SW_LID events from ACPI lid state";
    after = [ "systemd-udevd.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${lidEvent}/bin/atri-lid-event";
      Restart = "always";
      RestartSec = "30s";
    };
  };

  system.stateVersion = "25.11";
}
