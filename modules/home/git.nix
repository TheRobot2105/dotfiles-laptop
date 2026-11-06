{
  flake.modules.homeManager.git = { ... }: {
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        init.defaultBranch = "main";
        commit.gpgsign = false;
        user.Email = "felix.kimmel@web.de";
        user.Name = "Felix Kimmel";
        push.autoSetupRemote = true;
      };
      signing.format = null;
    };
  };
}
