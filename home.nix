{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./user-config/vscode.nix
    ./user-config/plasma.nix
    ./user-config/tmux.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "felix";
  home.homeDirectory = "/home/felix";
  #nixpkgs = {
  #  config = {
  #    allowUnfree = true;
  #    allowUnfreePredicate = _: true;
  #  };
  #};
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      thunderbird
      ltex-ls-plus
      qalculate-qt
      spotify
      libreoffice
      obsidian
      qbittorrent
      kdePackages.filelight
      inkscape
      libation
      fastfetch
      fira-code
      drawio
      vlc
      #bitwarden-desktop
      age
      shfmt
      julia-bin
      heroic
      dbeaver-bin
      prismlauncher
      zoom-us
      cryptomator
      jabref
      openscad-unstable
      just
      just-lsp
      teamspeak6-client
      nodejs
      rendercv
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      radiotray-ng
      rapid-photo-downloader
      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ]
    ++ (with pkgs.stablepkgs; [
      #jabref
    ])
    ++ (with pkgs.nur.repos; [
      #therobot2105.vivado-2020_1
    ]);
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/nixpkgs" = {
      source = ./nixpkgsconf;
      recursive = true;
    };
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/felix/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nano";
    TERMINAL = "kitty";
    TERM = "screen-256color";
  };

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
  programs.nh = {
    enable = true;
    flake = "/home/felix/.dotfiles"; # sets NH_OS_FLAKE variable for you
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
      direnv hook fish | source
      export DIRENV_LOG_FORMAT=""
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  xsession.numlock.enable = true;

  programs.kitty = {
    enable = true;
    font.name = ''family="Fira Code"'';
    shellIntegration.enableFishIntegration = true;
    themeFile = "Catppuccin-Mocha";
    settings = {
      scrollback_lines = 10000;
      shell = "fish";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
    };
  };

  programs.konsole = {
    enable = true;
    defaultProfile = "fish";
    profiles.fish = {
      command = "tmux";
    };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
