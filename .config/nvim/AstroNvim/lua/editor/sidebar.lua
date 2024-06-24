---@type LazySpec
return {
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = function()
      local cmd = require "neo-tree.command"
      return {
        {
          "<Leader>ef",
          function() cmd.execute { source = "filesystem", toggle = true } end,
          desc = "Editor toggle file explorer",
        },
        {
          "<Leader>eg",
          function() cmd.execute { source = "git_status", toggle = true } end,
          desc = "Editor toggle git explorer",
        },
        {
          "<Leader>eb",
          function() cmd.execute { source = "buffers", toggle = true } end,
          desc = "Editor toggle buffer explorer",
        },
        {
          "<Leader>es",
          function() cmd.execute { source = "document_symbols", toggle = true } end,
          desc = "Editor toggle document symbol explorer",
        },
      }
    end,
    opts = function(_, opts)
      opts.sources = { "filesystem", "buffers", "git_status", "document_symbols" }
      opts.source_selector = {}
      opts.window.width = 40
      opts.default_component_configs.indent.padding = 0
      opts.default_component_configs.name = { trailing_slash = true }
      opts.default_component_configs.git_status.symbols = {
        added = "󰐗", --"A",
        modified = "󰻂", --"M",
        deleted = "󰅙", --"D",
        renamed = "󰰟", --"R",
        untracked = "󰋗", --"?",
        ignored = "󰍶", --"-",
        unstaged = "", --"U",
        staged = "󰗠", --"S",
        conflict = "󰀨", --"!",
      }
    end,
  },
  {
    "FabijanZulj/blame.nvim",
    enabled = vim.fn.executable "git" == 1,
    keys = {
      { "<Leader>gB", "<Cmd>ToggleBlame window<CR>", desc = "Git blame" },
    },
    config = function() require("blame").setup { date_format = "%d/%m/%Y %H:%M" } end,
  },
  {
    "lewis6991/satellite.nvim",
    event = "User AstroFile",
    opts = {
      handlers = {
        cursor = {
          symbols = { "-" },
        },
        gitsigns = {
          signs = {
            add = "▕",
            change = "▕",
            delete = "▁",
            topdelete = "▔",
            changedelete = { text = "▕" },
            untracked = { text = "▕" },
          },
        },
      },
      excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "notify", "neo-tree" },
    },
  },
  {
    "gorbit99/codewindow.nvim",
    opts = {},
    keys = function()
      local cw = require "codewindow"
      return {
        { "<Leader>emm", cw.toggle_minimap, desc = "Toggle minimap" },
        { "<Leader>emf", cw.toggle_focus, desc = "Toggle minimap focus" },
      }
    end,
  },
}
