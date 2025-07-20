{
  pkgs,
  ...
}:
{

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-marketplace; [
        # * https://raw.githubusercontent.com/nix-community/nix-vscode-extensions/master/data/cache/vscode-marketplace-latest.json
        jnoortheen.nix-ide
        ltex-plus.vscode-ltex-plus
        james-yu.latex-workshop
        #hirse.vscode-ungit
        #github.vscode-github-actions
        #hiukky.flate
        github.codespaces
        johnpapa.winteriscoming
        myriad-dreamin.tinymist
        #catppuccin.catppuccin-vsc-icons
        pkief.material-icon-theme
        #platformio.platformio-vscode-ide
        #ms-vscode.cpptools
        #eamodio.gitlens
        mads-hartmann.bash-ide-vscode
        timonwong.shellcheck
        mkhl.shfmt
        editorconfig.editorconfig
        aaron-bond.better-comments
        natqe.reload
        julialang.language-julia
      ];
      userSettings = {
        "extensions.autoUpdate" = false;
        "chat.commandCenter.enabled" = false;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "latex-workshop.formatting.latex" = "latexindent";
        "better-comments.tags" = [
          {
            "tag" = "*";
            "color" = "#00ff00";
            "strikethrough" = false;
            "underline" = false;
            "backgroundColor" = "transparent";
            "bold" = false;
            "italic" = false;
          }
        ];
        "ltex.language" = "de-DE";
        "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          nixd = {
            formatting = {
              command = [
                "nix fmt"
              ];
            };
            options = {
              home_manager = {
                expr = "(builtins.getFlake \"/home/felix/.dotfiles/\").nixosConfigurations.nixos-laptop.options.home-manager.users.type.getSubOptions []";
              };
              nixos = {
                expr = "(builtins.getFlake \"/home/felix/.dotfiles/\").nixosConfigurations.nixos-laptop.options";
              };
            };
          };
        };
        "security.workspace.trust.untrustedFiles" = "open";
        "ungit.showButton" = true;
        "ungit.showInActiveColumn" = true;
        "workbench.colorTheme" = "Winter is Coming (Dark Blue)";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.startupEditor" = "none";
        "latex-workshop.latex.autoBuild.run" = "never";
        "terminal.integrated.defaultProfile.linux" = "fish";
        "editor.fontFamily" = "Fira Code";
        "editor.fontLigatures" = true;

        "tinymist.exportPdf" = "onSave";
        "tinymist.lint.when" = "onType";
        "tinymist.preview.scrollSync" = "onSelectionChange";
        "[shellscript]" = {
          "editor.defaultFormatter" = "mkhl.shfmt";
        };
        "terminal.integrated.commandsToSkipShell" = [
          "language-julia.interrupt"
        ];
        "julia.symbolCacheDownload" = true;
        "julia.enableTelemetry" = false;
      };
    };
  };
}
