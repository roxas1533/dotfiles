return {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
        "LazyGitFilterCurrentFileHistory",
        "LazyGitFilterHistory",
        "LazyGitFilterHistoryCurrentFile",
    },
    event = { "BufRead", "BufNewFile" },
    keys = {
        { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    }
}
