return {
    {
        "folke/tokyonight.nvim",
        enabled = false,
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
        },
        config = function()
            require("tokyonight").setup({
                transparent = true,
                stype = "night",
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                    sidebars = "transparent",
                    floats = "transparent",
                },
                on_colors = function(colors)
                    colors.bg_float = colors.none
                end,
            })
            vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    {
        "scottmckendry/cyberdream.nvim",
        enabled = not vim.g.vscode,
        lazy = false,
        priority = 1000,
        config = function()
            require("cyberdream").setup({
                variant = "dark",
                transparent = true,
            })
            vim.cmd([[colorscheme cyberdream]])
        end,
    }
}
