{
  flake.modules.homeManager.kitty = {
    programs.kitty = {
      enable = true;
      font.name = ''family="Fira Code"'';
      shellIntegration.enableFishIntegration = true;
      themeFile = "Catppuccin-Mocha";
      settings = {
        scrollback_lines = 10000;
        shell = "fish";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
      };
    };

    programs.konsole.enable = true;
  };
}
