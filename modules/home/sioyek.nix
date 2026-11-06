{
  flake.modules.homeManager.sioyek = { lib, ... }: {
    programs.sioyek = {
      enable = true;
      config = {
        "page_separator_width" = "10";
        "page_separator_color" = "0.6 0.6 0.6";
        background_color = lib.mkForce "0.6 0.6 0.6";
      };
    };
  };
}
