return {
    {
        "lambdalisue/vim-kensaku-search",
        enabled = not vim.g.vscode,
        event = { "CmdlineEnter" },
        config = function()
            vim.keymap.set({ "c" }, "<CR>", "<Plug>(kensaku-search-replace)<CR>", { noremap = true, silent = true })
        end,
    },
    {
        "lambdalisue/kensaku.vim",
        lazy = true,
    },
    {
        "vim-denops/denops.vim",
        lazy = true,
    }
}
