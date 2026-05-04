{
  lib,
  config,
  ...
}:
{
  programs.neovim = {
    enable = true;
    configure = {
      customRC = ''
        luafile ${../nvim-config/init.lua}
      '';
    };
  };
}
