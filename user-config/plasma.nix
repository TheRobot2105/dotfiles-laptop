{
  ...
}:
{
  programs.plasma = {
    enable = true;
    configFile.kcminputrc.Keyboard.NumLock.value = 0; 
    workspace = {
      wallpaperSlideShow = {
        path = [ "/home/felix/.dotfiles/wallpaper/" ];
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
        }
      ];
    };
    session = {
      general.askForConfirmationOnLogout = false;
    };
    kscreenlocker = {
      appearance = {
        wallpaperSlideShow = {
          path = [ "/home/felix/.dotfiles/wallpaper/" ];
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
