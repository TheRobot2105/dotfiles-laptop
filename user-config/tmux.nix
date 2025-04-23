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

    ];
    shell = "${pkgs.fish}/bin/fish";
  };
}
