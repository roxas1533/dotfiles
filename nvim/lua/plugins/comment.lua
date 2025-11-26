return {
    "numToStr/Comment.nvim",
    enabled = not vim.g.vscode,
    keys = {
        { "<C-_>", mode = { "n", "v" }, desc = "Comment toggle" },
        { "<C-_>", mode = { "o" }, desc = "Comment operator" },
    },
    opts = {
        sticky = true,
        toggler = {
            line = "<C-_>",
        },
        opleader = {
            line = "<C-_>",
        },
    },
}
