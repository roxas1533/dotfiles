return {
    {
        "folke/tokyonight.nvim",
        enabled = not vim.g.vscode,
        lazy = false,
        priority = 1000,
        opts = {
            -- transparent = true,
        },
        config = function()
            require("tokyonight").setup({
                transparent = true,
                stype = "night",
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
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
        "nvim-lualine/lualine.nvim",
        nabled = vim.g.vscode,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = { "InsertEnter", "CursorHold", "FocusLost", "BufRead", "BufNewFile" },
        config = function()
            local format_status = function()
                if vim.g.save_on_format then
                    return { "", color = { fg = "#00FF00" } }
                else
                    return { "", color = { fg = "#FF0000" } }
                end
            end
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = {
                        "encoding",
                        "fileformat",
                        "filetype",
                        {
                            function()
                                local icon_info = format_status()
                                return "フォーマット" .. icon_info[1]
                            end,
                            color = function()
                                local icon_info = format_status()
                                return icon_info.color
                            end,
                        },
                    },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {},
            })
        end,
    },
}
