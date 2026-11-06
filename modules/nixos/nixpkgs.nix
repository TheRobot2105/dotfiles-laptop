{ inputs, ... }:
{
  flake.modules.nixos.nixpkgs = {
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      overlays = [
        inputs.nix-vscode-extensions.overlays.default
        inputs.nix4vscode.overlays.default
        (final: _prev: {
          stablepkgs = import inputs.nixpkgs-stable {
            stdenv.hostPlatform.system = final.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        })
        (final: prev: {
          buildGo125Module = prev.buildGoModule;
        })
      ];
    };
  };
}
