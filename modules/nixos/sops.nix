{ inputs, ... }:
{
  flake.modules.nixos.sops =
    { pkgs, ... }:
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
          syncthing-cert = { };
          syncthing-key = { };
          wifi-password-home = { };
        };
      };

      environment.systemPackages = [ pkgs.sops ];
    };
}
