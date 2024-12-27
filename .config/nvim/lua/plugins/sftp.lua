return {
    "coffebar/transfer.nvim",
    enabled = not vim.g.vscode,
    lazy = true,
    cmd = { "TransferInit", "DiffRemote", "TransferUpload", "TransferDownload", "TransferDirDiff", "TransferRepeat" },
    opts = {},
}
