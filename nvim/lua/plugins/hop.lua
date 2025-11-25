return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        modes = {
            char = {
                jump_labels = true,
            }
        }
    },
    keys = {
        { "<leader>w", function() require("flash").jump() end,       mode = "n", desc = "Hop Word" },
        { "<leader>l", function() require("flash").treesitter() end, mode = "n", desc = "Hop Line" },
    },
}
