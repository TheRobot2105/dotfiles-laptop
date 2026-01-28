{
  description = "My first flake!";

  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

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

    cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      disko,
      sops-nix,
      home-manager,
      plasma-manager,
      nix-vscode-extensions,
      nixos-facter-modules,
      cachix-deploy-flake,
      nur,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (system: {
      defaultPackage =
        let
          pkgs = import nixpkgs { inherit system; };
          cachix-deploy-lib = cachix-deploy-flake.lib pkgs;
        in
        cachix-deploy-lib.spec {
          agents = {
            nixos-laptop = cachix-deploy-lib.nixos {
              specialArgs = { inherit inputs; }; # allows access to flake inputs in nixos modules
              modules = [
                {
                  nixpkgs.overlays = [
                    inputs.nix-vscode-extensions.overlays.default
                    (final: _prev: {
                      stablepkgs = import nixpkgs-stable {
                        stdenv.hostPlatform.system = final.stdenv.hostPlatform.system;
                        config.allowUnfree = true;
                      };
                    })
                  ];
                }
                ./configuration.nix

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
        };
    });
}
