{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      ltex-plus.vscode-ltex-plus
      james-yu.latex-workshop
      hirse.vscode-ungit
      github.vscode-github-actions
      hiukky.flate
    ];
    userSettings = {
      "extensions.autoUpdate" = false;
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
          env = {};
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
          env = {};
          name = "lualatexmk";
        }
        {
          args = [
            "-synctex=1"
            "-interaction=nonstopmode"
            "-file-line-error"
            "-xelatex"
            "-outdir=%OUTDIR%"
            "%DOC%"
          ];
          command = "latexmk";
          env = {};
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
          env = {};
          name = "xelatex";
        }
        {
          args = [
            "%DOCFILE%"
          ];
          command = "biber";
          env = {};
          name = "biber";
        }
        {
          args = [
            "%DOCFILE%"
          ];
          command = "makeglossaries";
          env = {};
          name = "makeglossaries";
        }
        {
          args = [
            "%DOC%"
          ];
          command = "latexmk";
          env = {};
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
          env = {};
          name = "pdflatex";
        }
        {
          args = [
            "%DOCFILE%"
          ];
          command = "bibtex";
          env = {};
          name = "bibtex";
        }
        {
          args = [
            "-e"
            "knitr::opts_knit$set(concordance = TRUE); knitr::knit('%DOCFILE_EXT%')"
          ];
          command = "Rscript";
          env = {};
          name = "rnw2tex";
        }
        {
          args = [
            "-e"
            "using Weave; weave(\"%DOC_EXT%\", doctype=\"tex\")"
          ];
          command = "julia";
          env = {};
          name = "jnw2tex";
        }
        {
          args = [
            "-e"
            "using Weave; weave(\"%DOC_EXT%\", doctype=\"texminted\")"
          ];
          command = "julia";
          env = {};
          name = "jnw2texminted";
        }
        {
          args = [
            "-f"
            "tex"
            "%DOC_EXT%"
          ];
          command = "pweave";
          env = {};
          name = "pnw2tex";
        }
        {
          args = [
            "-f"
            "texminted"
            "%DOC_EXT%"
          ];
          command = "pweave";
          env = {};
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
          env = {};
          name = "tectonic";
        }
      ];
      "ltex.language" = "de-DE";
      #"ltex.ltex-ls.path" = "/nix/store/5c69nrr37i9v181j4z0zjzmlr36l9z45-ltex-ls-plus-18.4.0";
      "ltex.ltex-ls.path" = "${pkgs.ltex-ls-plus}";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.serverSettings" = {
        nixd = {
          formatting = {
            command = [
              "alejandra"
            ];
          };
          options = {
            home_manager = {
              expr = "(builtins.getFlake \"/home/felix/.dotfiles/\").homeConfigurations.felix.options";
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
      "workbench.colorTheme" = "Flate Bold";
    };
  };
}
