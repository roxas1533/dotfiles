return {
    "mfussenegger/nvim-dap-python",
    enabled = not vim.g.vscode,
    dependencies = {
        "mfussenegger/nvim-dap",
    },
    ft = "python",
    config = function()
        local dap_python = require("dap-python")

        local function path_join(...)
            return table.concat({ ... }, "/")
        end

        local function file_exists(path)
            return vim.uv.fs_stat(path) ~= nil
        end

        local function project_python()
            if vim.env.VIRTUAL_ENV then
                local unix_python = path_join(vim.env.VIRTUAL_ENV, "bin", "python")
                if file_exists(unix_python) then
                    return unix_python
                end

                local windows_python = path_join(vim.env.VIRTUAL_ENV, "Scripts", "python.exe")
                if file_exists(windows_python) then
                    return windows_python
                end
            end

            local dir = vim.fn.getcwd()
            while dir and dir ~= "" do
                for _, venv in ipairs({ ".venv", "venv", "env" }) do
                    local unix_python = path_join(dir, venv, "bin", "python")
                    if file_exists(unix_python) then
                        return unix_python
                    end

                    local windows_python = path_join(dir, venv, "Scripts", "python.exe")
                    if file_exists(windows_python) then
                        return windows_python
                    end
                end

                local parent = vim.fn.fnamemodify(dir, ":h")
                if parent == dir then
                    break
                end
                dir = parent
            end

            return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python"
        end

        dap_python.setup(project_python(), {
            include_configs = false,
        })
    end,
}
