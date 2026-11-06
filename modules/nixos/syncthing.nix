{
  flake.modules.nixos.syncthing =
    { config, ... }:
    {
      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
        group = "users";
        user = "felix";
        dataDir = "/home/felix/syncthing";
        configDir = "/home/felix/.config/syncthing";
        overrideDevices = true; # overrides any devices added or deleted through the WebUI
        overrideFolders = false;
        settings = {
          devices = {
            "Desktop" = {
              id = "JJXJFPD-DPCLLWG-JCK5QAG-65UGLLO-PRKHRDY-BKOVMAS-HWMOMY7-AOU5NQK";
            };
            "syncthing-hetzner" = {
              id = "BOWTHBY-MEXFJQT-AWPNLE2-JWYQWL4-EXRBGQX-2U2LYAC-YI4SBEJ-UMOZAA3";
            };
          };
        };
        key = config.sops.secrets.syncthing-key.path;
        cert = config.sops.secrets.syncthing-cert.path;
      };
    };
}
