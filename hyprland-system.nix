{ inputs, pkgs, ... }:
{
  networking.networkmanager.enable = false;
  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    networks = {

      "Mühle" = {
        # safe version of the above: read PSK from the
        pskRaw = "ext:psk_muehle"; # variable psk_echelon, defined in secretsFile,
      }; # this won't leak into /nix/store
    };
    secretsFile = "/home/felix/.dotfiles/wifi.secret";
  };
  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}
