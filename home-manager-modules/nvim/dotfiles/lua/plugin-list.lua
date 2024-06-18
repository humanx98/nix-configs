return {
    "nvim-lua/plenary.nvim",
    "christoomey/vim-tmux-navigator",
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        lazy = false,
        -- version = "v0.*", -- uncomment for stable config (some features might be missed if/when v1 comes out)
        init = function()
            require("kanagawa").setup({}) -- optional, see configuration section.
            -- vim.cmd("colorscheme kanagawa-dragon")
            vim.cmd("colorscheme kanagawa-wave")
        end,
    },
    -- {
    --     "ramojus/mellifluous.nvim",
    --     priority = 1000,
    --     lazy = false,
    --     -- version = "v0.*", -- uncomment for stable config (some features might be missed if/when v1 comes out)
    --     init = function()
    --         require("mellifluous").setup({}) -- optional, see configuration section.
    --         vim.cmd("colorscheme mellifluous")
    --     end,
    -- },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer", -- source for text in buffer
            "hrsh7th/cmp-path", -- source for file system paths
        },
        config = function ()
            require("plugins.nvim-cmp")
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { 
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function ()
            require("plugins.telescope")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            require("plugins.treesitter")
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            require("plugins.which-key")
        end,
        opts = {},
    },
    { 
        "folke/neodev.nvim", 
        config = function()
            require('neodev').setup()
        end,
        opts = {} ,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            { "folke/neodev.nvim", opts = {} },
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "lua_ls",
                }
            })
            require("plugins.lsp")
        end,
    },
}
