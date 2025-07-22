{
  description = "My first flake!";

  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

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
      nur,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      nixosConfigurations.nixos-laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; }; # allows access to flake inputs in nixos modules
        modules = [
          {
            nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
              (final: _prev: {
                stablepkgs = import nixpkgs-stable {
                  system = final.system;
                  config.allowUnfree = true;
                };
              })
              (final: _prev: {
                nur = import nur {
                  system = final.system;
                  config.allowUnfree = true;
                };
              })
            ];
          }
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true; # makes hm use nixos's pkgs value
            home-manager.extraSpecialArgs = { inherit inputs; }; # allows access to flake inputs in hm modules
            home-manager.users.felix.imports = [ ./home.nix ];
            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
          }
          disko.nixosModules.disko
          #inputs.nixos-facter-modules.nixosModules.facter
          #{ config.facter.reportPath = ./facter.json; }
        ];
      };
    };
}
