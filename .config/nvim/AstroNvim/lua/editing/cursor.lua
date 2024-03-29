---@type LazySpec
return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = vim.fn.executable "git" == 1,
    keys = function()
      local gs = require "gitsigns"
      return {
        { "]g", gs.next_hunk, "Git next hunk" },
        { "[g", gs.prev_hunk, "Git previous hunk" },
        { "<Leader>gs", gs.stage_hunk, desc = "Git stage hunk" },
        { "<Leader>gS", gs.stage_buffer, desc = "Git stage buffer" },
        { "<Leader>gu", gs.undo_stage_hunk, desc = "Git undo stage hunk" },
        { "<Leader>gr", gs.reset_hunk, desc = "Git reset hunk" },
        { "<Leader>gR", gs.reset_buffer, desc = "Git reset buffer" },
        { "<Leader>gp", gs.preview_hunk, desc = "Git preview hunk" },
        { "<Leader>gb", function() gs.blame_line { full = true } end, desc = "Git blame line" },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    keys = function()
      local todo_comments = require "todo-comments"
      return {
        { "]T", todo_comments.jump_next, desc = "Next TODO comment" },
        { "[T", todo_comments.jump_prev, desc = "Previous TODO comment" },
      }
    end,
  },
  {
    "RRethy/vim-illuminate",
    keys = function()
      local illuminate = require "illuminate"
      return {
        { "]]", desc = "Next reference" },
        { "[[", desc = "Previous reference" },
        { "<Leader>tr", illuminate.toggle_buf, desc = "Toggle reference highlighting" },
      }
    end,
    config = function(plugin, opts)
      require "astronvim.plugins.configs.vim-illuminate"(plugin, opts)
      local function map(key, dir, buffer)
        vim.keymap.set(
          "n",
          key,
          function() require("illuminate")["goto_" .. dir .. "_reference"](false) end,
          { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer }
        )
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
  },
  {
    "rmagatti/goto-preview",
    keys = function()
      local gtp = require "goto-preview"
      return {
        { "gpd", gtp.goto_preview_definition, desc = "LSP definition of current symbol", noremap = true },
        { "gpt", gtp.goto_preview_type_definition, desc = "LSP references of current symbol", noremap = true },
        { "gpi", gtp.goto_preview_implementation, desc = "LSP type definition of current symbol", noremap = true },
        { "gpD", gtp.goto_preview_declaration, desc = "LSP implementations of current symbol", noremap = true },
        { "gP", gtp.close_all_win, desc = "LSP implementations of current symbol", noremap = true },
        { "gpr", gtp.goto_preview_references, desc = "LSP implementations of current symbol", noremap = true },
      }
    end,
    opts = {},
  },
  { -- this conflicting use case with NeoComposer, only useful because it can use defined macro
    "kr40/nvim-macros",
    cmd = { "MacroSave", "MacroYank", "MacroSelect", "MacroDelete" },
    opts = {

      json_file_path = vim.fs.normalize(vim.fn.stdpath "config" .. "/macros.json"),
      default_macro_register = "q",
      json_formatter = "jaq",
    },
  },
  {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    opts = {},
  },
  {
    "vidocqh/auto-indent.nvim",
    opts = {},
  },
  {
    "gbprod/yanky.nvim",
    event = "UIEnter",
    dependencies = { { "kkharji/sqlite.lua", enabled = not jit.os:find "Windows" } },
    opts = function()
      local mapping = require "yanky.telescope.mapping"
      local mappings = mapping.get_defaults()
      mappings.i["<c-p>"] = nil
      return {
        highlight = { timer = 200 },
        ring = { storage = jit.os:find "Windows" and "shada" or "sqlite" },
        picker = {
          telescope = {
            use_default_mappings = false,
            mappings = mappings,
          },
        },
      }
    end,
    keys = {
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    },
  },
  {
    "kawre/neotab.nvim",
    event = "InsertEnter",
    opts = {},
  },
  { "lukas-reineke/virt-column.nvim", opts = {} },
}
