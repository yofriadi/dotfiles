return {
  "mfussenegger/nvim-dap",
  event = "LazyFile",
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
          { "<Leader>dE", function() dapui.eval() end, mode = "v", desc = "Debugger evaluate input" },
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
  },
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
}
