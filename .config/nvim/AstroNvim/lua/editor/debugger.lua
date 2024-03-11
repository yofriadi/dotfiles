---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap",
    keys = function()
      local dap = require "dap"
      local dap_widgets = require "dap.ui.widgets"
      return {
        { "<Leader>ds", dap.continue, desc = "Debugger start" },
        { "<Leader>dp", dap.pause, desc = "Debugger pause" },
        { "<Leader>db", dap.toggle_breakpoint, desc = "Debugger toggle breakpoint" },
        { "<Leader>dB", dap.clear_breakpoints, desc = "Debugger clear breakpoint" },
        { "<Leader>dr", dap.restart, desc = "Debugger restart" },
        { "<Leader>dc", dap.run_to_cursor, desc = "Debugger run to cursor" },
        { "<Leader>dq", dap.close, desc = "Debugger close" },
        { "<Leader>dQ", dap.terminate, desc = "Debugger terminate" },
        {
          "<Leader>dC",
          function()
            vim.ui.input({ prompt = "Condition: " }, function(condition)
              if condition then dap.set_breakpoint(condition) end
            end)
          end,
          desc = "Debugger conditional breakpoint",
        },
        { "<Leader>di", dap.step_into, desc = "Debugger step into" },
        { "<Leader>do", dap.step_over, desc = "Debugger step over" },
        { "<Leader>dO", dap.step_out, desc = "Debugger step out" },
        { "<Leader>dR", dap.repl.toggle, desc = "Debugger toggle REPL" },
        { "<Leader>dh", dap_widgets.hover, desc = "Debugger hover" },
        { "<Leader>dk", dap_widgets.hover, desc = "Debugger hover" },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
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
        { "<Leader>du", dapui.toggle, desc = "Debugger toggle UI" },
        { "<Leader>dE", dapui.eval, mode = "v", desc = "Debugger evaluate input" },
      }
    end,
  },
  -- DAP adapter
  {
    "jbyuki/one-small-step-for-vimkind",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
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
}
