# Bindet home-manager als NixOS-Modul ein. Benutzer hängen ihre
# `flake.modules.homeManager.*`-Module selbst ein (siehe ../users).
{ inputs, ... }:
{
  flake.modules.nixos.home-manager = { ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true; # makes hm use nixos's pkgs value
      backupFileExtension = "backup";
      # Plasma überschreibt z. B. ~/.gtkrc-2.0 selbst; alte .backup-Dateien
      # dürfen ersetzt werden, sonst scheitert die Aktivierung.
      overwriteBackup = true;
      sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
    };
  };
}
