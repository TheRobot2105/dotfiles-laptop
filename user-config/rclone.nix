#rclone.nix
{ config, pkgs, ... }:
{

  xdg.configFile."rclone/rclone-nix.conf".text = ''
    [pCopypartyTest-dav]
    type = webdav
    url = http://192.168.178.173:3923
    vendor = owncloud
    pacer_min_sleep = 0.01ms
    user = k
    pass = FAOr18PmW_XCzljtFq2A1uinVqg
  '';
  home = {
    packages = [ pkgs.rclone ];
    shellAliases = {
      "reload-rclone" = "systemctl --user restart rCloneMounts.service";
    };
  };

  systemd.user.services.rCloneMounts = {
    Unit = {
      Description = "Mount all rClone configurations";
      After = [ "network-online.target" ];
    };
    Service =
      let
        home = config.home.homeDirectory;
      in
      {
        Type = "forking";
        ExecStartPre = "${pkgs.writeShellScript "rClonePre" ''
          remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone-nix.conf listremotes)
          for remote in $remotes;
          do
          name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
          /usr/bin/env mkdir -p ${home}/"$name"
          done
        ''}";

        ExecStart = "${pkgs.writeShellScript "rCloneStart" ''
          remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone-nix.conf listremotes)
          for remote in $remotes;
          do
          name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
          ${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone-nix.conf --vfs-cache-mode writes --dir-cache-time 5s --ignore-checksum mount "$remote": "$name" &
          done
        ''}";

        ExecStop = "${pkgs.writeShellScript "rCloneStop" ''
          remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone-nix.conf listremotes)
          for remote in $remotes;
          do
          name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
          /usr/bin/env fusermount -u ${home}/"$name"
          done
        ''}";
      };
    Install.WantedBy = [ "default.target" ];
  };
}
