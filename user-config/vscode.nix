{
  pkgs,
  ...
}:
{

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        ltex-plus.vscode-ltex-plus
        james-yu.latex-workshop
        hirse.vscode-ungit
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
      ];
      userSettings = {
        "extensions.autoUpdate" = false;
        "chat.commandCenter.enabled" = false;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "latex-workshop.formatting.latex" = "latexindent";
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
            args = [
              "-synctex=1"
              "-interaction=nonstopmode"
              "-file-line-error"
              "-pdf"
              "-outdir=%OUTDIR%"
              "%DOC%"
            ];
            command = "latexmk";
            env = { };
            name = "latexmk";
          }
          {
            args = [
              "-synctex=1"
              "-interaction=nonstopmode"
              "-file-line-error"
              "-lualatex"
              "-outdir=%OUTDIR%"
              "%DOC%"
            ];
            command = "latexmk";
            env = { };
            name = "lualatexmk";
          }
          {
            args = [
              "-synctex=1"
              "-interaction=nonstopmode"
              "-file-line-error"
              "-xelatex"
              "-shell-escape"
              "-outdir=%OUTDIR%"
              "%DOC%"
            ];
            command = "latexmk";
            env = { };
            name = "xelatexmk";
          }
          {
            args = [
              "-synctex=1"
              "-interaction=nonstopmode"
              "-file-line-error"
              "-shell-escape"
              "%DOC%"
            ];
            command = "xelatex";
            env = { };
            name = "xelatex";
          }
          {
            args = [
              "%DOCFILE%"
            ];
            command = "biber";
            env = { };
            name = "biber";
          }
          {
            args = [
              "%DOCFILE%"
            ];
            command = "makeglossaries";
            env = { };
            name = "makeglossaries";
          }
          {
            args = [
              "%DOC%"
            ];
            command = "latexmk";
            env = { };
            name = "latexmk_rconly";
          }
          {
            args = [
              "-synctex=1"
              "-interaction=nonstopmode"
              "-file-line-error"
              "%DOC%"
            ];
            command = "pdflatex";
            env = { };
            name = "pdflatex";
          }
          {
            args = [
              "%DOCFILE%"
            ];
            command = "bibtex";
            env = { };
            name = "bibtex";
          }
          {
            args = [
              "-e"
              "knitr::opts_knit$set(concordance = TRUE); knitr::knit('%DOCFILE_EXT%')"
            ];
            command = "Rscript";
            env = { };
            name = "rnw2tex";
          }
          {
            args = [
              "-e"
              "using Weave; weave(\"%DOC_EXT%\", doctype=\"tex\")"
            ];
            command = "julia";
            env = { };
            name = "jnw2tex";
          }
          {
            args = [
              "-e"
              "using Weave; weave(\"%DOC_EXT%\", doctype=\"texminted\")"
            ];
            command = "julia";
            env = { };
            name = "jnw2texminted";
          }
          {
            args = [
              "-f"
              "tex"
              "%DOC_EXT%"
            ];
            command = "pweave";
            env = { };
            name = "pnw2tex";
          }
          {
            args = [
              "-f"
              "texminted"
              "%DOC_EXT%"
            ];
            command = "pweave";
            env = { };
            name = "pnw2texminted";
          }
          {
            args = [
              "--synctex"
              "--keep-logs"
              "--print"
              "%DOC%.tex"
            ];
            command = "tectonic";
            env = { };
            name = "tectonic";
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
        "latex-workshop.latex.autoBuild.run" = "never";
        "terminal.integrated.defaultProfile.linux" = "fish";
        "editor.fontFamily" = "Fira Code";
        "editor.fontLigatures" = true;

        "tinymist.exportPdf" = "onSave";
        "tinymist.lint.when" = "onType";
        "tinymist.preview.scrollSync" = "onSelectionChange";
      };
    };
  };
}
