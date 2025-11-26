return {
    "shellRaining/hlchunk.nvim",
    event = { "UIEnter" },
    config = function()
        require("hlchunk").setup({
            chunk = {
                enable = true,
                priority = 1000,
                style = {
                    { fg = "#ffffff" },
                    { fg = "#c21f30" },
                },
                use_treesitter = true,
                -- chars = {
                --     horizontal_line = "━",
                --     vertical_line = "┃",
                --     left_top = "┏",
                --     left_bottom = "┗",
                --     right_arrow = ">",
                -- },
            },
        })
    end,
}
