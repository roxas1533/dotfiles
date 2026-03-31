return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        lazy = true,
        enabled = not vim.g.vscode,
        opts = {
            file_types = { "markdown" },
        },
        ft = { "markdown" },
    },
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
}
