{ inputs, ... }:
{
  flake.modules.nixos.nix = {
    imports = [ inputs.nix-index-database.nixosModules.default ];

    nix = {
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [ "@wheel" ];
        substituters = [
          "https://cache.nixos.org/"
          "https://therobot2105.cachix.org"
        ];
        trusted-public-keys = [
          "therobot2105.cachix.org-1:RX3o93UfxJFGbsvHxthPnVYAs2FnL7H6V7N9VUh4AnQ="
        ];
      };
    };

    programs.nix-index-database.comma.enable = true;
  };
}
