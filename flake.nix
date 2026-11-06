{
  description = "NixOS-Konfiguration (Dendritic Pattern)";

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

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
    juliaup-nix = {
      url = "github:s-celles/juliaup-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    omnibin = {
      url = "github:fzakaria/omnibin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wallpaper = {
      type = "git";
      url = "ssh://git@github.com/therobot2105/wallpaper";
      lfs = true;
      flake = false;
    };

  };

  # Dendritic Pattern: Jede Datei unter ./modules ist ein flake-parts-Modul.
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
