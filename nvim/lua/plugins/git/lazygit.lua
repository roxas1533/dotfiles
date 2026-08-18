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
    keys = {
        { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    init = function()
        vim.g.lazygit_floating_window_scaling_factor = 1
    end,
}
