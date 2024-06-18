{ config, pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''require("core")'';

    extraPackages = with pkgs; [
      lua-language-server
      clang-tools

      ripgrep
      xclip
      # wl-clipboard
    ];

    plugins = with pkgs.vimPlugins; [
      vim-tmux-navigator
      {
        plugin = kanagawa-nvim;
        type = "lua";
        config = ''
          require("kanagawa").setup({})
          -- vim.cmd("colorscheme kanagawa-wave")
          vim.cmd("colorscheme kanagawa-dragon")
        '';
      }
      cmp-buffer
      cmp-path
      cmp-nvim-lsp
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''require("plugins.nvim-cmp")'';
      }
      telescope-fzf-native-nvim
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''require("plugins.telescope")'';
      }
      {
        plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-c
          p.tree-sitter-cpp
          p.tree-sitter-cmake
          p.tree-sitter-lua
          p.tree-sitter-nix
          p.tree-sitter-javascript
          p.tree-sitter-html
          p.tree-sitter-python
        ]));
        type = "lua";
        config = ''
          require("nvim-treesitter.configs").setup({
            ensure_installed = {},
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
           })
        '';
      }
      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''require("plugins.which-key")'';
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''require("plugins.lsp")''; 
      }
      {
        plugin = neodev-nvim;
        type = "lua";
        config = ''require('neodev').setup()'';
      }
    ];
  };

  home.file.".config/nvim" = {
    recursive = true;
    source = ./dotfiles;
  };
}