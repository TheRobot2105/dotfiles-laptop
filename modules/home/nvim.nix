{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        # Language servers & tools available inside nvim
        extraPackages = with pkgs; [
          nixd
          nixfmt
          lua-language-server
          ripgrep
          fd
          wl-clipboard
          # LaTeX (texliveFull is installed system-wide)
          texlab
          ltex-ls-plus
          zathura
        ];

        plugins = with pkgs.vimPlugins; [
          {
            plugin = lualine-nvim;
            type = "lua";
            config = ''
              require("lualine").setup({ options = { theme = "auto" } })
            '';
          }
          nvim-web-devicons
          plenary-nvim
          {
            plugin = telescope-nvim;
            type = "lua";
            config = ''
              local builtin = require("telescope.builtin")
              vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
              vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
              vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
            '';
          }
          {
            plugin = nvim-treesitter.withAllGrammars;
            type = "lua";
            config = ''
              vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                  -- vimtex brings its own syntax highlighting for LaTeX
                  if vim.bo[args.buf].filetype ~= "tex" then pcall(vim.treesitter.start) end
                end,
              })
            '';
          }
          {
            plugin = nvim-lspconfig;
            type = "lua";
            config = ''
              vim.lsp.config("nixd", {
                settings = { nixd = { formatting = { command = { "nixfmt" } } } },
              })
              vim.lsp.config("ltex_plus", {
                settings = { ltex = { language = "de-DE" } },
              })
              vim.lsp.enable({ "nixd", "lua_ls", "texlab", "ltex_plus" })
              vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format" })
            '';
          }
          {
            plugin = vimtex;
            type = "lua";
            config = ''
              vim.g.vimtex_view_method = "zathura"
              vim.g.vimtex_compiler_method = "latexmk"
              vim.g.vimtex_quickfix_mode = 0
            '';
          }
          {
            plugin = blink-cmp;
            type = "lua";
            config = ''
              require("blink.cmp").setup({ keymap = { preset = "default" } })
            '';
          }
          {
            plugin = gitsigns-nvim;
            type = "lua";
            config = ''require("gitsigns").setup()'';
          }
          {
            plugin = which-key-nvim;
            type = "lua";
            config = ''require("which-key").setup()'';
          }
          {
            plugin = nvim-autopairs;
            type = "lua";
            config = ''require("nvim-autopairs").setup()'';
          }
        ];

        initLua = ''
          vim.g.mapleader = " "
          vim.g.maplocalleader = " "

          local o = vim.opt
          o.number = true
          o.relativenumber = true
          o.mouse = "a"
          o.clipboard = "unnamedplus"
          o.expandtab = true
          o.shiftwidth = 2
          o.tabstop = 2
          o.smartindent = true
          o.ignorecase = true
          o.smartcase = true
          o.termguicolors = true
          o.signcolumn = "yes"
          o.cursorline = true
          o.scrolloff = 8
          o.undofile = true
          o.splitright = true
          o.splitbelow = true

          vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
          vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
        '';
      };
    };
}
