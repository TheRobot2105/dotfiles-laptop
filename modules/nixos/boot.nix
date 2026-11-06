{ inputs, ... }:
{
  flake.modules.nixos.boot =
    { pkgs, lib, ... }:
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        loader = {
          efi.canTouchEfiVariables = true;
          systemd-boot.enable = lib.mkForce false;
          timeout = 0;
        };
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
          autoGenerateKeys.enable = true;
          autoEnrollKeys = {
            enable = true;
            autoReboot = true;
            includeFirmwareBuiltinKeys = true;
          };
        };
        plymouth = {
          enable = true;
          theme = "deus_ex";
          themePackages = with pkgs; [
            # By default we would install all themes
            (adi1090x-plymouth-themes.override {
              selected_themes = [ "deus_ex" ];
            })
          ];
        };
        consoleLogLevel = 3;
        kernelParams = [
          "quiet"
          "rd.udev.log_level=3"
          "rd.systemd.show_status=auto"
        ];
      };

      environment.systemPackages = [ pkgs.sbctl ];
    };
}
