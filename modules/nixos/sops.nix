{ inputs, ... }:
{
  flake.modules.nixos.sops =
    { config, pkgs, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        defaultSopsFile = ../../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
        age = {
          sshKeyPaths = [
            "/etc/ssh/ssh_host_ed25519_key"
          ];
          keyFile = "/var/lib/sops-nix/key.txt";
          generateKey = true;
        };
        secrets = {
          password = {
            neededForUsers = true;
          };
          age-key = {
            path = "/home/felix/.config/sops/age/keys.txt";
            owner = config.users.users.felix.name;
          };
          ssh-private-key = {
            path = "/home/felix/.ssh/id_ed25519";
            owner = config.users.users.felix.name;
          };
          ssh-public-key = {
            path = "/home/felix/.ssh/id_ed25519.pub";
            owner = config.users.users.felix.name;
          };
          syncthing-cert = { };
          syncthing-key = { };
          wifi-password-home = { };
        };
      };

      environment.systemPackages = [ pkgs.sops ];
    };
}
