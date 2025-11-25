return {
    {
        'isakbm/gitgraph.nvim',
        opts = {
            format = {
                timestamp = '%Y-%d-%m %H:%M:%S',
                fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
            },
            hooks = {
                on_select_commit = function(commit)
                    vim.notify("DiffviewOpen " .. commit.hash .. "^!")
                    vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
                end,
                on_select_range_commit = function(from, to)
                    vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
                    vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
                end,
            },
            symbols = {
                merge_commit = "○",
                commit = "●",
                merge_commit_end = "○",
                commit_end = "●",

                -- Advanced symbols
                GVER = "│",
                GHOR = "─",
                GCLD = "╮",
                GCRD = "╭",
                GCLU = "╯",
                GCRU = "╰",
                GLRU = "┴",
                GLRD = "┬",
                GLUD = "┤",
                GRUD = "├",
                GFORKU = "┼",
                GFORKD = "┼",
                GRUDCD = "├",
                GRUDCU = "┡",
                GLUDCD = "┪",
                GLUDCU = "┩",
                GLRDCL = "┬",
                GLRDCR = "┬",
                GLRUCL = "┴",
                GLRUCR = "┴",
            },
        },
        keys = {
            {
                "<leader>gl",
                function()
                    require('gitgraph').draw({}, { all = true, max_count = 5000 })
                end,
                desc = "GitGraph - Draw",
            },
        },
        config = function(_, opts)
            require('gitgraph').setup(opts)
            vim.cmd [[highlight GitGraphBranchName guifg=#51afef guibg=#1e2132]]
            vim.cmd [[highlight GitGraphBranchTag guifg=#121212 guibg=#51afef]]
            vim.cmd [[highlight GitGraphCommit guifg=#51afef]]
            vim.cmd [[highlight GitGraphMergeCommit guifg=#51afef]]
        end,
    },
}
