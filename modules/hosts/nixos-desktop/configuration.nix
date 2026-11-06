# Desktop-PC (AMD Radeon RX 9070 XT).
{
  config,
  inputs,
  lib,
  ...
}:
{
  configurations.nixos.nixos-desktop.module = { ... }: {
    imports = with config.flake.modules.nixos; [
      nixos-desktop

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
      stylix
      packages
      apps
      nix-ld
      virtualisation
      gaming
      tailscale
      flatpak
      home-manager
      felix
      # syncthing # TODO: braucht eigene Secrets (cert/key), sonst gleiche Geräte-ID wie der Laptop
      # android-dev
    ];
  };

  flake.modules.nixos.nixos-desktop = { ... }: {
    imports = [
      inputs.disko.nixosModules.disko
      inputs.nixos-facter-modules.nixosModules.facter
    ];

    # Auf dem Desktop erzeugen mit:
    #   sudo nix run nixpkgs#nixos-facter -- -o modules/hosts/nixos-desktop/facter.json
    facter.reportPath = lib.mkIf (builtins.pathExists ./facter.json) ./facter.json;

    networking.hostName = "nixos-desktop";
    nixpkgs.hostPlatform.system = "x86_64-linux";

    # RX 9070 XT (RDNA 4): amdgpu-Treiber, Kernel kommt bereits als linuxPackages_latest.
    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true; # Steam/Proton
    };
    hardware.amdgpu.initrd.enable = true;

    hardware.bluetooth.enable = true;
    zramSwap.enable = true;
    services.fwupd.enable = true;

    # Release der Erstinstallation, danach nicht mehr ändern.
    system.stateVersion = "26.05";
  };
}
