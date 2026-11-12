# Systemweites Theming mit Stylix ("Winter Is Coming", nach dem VS-Code-Theme).
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
        # Base16-Nachbau von "Winter Is Coming (Dark Blue)" aus VS Code.
        # Die ANSI-Farben (08/0A/0B/0C/0D/0E) folgen dem Terminal-Schema des
        # Themes, die übrigen Slots den Syntax-/UI-Farben des Editors.
        base16Scheme = {
          scheme = "Winter Is Coming";
          author = "nach John Papa (VS Code), base16 von Felix";
          base00 = "011627"; # editor.background
          base01 = "0b2942"; # tab.activeBackground / editorWidget
          base02 = "103362"; # editor.selectionBackground
          base03 = "5f7e97"; # Kommentare, Zeilennummern, ansiBrightBlack
          base04 = "7799bb"; # sideBar.foreground
          base05 = "d6deeb"; # foreground
          base06 = "eeefff"; # titleBar.activeForeground
          base07 = "ffffff"; # ansiBrightWhite
          base08 = "ef5350"; # ansiRed / Fehler
          base09 = "8dec95"; # Zahlen, Booleans
          base0A = "f7ecb5"; # Klassen, Attribute, ansiYellow
          base0B = "bcf0c0"; # Strings
          base0C = "7fdbca"; # Support-Typen, Instanzvariablen
          base0D = "219fd5"; # Akzentfarbe, ansiBlue
          base0E = "c792ea"; # Storage, ansiMagenta
          base0F = "ec9cd2"; # Library-Konstanten
        };

        # Eigener Plymouth-Bootscreen (deus_ex) aus boot.nix bleibt.
        #targets.plymouth.enable = false;

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
