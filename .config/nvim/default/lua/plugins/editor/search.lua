---@param buf? number
---@return string[]?
local function get_kind_filter(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local ft = vim.bo[buf].filetype

  local kind_filter = {
    default = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      "Package",
      "Property",
      "Struct",
      "Trait",
    },
    markdown = false,
    help = false,
    -- you can specify a different filter for each filetype
    lua = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      -- "Package", -- remove package since luals uses it for control flow structures
      "Property",
      "Struct",
      "Trait",
    },
  }

  if kind_filter == false then
    return
  end
  if kind_filter[ft] == false then
    return
  end
  ---@diagnostic disable-next-line: return-type-mismatch
  return type(kind_filter) == "table" and type(kind_filter.default) == "table" and kind_filter.default or nil
end

return {
  {
    "Cassin01/wf.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("wf").setup({ theme = "space" })

      local which_key = require("wf.builtin.which_key")
      local register = require("wf.builtin.register")
      local bookmark = require("wf.builtin.bookmark")
      local buffer = require("wf.builtin.buffer")
      local mark = require("wf.builtin.mark")

      require("caskey").setup({
        ["<leader>"] = {
          act = which_key({ text_insert_in_advance = "<Leader>" }),
          desc = "[wf.nvim] which-key /",
          mode = "n",
        },
        ["<c-w>:"] = { act = register(), desc = "[wf.nvim] register", mode = "n" },
        ["<c-w>b"] = { act = buffer(), desc = "[wf.nvim] buffer", mode = "n" },
        ["'"] = { act = mark(), desc = "[wf.nvim] mark", mode = "n" },
        ["<c-w>m"] = { act = bookmark({
            nvim = "~/.config/nvim/default",
            zsh = "~/.config/zsh/.zshrc",
          }),
          desc = "[wf.nvim] bookmark",
          mode = "n",
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
      },
    },
    config = function (opts)
      local telescope = require("telescope")
      local utils = require("utils")
      telescope.setup(opts)
      utils.conditional_func(telescope.load_extension, utils.is_available("fzf"))
    end,
    opts = function()
      local actions = require("telescope.actions")

      --[[ local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end
      local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
      end
      local find_files_no_ignore = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        Util.telescope("find_files", { no_ignore = true, default_text = line })()
      end
      local find_files_with_hidden = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        Util.telescope("find_files", { hidden = true, default_text = line })()
      end --]]

      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          git_worktrees = vim.g.git_worktrees,
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "bottom", preview_width = 0.55 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              -- TODO: below not working
              -- ["<c-t>"] = open_with_trouble,
              -- ["<a-t>"] = open_selected_with_trouble,
              -- ["<a-i>"] = find_files_no_ignore,
              -- ["<a-h>"] = find_files_with_hidden,
              ["<c-n>"] = actions.cycle_history_next,
              ["<c-p>"] = actions.cycle_history_prev,
              ["<c-j>"] = actions.move_selection_next,
              ["<c-k>"] = actions.move_selection_previous,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
      }
    end,
    keys = function ()
      local tse = require("telescope").extensions
      local tsb = require("telescope.builtin")
      return {
        { "<leader>s<cr>", function () tsb.resume() end, desc = "Resume previous search" },
        { "<leader>s/", function () tsb.live_grep() end, desc = "Search words", },
        { "<leader>s?", function () tsb.live_grep({ hidden = true, no_ignore = true }) end, desc = "Search all words", },
        { "<leader>sf", function () tsb.find_files() end, desc = "Search files (root dir)", },
        { "<leader>sF", function () tsb.find_files({ hidden = true, no_ignore = true }) end, desc = "Search all file", },
        { "<leader>sb", function () tsb.buffers({ sort_mru = true, sort_lastused = true }) end, desc = "Search buffers", },
        { "<leader>sn", function () tse.notify.notify() end, desc = "Search notifications", },
        { "<leader>sk", function () tsb.keymaps() end, desc = "Search keymaps", },
        { "<leader>sc", function () tsb.commands() end, desc = "Search commands", },
        { "<leader>sC", function () tsb.command_history() end, desc = "Search command history", },

        -- TODO: find out if below is any useful, change if needed
        { "<leader>s'", function () tsb.marks() end, desc = "Search marks", },
        { "<leader>sr", function () tsb.registers() end, desc = "Search registers", },
        { "<leader>sh", function () tsb.help_tags() end, desc = "Search helps", },
        -- { "<leader>fH", function () tsb.highlights() end, desc = "Search highlights", },
        { "<leader>sm", function () tsb.man_pages() end, desc = "Search manual pages", },
        { "<leader>so", function () tsb.oldfiles({ cwd = vim.loop.cwd() }) end, desc = "Search cwd history file", },
        { "<leader>sO", function () tsb.oldfiles() end, desc = "Search all history file", },
        { "<leader>sa", function () tsb.autocommands() end, desc = "Search autocommands", },

        -- TODO: set diagnostics below in lsp
        { "<leader>sd", function () tsb.diagnostics({ bufnr = 0 }) end, desc = "Search document diagnostics", },
        { "<leader>sD", function () tsb.diagnostics() end, desc = "Search workspace diagnotics", },
        { "<leader>sv", function () tsb.vim_options() end, desc = "Search Vim options", },
        -- TODO: below preview not working
        { "<leader>sT", function () tsb.colorscheme({ enable_preview = true }) end, desc = "Search theme with preview", },
        {
          "<leader>ss",
          function () tsb.lsp_document_symbols({ symbols = get_kind_filter() }) end,
          desc = "Search document symbol",
        },
        {
          "<leader>sS",
          function () tsb.lsp_dynamic_workspace_symbols({ symbols = get_kind_filter() }) end,
          desc = "Search workspace symbol",
        },
      }
    end,
  },
}
