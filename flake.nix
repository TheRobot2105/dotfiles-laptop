{
  description = "My first flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # use the following for unstable:
    # nixpkgs.url = "nixpkgs/nixos-unstable";

    # or any branch you want:
    # nixpkgs.url = "nixpkgs/{BRANCH-NAME}";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    system ="x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      nixos-laptop = lib.nixosSystem {
        specialArgs = {inherit inputs;};
        inherit system ;
        modules = [./configuration.nix];
      };
    };
      homeConfigurations = {
        felix = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {inherit inputs;};
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
    };
}
