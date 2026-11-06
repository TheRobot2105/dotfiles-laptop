{
  flake.modules.nixos.networking =
    { config, pkgs, ... }:
    {
      networking.networkmanager = {
        enable = true;
        plugins = with pkgs; [
          networkmanager-openconnect
          networkmanager-openvpn
        ];
        ensureProfiles = {
          profiles = {
            "Home-WiFi" = {
              connection = {
                id = "Home-WiFi";
                type = "wifi";
                autoconnect = "true";
              };
              wifi = {
                ssid = "Mühle";
                mode = "infrastructure";
              };
              "wifi-security" = {
                key-mgmt = "wpa-psk";
                psk-flags = 1; # Signalisiert NM, dass ein Secret-Agent das Passwort liefert
              };
            };
          };

          # Hier greift der nm-file-secret-agent auf die sops-nix Datei zu
          secrets.entries = [
            {
              file = config.sops.secrets.wifi-password-home.path; # Dynamischer sops-Pfad (/run/secrets/...)
              key = "psk";
              matchId = "Home-WiFi";
              matchSetting = "wifi-security";
              matchType = "wifi";
            }
          ];
        };
      };
    };
}
