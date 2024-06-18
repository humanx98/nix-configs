require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "c",
        "cpp",
        "cmake",
        "lua",
        "nix",
        "javascript",
        "html",
        "python",
    },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
})