# Benutzer felix: NixOS-Account + home-manager-Profil.
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.felix =
    { config, ... }:
    {
      users.mutableUsers = false;
      users.users.felix = {
        isNormalUser = true;
        description = "Felix Kimmel";
        hashedPasswordFile = config.sops.secrets.password.path;
        extraGroups = [
          "networkmanager"
          "wheel"
          "dialout"
        ];
      };

      # Schlüssel von felix: age (für sops als Benutzer) und SSH
      sops.secrets = {
        age-key = {
          path = "/home/felix/.config/sops/age/keys.txt";
          owner = config.users.users.felix.name;
        };
        ssh-private-key-laptop = {
          path = "/home/felix/.ssh/id_ed25519";
          owner = config.users.users.felix.name;
        };
        ssh-public-key-laptop = {
          path = "/home/felix/.ssh/id_ed25519.pub";
          owner = config.users.users.felix.name;
        };
      };

      # sops-nix legt fehlende Elternordner der Secrets (~/.config/sops/age,
      # ~/.ssh) als root an. Bei einer Neuinstallation gehört ~/.config dann
      # root und home-manager scheitert mit "Permission denied".
      system.activationScripts.felixSecretDirs = {
        deps = [ "setupSecrets" ];
        text =
          let
            home = config.users.users.felix.home;
          in
          ''
            for d in ${home}/.config ${home}/.config/sops ${home}/.config/sops/age ${home}/.ssh; do
              if [ -d "$d" ]; then chown felix:users "$d"; fi
            done
            if [ -d ${home}/.ssh ]; then chmod 700 ${home}/.ssh; fi
          '';
      };

      home-manager.users.felix.imports = [ hm.felix ];
    };

  flake.modules.homeManager.felix = { ... }: {
    imports = with hm; [
      packages
      shell
      git
      kitty
      sioyek
      vscode
      plasma
      tmux
      nvim
    ];

    home.username = "felix";
    home.homeDirectory = "/home/felix";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "24.11"; # Please read the comment before changing.

    home.file.".config/nixpkgs" = {
      source = ../../nixpkgsconf;
      recursive = true;
    };

    xsession.numlock.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
