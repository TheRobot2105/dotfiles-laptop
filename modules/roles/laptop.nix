# Alles, was nur auf Laptops Sinn ergibt: WLAN-Profil und Touchpad.
# Der NixOS-Teil hängt den home-manager-Teil automatisch für alle Benutzer ein.
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.laptop =
    { config, ... }:
    {
      home-manager.sharedModules = [ hm.laptop ];

      networking.networkmanager.ensureProfiles = {
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

  flake.modules.homeManager.laptop = { ... }: {
    programs.plasma.input.touchpads = [
      {
        name = "ALP0019:00 044E:121C Touchpad";
        naturalScroll = true;
        productId = "121c";
        tapAndDrag = true;
        rightClickMethod = "twoFingers";
        scrollMethod = "twoFingers";
        vendorId = "044e";
        disableWhileTyping = false;
      }
    ];
  };
}
