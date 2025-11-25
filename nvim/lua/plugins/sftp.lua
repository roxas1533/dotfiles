return {
    "coffebar/transfer.nvim",
    enabled = not vim.g.vscode,
    lazy = true,
    cmd = { "TransferInit", "DiffRemote", "TransferUpload", "TransferDownload", "TransferDirDiff", "TransferRepeat" },
    opts = {
        upload_rsync_params = {
            "-rlzi",
            "--delete",
            "--checksum",
            "--exclude", ".git",
            "--exclude", ".idea",
            "--exclude", ".DS_Store",
            "--exclude", ".nvim",
            "--exclude", "__pycache__",
            "--exclude", "*.pyc",
        },
    },
}
