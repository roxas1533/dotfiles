vim.o.foldcolumn = "1"
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
return {
    {
        "kevinhwang91/nvim-ufo",
        event = { "BufReadPre" },
        config = true,
    },
    {
        "kevinhwang91/promise-async",
        lazy = true,
    },
}
