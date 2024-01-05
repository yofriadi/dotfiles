return {
  "mfussenegger/nvim-dap",
  lazy = true,
  config = function()
    local signs = {
      Stopped = { icon = "󰁕", hl = "DiagnosticWarn" },
      Breakpoint = { icon = "", hl = "DiagnosticInfo" },
      BreakpointRejected = { icon = "", hl = "DiagnosticError" },
      BreakpointCondition = { icon = "", hl = "DiagnosticInfo" },
      LogPoint = { icon = "", hl = "DiagnosticInfo" },
    }
    for name, dap in pairs(signs) do
      vim.fn.sign_define("Dap" .. name, { text = dap.icon, texthl = dap.hl })
    end
  end,
  keys = function()
    local dap = require "dap"
    return {
      { "<Leader>dc", function() dap.continue() end, desc = "Debugger start" },
      { "<Leader>dp", function() dap.pause() end, desc = "Debugger pause" },
      { "<Leader>db", function() dap.toggle_breakpoint() end, desc = "Debugger toggle breakpoint" },
      { "<Leader>dB", function() dap.clear_breakpoint() end, desc = "Debugger clear breakpoint" },
      --[[ {
        "<Leader>dB",
        function()
          vim.ui.input({ prompt = "Condition: " }, function(condition)
            if condition then dap.set_breakpoint(condition) end
          end)
        end,
        desc = "Debugger conditional breakpoint",
      }, ]]
      { "<Leader>di", function() require("dap").step_into() end, desc = "Debugger step into" },
      { "<Leader>do", function() require("dap").step_over() end, desc = "Debugger step over" },
      { "<Leader>dO", function() require("dap").step_out() end, desc = "Debugger step out" },
      { "<Leader>dq", function() require("dap").close() end, desc = "Debugger close" },
      { "<Leader>dQ", function() require("dap").terminate() end, desc = "Debugger terminate" },
      { "<Leader>dr", function() require("dap").restart_frame() end, desc = "Debugger restart" },
      { "<Leader>dR", function() require("dap").repl.toggle() end, desc = "Debugger toggle REPL" },
      { "<Leader>dC", function() require("dap").run_to_cursor() end, desc = "Debugger continues to cursor" },
    }
  end,
  dependencies = {
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = { "nvim-dap" },
      cmd = { "DapInstall", "DapUninstall" },
      opts = { handlers = {} },
      config = function()
        require("mason-nvim-dap").setup {
          ensure_installed = {
            "delve",
          },
        }
      end,
    },
    {
      "rcarriga/nvim-dap-ui",
      opts = { floating = { border = "rounded" } },
      config = function()
        local dap, dapui = require "dap", require "dapui"
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        dapui.setup()
      end,
      keys = function()
        local dapui = require "dapui"
        return {
          {
            "<Leader>dE",
            function()
              vim.ui.input({ prompt = "Expression: " }, function(expr)
                if expr then dapui.eval(expr, { enter = true }) end
              end)
            end,
            desc = "Debugger evaluate input",
          },
          {
            "<Leader>dE",
            function() dapui.eval() end,
            mode = "v",
            desc = "Debugger evaluate input",
          },
          { "<Leader>dd", function() dapui.toggle() end, desc = "Debugger UI toggle" },
          { "<Leader>dK", function() require("dap.ui.widgets").hover() end, desc = "Debugger hover" },
        }
      end,
    },
    {
      "rcarriga/cmp-dap",
      dependencies = { "nvim-cmp" },
      config = function()
        require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
          sources = {
            { name = "dap" },
          },
        })
      end,
    },

    -- DAP adapter
    {
      "jbyuki/one-small-step-for-vimkind",
      config = function()
        local dap = require "dap"
        dap.adapters.nlua = function(cb, conf)
          cb {
            type = "server",
            host = conf.host or "127.0.0.1",
            port = conf.port or 8086,
          }
        end
        dap.configurations.lua = {
          {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
          },
        }
      end,
    },
    {
      "leoluz/nvim-dap-go",
      config = function()
        local dap = require "dap"
        dap.adapters.delve = {
          type = "server",
          port = "${port}",
          executable = {
            command = "dlv",
            args = { "dap", "-l", "127.0.0.1:${port}" },
          },
        }
        dap.configurations.go = {
          {
            type = "delve",
            name = "Debug",
            request = "launch",
            program = "${file}",
          },
          { -- configuration for debugging test files
            type = "delve",
            name = "Debug test",
            request = "launch",
            mode = "test",
            program = "${file}",
          },
          { -- works with go.mod packages and sub packages
            type = "delve",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}",
          },
        }
      end,
    },
  },
}
