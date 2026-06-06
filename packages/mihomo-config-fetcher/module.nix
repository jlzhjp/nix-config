{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.mihomo-config-fetcher;
in
{
  options.services.mihomo-config-fetcher = {
    enable = lib.mkEnableOption "Mihomo configuration fetcher";

    package = lib.mkPackageOption {
      mihomo-config-fetcher = pkgs.callPackage ./default.nix { };
    } "mihomo-config-fetcher" { };

    configFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/mihomo/config-fetcher.toml";
      description = "Path to the Mihomo config fetcher TOML configuration.";
    };

    denoCacheDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/cache/deno";
      description = "Deno cache directory used by the Mihomo config fetcher service.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.mihomo-config-fetcher = {
      description = "Fetch Mihomo configuration";
      wants = [ "network-online.target" ];
      wantedBy = [ "mihomo.service" ];
      before = [ "mihomo.service" ];
      after = [ "network-online.target" ];

      unitConfig.ConditionPathExists = cfg.configFile;

      serviceConfig = {
        Environment = [ "DENO_DIR=${cfg.denoCacheDir}" ];
        Type = "oneshot";
        ExecStart = "${lib.getExe cfg.package} ${cfg.configFile}";
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.denoCacheDir} 0755 root root -"
    ];
  };
}
