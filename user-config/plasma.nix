{
  lib,
  config,
  pkgs,
  ...
}:
let
  # NieR:Automata palette (r,g,b)
  beige = "218,212,187";
  beigeAlt = "205,200,176";
  beigeLight = "230,226,210";
  taupe = "78,75,66";
  taupeDark = "58,56,49";
  muted = "137,133,118";
  red = "205,102,77";

  colorGroup =
    {
      bg,
      bgAlt,
      fg,
      fgInactive,
      accent,
    }:
    {
      BackgroundNormal = bg;
      BackgroundAlternate = bgAlt;
      ForegroundNormal = fg;
      ForegroundInactive = fgInactive;
      ForegroundActive = accent;
      ForegroundLink = accent;
      ForegroundVisited = fgInactive;
      ForegroundNegative = red;
      ForegroundNeutral = "176,128,48";
      ForegroundPositive = "96,128,72";
      DecorationFocus = accent;
      DecorationHover = accent;
    };

  light = {
    bg = beige;
    bgAlt = beigeAlt;
    fg = taupe;
    fgInactive = muted;
    accent = taupe;
  };
  dark = {
    bg = taupe;
    bgAlt = taupeDark;
    fg = beige;
    fgInactive = beigeAlt;
    accent = beige;
  };

  mkColors =
    name: base: inverse:
    lib.generators.toINI { } {
      General = {
        Name = name;
        ColorScheme = name;
      };
      "Colors:Window" = colorGroup base;
      "Colors:View" = colorGroup (base // { bg = if base == light then beigeLight else taupeDark; });
      "Colors:Button" = colorGroup (base // { bg = base.bgAlt; });
      "Colors:Selection" = colorGroup inverse;
      "Colors:Header" = colorGroup dark;
      "Colors:Tooltip" = colorGroup dark;
      "Colors:Complementary" = colorGroup (dark // { bg = taupeDark; });
      WM = {
        activeBackground = taupe;
        activeForeground = beige;
        activeBlend = beige;
        inactiveBackground = beigeAlt;
        inactiveForeground = muted;
        inactiveBlend = muted;
      };
      KDE.contrast = 4;
    };
in
{
  # Futura-like font, close to the in-game UI font
  fonts.fontconfig.enable = true;
  home.packages = [ pkgs.jost ];

  # app colors: beige windows with dark headers
  xdg.dataFile."color-schemes/NierAutomata.colors".text = mkColors "NierAutomata" light dark;

  # plasma theme: recolored Breeze (missing svgs fall back to "default"), dark taupe panels
  xdg.dataFile."plasma/desktoptheme/nier-automata/colors".text =
    mkColors "NierAutomataDark" dark light;
  xdg.dataFile."plasma/desktoptheme/nier-automata/metadata.json".text = builtins.toJSON {
    KPlugin = {
      Id = "nier-automata";
      Name = "NieR:Automata";
      Description = "Breeze recolored in NieR:Automata colors";
      License = "GPL";
      Version = "1.0";
      Authors = [ { Name = "felix"; } ];
    };
    X-Plasma-API-Minimum-Version = "6.0";
  };

  programs.plasma = {
    panels = [
      # bottom taskbar
      {
        location = "bottom";
        hiding = "none";
        height = 48;
        floating = false;
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
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
            systemTray.items = {
              hidden = [
                "Yakuake"
                "KGpg"
                "Wallet Manager"
                "org.kde.plasma.keyboardlayout"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.battery"
              ];
              shown = [
                "martchus.syncthingplasmoid"
                "org.kde.plasma.clipboard"
                "org.kde.plasma.volume"
                "org.kde.plasma.brightness"
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
      # top bar: battery "health bar" + desktop tiles
      {
        location = "top";
        hiding = "none";
        height = 64;
        floating = false;
        widgets = [
          "org.kde.plasma.battery"
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
              expanding = true;
            };
          }
        ];
      }
    ];
    desktop.widgets = [
      {
        systemMonitor = {
          title = "Status";
          displayStyle = "org.kde.ksysguard.horizontalbars";
          position = {
            horizontal = 440;
            vertical = 180;
          };
          size = {
            width = 320;
            height = 340;
          };
          sensors = [
            {
              name = "cpu/all/usage";
              color = taupe;
              label = "CPU";
            }
            {
              name = "memory/physical/used";
              color = taupe;
              label = "RAM";
            }
            {
              name = "memory/swap/used";
              color = taupe;
              label = "SWAP";
            }
            {
              name = "disk/all/used";
              color = taupe;
              label = "DISK";
            }
          ];
        };
      }
      {
        name = "org.kde.plasma.notes";
        position = {
          horizontal = 800;
          vertical = 180;
        };
        size = {
          width = 260;
          height = 280;
        };
      }
      {
        name = "org.kde.plasma.digitalclock";
        position = {
          horizontal = 1480;
          vertical = 150;
        };
        size = {
          width = 300;
          height = 220;
        };
        config = {
          Appearance = {
            use24hFormat = true;
            showDate = true;
            dateFormat = "longDate";
          };
        };
      }
      {
        name = "org.kde.plasma.weather";
        position = {
          horizontal = 440;
          vertical = 700;
        };
        size = {
          width = 260;
          height = 280;
        };
      }
    ];
    enable = true;
    configFile.kcminputrc.Keyboard.NumLock.value = 0;
    workspace = {
      wallpaperSlideShow = {
        path = [ "/home/felix/.dotfiles/wallpaper/wallpaper" ];
        interval = 600;
      };
      colorScheme = "NierAutomata";
      theme = "nier-automata";
      iconTheme = "breeze";
    };
    fonts =
      let
        jost = {
          family = "Jost";
          pointSize = 10;
        };
      in
      {
        general = jost;
        menu = jost;
        toolbar = jost;
        windowTitle = jost;
        small = jost // {
          pointSize = 8;
        };
      };
    kwin.virtualDesktops = {
      rows = 1;
      names = [
        "Bunker"
        "City Ruins"
        "Desert"
        "Forest"
        "Factory"
      ];
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
