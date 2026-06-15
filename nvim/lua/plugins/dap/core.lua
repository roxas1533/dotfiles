return {
    {
        "mfussenegger/nvim-dap",
        enabled = not vim.g.vscode,
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                dependencies = {
                    "nvim-neotest/nvim-nio",
                },
            },
        },
        keys = {
            {
                "<F5>",
                function()
                    require("dap").continue()
                end,
                desc = "DAP continue",
            },
            {
                "<F10>",
                function()
                    require("dap").step_over()
                end,
                desc = "DAP step over",
            },
            {
                "<F11>",
                function()
                    require("dap").step_into()
                end,
                desc = "DAP step into",
            },
            {
                "<F12>",
                function()
                    require("dap").step_out()
                end,
                desc = "DAP step out",
            },
            {
                "<leader>b",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "DAP toggle breakpoint",
            },
            {
                "<leader>B",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "DAP conditional breakpoint",
            },
            {
                "<leader>dr",
                function()
                    require("dap").repl.open()
                end,
                desc = "DAP REPL",
            },
            {
                "<leader>dl",
                function()
                    require("dap").run_last()
                end,
                desc = "DAP run last",
            },
            {
                "<leader>du",
                function()
                    require("dapui").toggle()
                end,
                desc = "DAP UI",
            },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()

            vim.opt.signcolumn = "yes"
            vim.api.nvim_set_hl(0, "DapBreakpointSign", { fg = "#e51400" })
            vim.api.nvim_set_hl(0, "DapBreakpointConditionSign", { fg = "#ffb000" })
            vim.api.nvim_set_hl(0, "DapLogPointSign", { fg = "#61afef" })
            vim.api.nvim_set_hl(0, "DapStoppedSign", { fg = "#98c379", bold = true })
            vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#5a3a1f" })
            vim.api.nvim_set_hl(0, "DapStoppedNumber", { fg = "#98c379", bold = true })
            vim.api.nvim_set_hl(0, "DapBreakpointRejectedSign", { fg = "#7f1d1d" })

            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpointSign" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointConditionSign" })
            vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPointSign" })
            vim.fn.sign_define("DapStopped", {
                text = "▶",
                texthl = "DapStoppedSign",
                linehl = "DapStoppedLine",
                numhl = "DapStoppedNumber",
            })
            vim.fn.sign_define("DapBreakpointRejected", { text = "●", texthl = "DapBreakpointRejectedSign" })

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },
}
