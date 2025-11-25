return {
    "sindrets/diffview.nvim",
    enabled = not vim.g.vscode,
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
        "DiffviewOpenFile"
    },
    config = function()
        vim.opt.fillchars:append { diff = "╱" }
        vim.api.nvim_create_user_command(
            "DiffviewOpenFile",
            function()
                vim.cmd("DiffviewOpen -- " .. vim.fn.expand("%"))
                vim.cmd("DiffviewToggleFiles")
            end,
            { desc = "Open Diffview" }
        )
        require("diffview").setup {
            enhanced_diff_hl = true,
            hooks = {
                diff_buf_read = function()
                    vim.opt_local.foldlevel = 99
                    vim.opt_local.foldenable = false
                end,
                diff_buf_win_enter = function()
                    vim.opt_local.foldlevel = 99
                    vim.opt_local.foldenable = false
                end
            }
        }
    end
}
