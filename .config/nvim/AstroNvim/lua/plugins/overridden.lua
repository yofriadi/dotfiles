--local astrocore_extend_tbl = require("astrocore").extend_tbl
return {
  --[[ {
    "windwp/nvim-autopairs",
    opts = function(_, opts)
      return astrocore_extend_tbl(opts, {
        mappings = {
          n = {
            ["<Leader>ua"] = false,
            ["<Leader>ta"] = { require("astrocore.toggles").autopairs, desc = "Toggle autopairs" },
          },
        },
      })
    end,
  }, ]]
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = function()
      local cmd = require "neo-tree.command"
      return {
        {
          "<Leader>ef",
          function() cmd.execute { source = "filesystem", toggle = true } end,
          desc = "Toggle file explorer",
        },
        {
          "<Leader>eg",
          function() cmd.execute { source = "git_status", toggle = true } end,
          desc = "Toggle git explorer",
        },
        {
          "<Leader>eb",
          function() cmd.execute { source = "buffers", toggle = true } end,
          desc = "Toggle buffer explorer",
        },
        {
          "<Leader>es",
          function() cmd.execute { source = "document_symbols", toggle = true } end,
          desc = "Toggle document symbol explorer",
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
}
