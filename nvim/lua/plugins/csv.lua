return {
    "mechatroner/rainbow_csv",
    cmd = { "RainbowDelim", "RainbowDelimQuoted" },
    config = function()
        vim.g.rcsv_colorpairs = {
            { "red",        "red" },
            { "yellow",     "yellow" },
            { "lightgray",  "lightgray" },
            { "lightgreen", "lightgreen" },
            { "lightblue",  "lightblue" },
            { "cyan",       "cyan" },
            { "lightred",   "lightred" },
            { "darkyellow", "darkyellow" },
            { "white",      "white" },
        }
    end,
}
