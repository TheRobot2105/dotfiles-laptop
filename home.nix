{
  pkgs,
  ...
}:
{
  imports = [
    ./user-config/vscode.nix
    #./user-config/hyprland.nix
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
  home.packages = with pkgs; [
    thunderbird
    discord-ptb
    kicad-small
    nextcloud-client
    ltex-ls-plus
    qalculate-qt
    gcr
    spotify
    #github-desktop
    element-desktop
    zoom-us
    libreoffice
    obsidian
    qbittorrent
    kdePackages.filelight
    jabref
    inkscape
    kronometer
    libation
    teamspeak6-client
    fastfetch
    fira-code
    #networkmanagerapplet
    gnome-multi-writer
    drawio
    vlc
    pgadmin4-desktopmode
    geogebra6
    kiwix
    screen
    nixpkgs-lint-community
    gitkraken
    gitflow
    spyder
    spice
    virt-viewer
    spice-gtk
    #renpy
    bitwarden
    age
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
  ];
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
    userEmail = "felix.kimmel@web.de";
    userName = "Felix Kimmel";
    extraConfig = {
      init.defaultBranch = "main";
      commit.gpgsign = false;
    };
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
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
  };

  xsession.numlock.enable = true;

  programs.kitty = {
    enable = true;
    font.name = ''family="Fira Code"'';
    shellIntegration.enableFishIntegration = true;
    themeFile = "Catppuccin-Mocha";
    settings = {
      scrollback_lines = 10000;
      shell = "tmux";
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
