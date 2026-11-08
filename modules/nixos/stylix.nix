# Systemweites Theming mit Stylix (Catppuccin Mocha).
# Das NixOS-Modul importiert das home-manager-Modul automatisch
# (stylix.homeManagerIntegration.autoImport = true).
{ inputs, ... }:
{
  flake.modules.nixos.stylix =
    { pkgs, ... }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = {
        enable = true;
        autoEnable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/outrun-dark.yaml";

        # Eigener Plymouth-Bootscreen (deus_ex) aus boot.nix bleibt.
        targets.plymouth.enable = false;

        # gtksourceview-Overlay würde Inkscape & Co. aus dem Cache werfen.
        targets.gtksourceview.enable = false;

        # Kein stylix.image: Desktop und Sperrbildschirm behalten die
        # Wallpaper-Slideshow aus modules/home/plasma.nix.

        fonts = {
          monospace = {
            # Nerd-Font-Variante: enthält die Icons für lualine, gitsigns & Co.
            package = pkgs.nerd-fonts.fira-code;
            name = "FiraCode Nerd Font Mono";
          };
          sansSerif = {
            package = pkgs.liberation_ttf;
            name = "Liberation Sans";
          };
          serif = {
            package = pkgs.liberation_ttf;
            name = "Liberation Serif";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };

        cursor = {
          package = pkgs.kdePackages.breeze;
          name = "breeze_cursors";
          size = 24;
        };
      };
    };
}
