{
  config,
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        "$terminal"
        "nm-applet &"
        "waybar & hyprpaper & firefox"
      ];
      input = {
        kb_layout = "de";
        touchpad = {
          natural_scroll = true;
        };
      };
      monitor = "eDP-1,1920x1080@120,0x0,1";
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      bind =
        [
          "$mod, F, exec, firefox"
          "$mod, Q, exec, $terminal"
          "$mod, C, killactive,"
          "$mod, E, exec, $fileManager"
          "$mod, M, exit,"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );
    };
    plugins = with pkgs.hyprlandPlugins; [

    ];
  };
}
