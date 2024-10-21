return {
    "lambdalisue/vim-kensaku-search",
    enable = not vim.g.vscode,
    dependencies = {
        "lambdalisue/kensaku.vim",
        "vim-denops/denops.vim",
    },
    config = function()
        vim.keymap.set({ "c" }, "<CR>", "<Plug>(kensaku-search-replace)<CR>", { noremap = true, silent = true })
    end,
}
