{
  description = "My first flake!";

  nixConfig = {
    extra-substituters = [
      "https://therobot2105.cachix.org"
    ];
    extra-trusted-public-keys = [
      "therobot2105.cachix.org-1:RX3o93UfxJFGbsvHxthPnVYAs2FnL7H6V7N9VUh4AnQ="
    ];
  };

  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #hyprland.url = "github:hyprwm/Hyprland";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules = {
      url = "github:nix-community/nixos-facter-modules";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      disko,
      home-manager,
      plasma-manager,
      nix-vscode-extensions,
      nix4vscode,
      nur,
      nix-index-database,
      zen-browser,
      ...
    }@inputs:
    let

    in
    {
      nixosConfigurations.nixos-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # allows access to flake inputs in nixos modules
        modules = [
          {
            nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
              nix4vscode.overlays.default
              (final: _prev: {
                stablepkgs = import nixpkgs-stable {
                  stdenv.hostPlatform.system = final.stdenv.hostPlatform.system;
                  config.allowUnfree = true;
                };
              })
            ];
          }
          ./configuration.nix

          nix-index-database.nixosModules.default

          nur.modules.nixos.default

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "backup";
              useGlobalPkgs = true; # makes hm use nixos's pkgs value
              extraSpecialArgs = { inherit inputs; }; # allows access to flake inputs in hm modules
              users.felix.imports = [ ./home.nix ];
              sharedModules = [ plasma-manager.homeModules.plasma-manager ];
            };
          }
          disko.nixosModules.disko
          inputs.nixos-facter-modules.nixosModules.facter
          { config.facter.reportPath = ./facter.json; }
        ];
      };
    };
}
