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

  if kind_filter == false then return end
  if kind_filter[ft] == false then return end
  ---@diagnostic disable-next-line: return-type-mismatch
  return type(kind_filter) == "table" and type(kind_filter.default) == "table" and kind_filter.default or nil
end

return {
  {
    "kevinhwang91/nvim-hlslens",
    event = "BufRead",
    --init = function() vim.on_key(nil, vim.api.nvim_get_namespaces()["auto_hlsearch"]) end,
    config = function() require("hlslens").setup() end,
  },
  {
    "Cassin01/wf.nvim",
    version = "*",
    event = "VeryLazy",
    keys = function()
      local which_key = require "wf.builtin.which_key"
      local register = require "wf.builtin.register"
      local bookmark = require "wf.builtin.bookmark"
      local mark = require "wf.builtin.mark"
      return {
        {
          "<Leader>",
          which_key { text_insert_in_advance = "<Leader>" },
          desc = "[wf.nvim] which-key /",
        },
        { "<C-W>:", register(), desc = "[wf.nvim] register" },
        { "'", mark(), desc = "[wf.nvim] mark" },
        {
          "<C-W>m",
          bookmark {
            nvim = "~/.config/nvim/default",
            zsh = "~/.config/zsh/.zshrc",
          },
          desc = "[wf.nvim] bookmark",
        },
      }
    end,
    config = function() require("wf").setup { theme = "space" } end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable "make" == 1,
      },
      {
        "LukasPietzschmann/telescope-tabs",
        keys = {
          { "<Leader>s<Tab>", "<Cmd>Telescope telescope-tabs list_tabs<CR>", desc = "Search Tabs" },
        },
      },
      {
        "FabianWirth/search.nvim",
        keys = {
          { "<Leader>ss", function() require("search").open() end, desc = "Search files with tabs option" },
        },
        config = function()
          local t = require "telescope"
          local tsb = require "telescope.builtin"
          return require("search").setup {
            tabs = {
              { "Frecency", function() t.extensions.frecency.frecency { workspace = "CWD" } end },
              { "Grep", tsb.live_grep },
              { "Buffers", function() return tsb.buffers { sort_mru = true, sort_lastused = true } end },
              { "Tabs", require("telescope-tabs").list_tabs },
              { "Macros", t.extensions.macros.macros },
              { "Env", t.extensions.env.env },
            },
          }
        end,
      },
      {
        "debugloop/telescope-undo.nvim",
        keys = {
          { "<Leader>su", "<Cmd>Telescope undo<CR>", desc = "Search Undo history" },
        },
      },
      "nvim-telescope/telescope-frecency.nvim",
      "LinArcX/telescope-env.nvim",
    },
    config = function(opts)
      local telescope = require "telescope"
      local utils = require "utils"
      telescope.setup(opts)
      utils.conditional_func(telescope.load_extension, utils.is_available "fzf", "undo", "frecency", "macros", "env")
    end,
    opts = function()
      local actions = require "telescope.actions"

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
              if vim.bo[buf].buftype == "" then return win end
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
    keys = function()
      local tsb = require "telescope.builtin"
      local tse = require("telescope").extensions
      return {
        { "<Leader>s<CR>", function() tsb.resume() end, desc = "Resume previous search" },
        { "<Leader>s/", function() tsb.live_grep() end, desc = "Search words" },
        {
          "<Leader>s?",
          function() tsb.live_grep { hidden = true, no_ignore = true } end,
          desc = "Search all words",
        },
        {
          "<Leader>sF",
          function() tsb.find_files { hidden = true, no_ignore = true } end,
          desc = "Search all file",
        },
        {
          "<Leader>sb",
          function() tsb.buffers { sort_mru = true, sort_lastused = true } end,
          desc = "Search buffers",
        },
        { "<Leader>sn", function() tse.notify.notify() end, desc = "Search notifications" },
        { "<Leader>sk", function() tsb.keymaps() end, desc = "Search keymaps" },
        { "<Leader>sc", function() tsb.commands() end, desc = "Search commands" },
        { "<Leader>sC", function() tsb.command_history() end, desc = "Search command history" },

        -- LSP
        {
          "<Leader>lr",
          function() tsb.lsp_references { jump_type = "never" } end,
          desc = "LSP Search references of current symbol",
        },
        {
          "<Leader>lD",
          function() tsb.lsp_definitions { jump_type = "never", reuse_win = true } end,
          desc = "Definition of current symbol",
        },
        {
          "<Leader>li",
          function() tsb.lsp_implementations { reuse_win = true } end,
          desc = "Implementation of current symbol",
        },
        { "<Leader>sd", function() tsb.diagnostics { bufnr = 0 } end, desc = "Search document diagnostics" },
        { "<Leader>sD", function() tsb.diagnostics() end, desc = "Search workspace diagnostics" },
        --[[
        { "<leader>lq", vim.lsp.buf.workspace_symbol, desc = "Search symbols" },
        {
          "<leader>lQ",
          function()
            vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" },
              function(query)
                if query then
                  if query == "" then query = vim.fn.expand "<cword>" end
                  tsb.lsp_workspace_symbols({ query = query, prompt_title = ("Find word (%s)"):format(query) })
                end
              end
            )
          end,
          desc = "Search symbols",
        } ]]

        -- Git
        { "<Leader>sgb", function() tsb.git_branches { use_file_path = true } end, desc = "Search git branches" },
        { "<Leader>sgc", function() tsb.git_commits { use_file_path = true } end, desc = "Search git commits in file" },
        {
          "<Leader>sgC",
          function() tsb.git_bcommits { use_file_path = true } end,
          desc = "Search git commits in repo",
        },
        { "<Leader>sgs", function() tsb.git_status { use_file_path = true } end, desc = "Search git status" },

        -- TODO: find out if below is any useful, change if needed
        { "<Leader>s'", function() tsb.marks() end, desc = "Search marks" },
        { "<Leader>sR", function() tsb.registers() end, desc = "Search registers" },
        { "<Leader>sh", function() tsb.help_tags() end, desc = "Search helps" },
        -- { "<Leader>fH", function () tsb.highlights() end, desc = "Search highlights", },
        { "<Leader>sm", function() tsb.man_pages() end, desc = "Search manual pages" },
        { "<Leader>so", function() tsb.oldfiles { cwd = vim.loop.cwd() } end, desc = "Search cwd history file" },
        { "<Leader>sO", function() tsb.oldfiles() end, desc = "Search all history file" },
        { "<Leader>sa", function() tsb.autocommands() end, desc = "Search autocommands" },
        { "<Leader>sv", function() tsb.vim_options() end, desc = "Search Vim options" },
        -- TODO: below preview not working
        {
          "<Leader>sT",
          function() tsb.colorscheme { enable_preview = true } end,
          desc = "Search theme with preview",
        },
        --[[ {
          "<Leader>ss",
          function() tsb.lsp_document_symbols { symbols = get_kind_filter() } end,
          desc = "Search document symbol",
        },
        {
          "<Leader>sS",
          function() tsb.lsp_dynamic_workspace_symbols { symbols = get_kind_filter() } end,
          desc = "Search workspace symbol",
        }, ]]
      }
    end,
  },
  -- {
  --   "nvim-pack/nvim-spectre",
  --   build = false,
  --   cmd = "Spectre",
  --   opts = {
  --     open_cmd = "noswapfile vnew",
  --     -- TODO: make it work with sd
  --     --[[ default = {
  --       replace = { cmd = "sd" },
  --     } ]]
  --   },
  --   keys = {
  --     { "<leader>er", function() require("spectre").open() end, desc = "Search and replace" },
  --   },
  -- },
  {
    "cshuaimin/ssr.nvim",
    --module = "ssr",
    --[[ keys = {
      { "<leader>er", require("ssr").open, mode = { "n", "x" }, desc = "Search and replace" },
    }, ]]
    config = function()
      local ssr = require "ssr"
      ssr.setup {
        keymaps = {
          close = "<Esc>",
        },
      }
      vim.keymap.set({ "n", "x" }, "<leader>sr", ssr.open)
    end,
    -- Calling setup is optional.
    --[[ config = function()
      require("ssr").setup {
        border = "rounded",
        min_width = 50,
        min_height = 5,
        max_width = 120,
        max_height = 25,
        adjust_window = true,
        keymaps = {
          close = "q",
          next_match = "n",
          prev_match = "N",
          replace_confirm = "<cr>",
          replace_all = "<leader><cr>",
        },
      }
    end, ]]
  },
}
