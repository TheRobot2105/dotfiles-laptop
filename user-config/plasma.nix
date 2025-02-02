{
  config,
  lib,
  ...
}: {
  programs.plasma = {
    enable = true;
    workspace = {
      wallpaperSlideShow = {
        path = ["/home/felix/.dotfiles/wallpaper/"];
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
  };
}
