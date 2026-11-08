{
  flake.modules.nixos.fonts =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        fira-code
        nerd-fonts.fira-code
        liberation_ttf
      ];
    };
}
