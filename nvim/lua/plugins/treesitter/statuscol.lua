return {
    "luukvbaal/statuscol.nvim",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
            segments = {
                { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
                {
                    sign = {  maxwidth = 1, namespace = { "diagnostic.signs" } },
                    click = "v:lua.ScSa",
                },
                {
                    sign = {
                        namespace = { 'gitsigns' },
                        maxwidth = 1,
                        colwidth = 1,
                        wrap = true,
                    },
                },
                { text = { builtin.lnumfunc } },
            }
        })
    end,
}
