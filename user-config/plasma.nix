{
  lib,
  config,
  ...
}:
{

  programs.plasma = {
    #TODO: remove when https://github.com/nix-community/plasma-manager/issues/577 is closed
    startup.desktopScript."panels".preCommands = lib.mkForce ''
      sleep 3
      [ -f ${config.xdg.configHome}/plasma-org.kde.plasma.desktop-appletsrc ] && rm ${config.xdg.configHome}/plasma-org.kde.plasma.desktop-appletsrc        
    '';
    panels = [
      {
        location = "bottom";
        hiding = "none";
        height = 44;
        floating = true;
        widgets = [
          {
            name = "org.kde.plasma.kickoff"; # or "org.kde.plasma.kicker"
            config = {
              General = {
                icon = "nix-snowflake-white";
              };
            };
          }
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General = {
                fill = false;
                launchers = [
                  "applications:kitty.desktop"
                  "applications:org.kde.dolphin.desktop"
                  "applications:firefox.desktop"
                  "applications:thunderbird.desktop"
                  "applications:code.desktop"
                ];
              };
            };
          }
          {
            name = "org.kde.plasma.panelspacer";
            config = {
              expanding = true;
            };
          }
          {
            name = "org.kde.plasma.pager";
            config = {
              General.displayedText = "Name";
            };
          }
          {
            name = "org.kde.plasma.panelspacer";
            config = {
              expanding = false;
            };
          }
          {
            systemTray.items = {
              hidden = [
                "Yakuake"
                "KGpg"
                "Wallet Manager"
                "org.kde.plasma.keyboardlayout"
                "org.kde.plasma.bluetooth"
              ];
              shown = [
                "martchus.syncthingplasmoid"
                "org.kde.plasma.clipboard"
                "org.kde.plasma.volume"
                "org.kde.plasma.brightness"
                "org.kde.plasma.battery"
                "org.kde.plasma.weather"
                "org.kde.plasma.networkmanagement"
                "org.kde.kdeconnect"
              ];
            };
          }
          {
            name = "org.kde.plasma.digitalclock";
            config = {
              Appearance = {
                use24hFormat = true;
              };
            };
          }
          "org.kde.plasma.showdesktop"
        ];
      }
    ];
    enable = true;
    configFile.kcminputrc.Keyboard.NumLock.value = 0;
    workspace = {
      wallpaperSlideShow = {
        path = [ "/home/felix/.dotfiles/wallpaper/wallpaper" ];
        interval = 600;
      };
      lookAndFeel = "org.kde.breezedark.desktop";
    };
    input = {
      touchpads = [
        {
          name = "ALP0019:00 044E:121C Touchpad";
          naturalScroll = true;
          productId = "121c";
          tapAndDrag = true;
          rightClickMethod = "twoFingers";
          scrollMethod = "twoFingers";
          vendorId = "044e";
          disableWhileTyping = false;
        }
      ];
    };
    session = {
      general.askForConfirmationOnLogout = false;
    };
    kscreenlocker = {
      appearance = {
        wallpaperSlideShow = {
          path = [ "/home/felix/.dotfiles/wallpaper/wallpaper" ];
          interval = 600;
        };
        alwaysShowClock = true;
        showMediaControls = false;
      };
      lockOnResume = false;
      passwordRequired = true;
      autoLock = true;
      timeout = 20;
      passwordRequiredDelay = 60;
    };
  };
}
