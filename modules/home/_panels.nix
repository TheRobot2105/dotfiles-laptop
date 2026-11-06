# Nicht eingebunden (Entwurf).
{
  flake.modules.homeManager.panels = { ... }: {
    programs.plasma = {
      panels = {
        taskbar = {
          aligment = "center";

        };
      };
    };
  };
}
