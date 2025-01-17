{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "felix";
  home.homeDirectory = "/home/felix";
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
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
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    hello
    kdePackages.kate
    thunderbird
    texstudio
    discord-ptb
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
    # EDITOR = "emacs";
  };
  programs.vscode = {
    enable = true;
    userSettings = {
      "nix.serverPath" = "nixd";
      "nix.enableLanguageServer" = true;
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = [
              "alejandra"
            ];
          };
          "options" = {
            "nixos" = {
              "expr" = "(builtins.getFlake \"/home/felix/.dotfiles/\").nixosConfigurations.nixos-laptop.options";
            };
            "home_manager" = {
              "expr" = "(builtins.getFlake \"/home/felix/.dotfiles/\").homeConfigurations.felix.options";
            };
          };
        };
      };
      "security.workspace.trust.untrustedFiles" = "open";
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "latex-workshop.latex.recipes" = [
        {
          name = "THM-Recipe";
          tools = [
            "xelatex"
            "biber"
            "makeglossaries"
            "xelatex"
            "xelatex"
          ];
        }
        {
          name = "latexmk";
          tools = [
            "latexmk"
          ];
        }
        {
          name = "latexmk (latexmkrc)";
          tools = [
            "latexmk_rconly"
          ];
        }
        {
          name = "latexmk (lualatex)";
          tools = [
            "lualatexmk"
          ];
        }
        {
          name = "latexmk (xelatex)";
          tools = [
            "xelatexmk"
          ];
        }
        {
          name = "pdflatex -> bibtex -> pdflatex * 2";
          tools = [
            "pdflatex"
            "bibtex"
            "pdflatex"
            "pdflatex"
          ];
        }
        {
          name = "Compile Rnw files";
          tools = [
            "rnw2tex"
            "latexmk"
          ];
        }
        {
          name = "Compile Jnw files";
          tools = [
            "jnw2tex"
            "latexmk"
          ];
        }
        {
          name = "Compile Pnw files";
          tools = [
            "pnw2tex"
            "latexmk"
          ];
        }
        {
          name = "tectonic";
          tools = [
            "tectonic"
          ];
        }
      ];
      "latex-workshop.latex.tools" = [
        {
          name = "latexmk";
          command = "latexmk";
          args = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
            "-pdf"
            "-outdir=%OUTDIR%"
            "%DOC%"
          ];
          env = {};
        }
        {
          name = "lualatexmk";
          command = "latexmk";
          args = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
            "-lualatex"
            "-outdir=%OUTDIR%"
            "%DOC%"
          ];
          env = {};
        }
        {
          name = "xelatexmk";
          command = "latexmk";
          args = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
            "-xelatex"
            "-outdir=%OUTDIR%"
            "%DOC%"
          ];
          env = {};
        }
        {
          name = "xelatex";
          command = "xelatex";
          args = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
            "-shell-escape"
            "%DOC%"
          ];
          env = {};
        }
        {
          name = "biber";
          command = "biber";
          args = [
            "%DOCFILE%"
          ];
          env = {};
        }
        {
          name = "makeglossaries";
          command = "makeglossaries";
          args = [
            "%DOCFILE%"
          ];
          env = {};
        }
        {
          name = "latexmk_rconly";
          command = "latexmk";
          args = [
            "%DOC%"
          ];
          env = {};
        }
        {
          name = "pdflatex";
          command = "pdflatex";
          args = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
            "%DOC%"
          ];
          env = {};
        }
        {
          name = "bibtex";
          command = "bibtex";
          args = [
            "%DOCFILE%"
          ];
          env = {};
        }
        {
          name = "rnw2tex";
          command = "Rscript";
          args = [
            "-e"
            "knitr::opts_knit$set(concordance = TRUE); knitr::knit('%DOCFILE_EXT%')"
          ];
          env = {};
        }
        {
          name = "jnw2tex";
          command = "julia";
          args = [
            "-e"
            "using Weave; weave(\"%DOC_EXT%\", doctype=\"tex\")"
          ];
          env = {};
        }
        {
          name = "jnw2texminted";
          command = "julia";
          args = [
            "-e"
            "using Weave; weave(\"%DOC_EXT%\", doctype=\"texminted\")"
          ];
          env = {};
        }
        {
          name = "pnw2tex";
          command = "pweave";
          args = [
            "-f"
            "tex"
            "%DOC_EXT%"
          ];
          env = {};
        }
        {
          name = "pnw2texminted";
          command = "pweave";
          args = [
            "-f"
            "texminted"
            "%DOC_EXT%"
          ];
          env = {};
        }
        {
          name = "tectonic";
          command = "tectonic";
          args = [
            "--synctex"
            "--keep-logs"
            "--print"
            "%DOC%.tex"
          ];
          env = {};
        }
      ];
    };
  };
  programs.git = {
    enable = true;
    userEmail = "felix.kimmel@web.de";
    userName = "Felix Kimmel";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  programs.kitty = {
    enable = true;
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
