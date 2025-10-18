{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    cifs-utils
    davfs2
  ];

  sops.secrets = {
    davfs-copyparty = {
      mode = "0600";
      path = "/etc/davfs2/secrets";
    };
  };

  services.davfs2.enable = true;

  systemd.mounts = [
    {
      description = "Copyparty webdav mount";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      what = "https://copyparty.therobot.cloud";
      where = "/mnt/copyparty";
      options = "x-systemd.automount,uid=1000,gid=100";
      type = "davfs";
    }
  ];
  systemd.automounts = [
    {
      description = "Nextcloud webdav automount";
      where = "/mnt/copyparty";
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
        TimeoutIdleSec = "2m";
      };
    }
  ];
}
