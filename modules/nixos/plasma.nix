{
  flake.modules.nixos.plasma =
    { pkgs, ... }:
    {
      # You can disable this if you're only using the Wayland session.
      services.xserver.enable = true;

      services.displayManager.plasma-login-manager.enable = true;
      services.desktopManager.plasma6.enable = true;

      programs.kdeconnect.enable = true;

      environment.systemPackages = with pkgs; [
        kdePackages.partitionmanager
        syncthingtray
      ];
    };
}
