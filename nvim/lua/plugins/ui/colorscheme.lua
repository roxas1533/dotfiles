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
        "navarasu/onedark.nvim",
        enabled = not vim.g.vscode,
        lazy = false,
        priority = 1000,
        config = function()
            require("onedark").setup({
                style = "cool",
                transparent = true,
            })
            require("onedark").load()

            -- Make borders transparent
            vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none" })
        end,
    },
}
