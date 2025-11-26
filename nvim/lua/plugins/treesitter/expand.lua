return {
    "sustech-data/wildfire.nvim",
    event = { "BufRead", "BufNewFile" },
    config = function()
        require("wildfire").setup({
            keymaps = {},
        })
    end,
}
