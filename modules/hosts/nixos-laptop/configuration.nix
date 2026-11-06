# Host-Definition: Setzt den Laptop aus den einzelnen Feature-Modulen zusammen.
{ config, inputs, ... }:
{
  configurations.nixos.nixos-laptop.module = {
    imports = with config.flake.modules.nixos; [
      nixos-laptop

      nixpkgs
      nix
      boot
      sops
      networking
      locale
      plasma
      audio
      printing
      fonts
      packages
      apps
      nix-ld
      android-dev
      syncthing
      virtualisation
      gaming
      tailscale
      flatpak
      home-manager
      felix
    ];
  };

  flake.modules.nixos.nixos-laptop = {
    imports = [
      inputs.disko.nixosModules.disko
      inputs.nixos-facter-modules.nixosModules.facter
    ];

    facter.reportPath = ./facter.json;

    networking.hostName = "nixos-laptop";
    nixpkgs.hostPlatform.system = "x86_64-linux";

    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.bluetooth.enable = true;
    zramSwap.enable = true;
    services.power-profiles-daemon.enable = true;
    services.fwupd.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
