{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = "
    ";
    mouse = true;
    newSession = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catpuccin-flavour 'mocha'
        '';
      }
    ];
    shell = "${pkgs.fish}/bin/fish";
  };
}
