{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      home.sessionVariables = {
        TERMINAL = "kitty";
        TERM = "screen-256color";
      };

      home.shell.enableFishIntegration = true;
      programs.fish = {
        enable = true;
        generateCompletions = true;
        interactiveShellInit = ''
          ssh-add /home/felix/.ssh/id_ed25519
          fastfetch
        '';
        plugins = [
          {
            name = "fish-ssh-agent";
            src = pkgs.fetchFromGitHub {
              owner = "danhper";
              repo = "fish-ssh-agent";
              rev = "f10d95775352931796fd17f54e6bf2f910163d1b";
              sha256 = "sha256-cFroQ7PSBZ5BhXzZEKTKHnEAuEu8W9rFrGZAb8vTgIE=";
            };
          }
        ];
        shellInitLast = ''
          devenv hook fish | source
          direnv hook fish | source
          export DIRENV_LOG_FORMAT=""
        '';
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.nh = {
        enable = true;
        flake = "/home/felix/.dotfiles"; # sets NH_OS_FLAKE variable for you
      };
    };
}
