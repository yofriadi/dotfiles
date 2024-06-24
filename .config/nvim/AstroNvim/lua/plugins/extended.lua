local astrocore_extend_tbl = require("astrocore").extend_tbl

---@type LazySpec
return {
  { -- TODO: this cant be moved outside plugins folder
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "natecraddock/telescope-zf-native.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "LinArcX/telescope-env.nvim",
      {
        "LukasPietzschmann/telescope-tabs",
        keys = {
          { "<Leader>s<Tab>", "<Cmd>Telescope telescope-tabs list_tabs<CR>", desc = "Search tabs" },
        },
      },
      {
        "debugloop/telescope-undo.nvim",
        keys = {
          { "<Leader>su", "<Cmd>Telescope undo<CR>", desc = "Search Undo history" },
        },
      },
      {
        "FabianWirth/search.nvim",
        keys = {
          {
            "<Leader>s",
            function() require("search").open() end,
            desc = "Search files with tabs option",
          },
        },
        config = function()
          local extensions = require("telescope").extensions
          local builtin = require "telescope.builtin"
          return require("search").setup {
            tabs = {
              {
                "Frecency",
                function() extensions.frecency.frecency { workspace = "CWD" } end,
              },
              { "Grep", builtin.live_grep },
              --{ "Undo", extensions.undo.undo },
              {
                "Buffer",
                function() return builtin.buffers { sort_mru = true, sort_lastused = true } end,
              },
              { "Tab", require("telescope-tabs").list_tabs },
              --{ "Macros", extensions.macros.macros },
              { "Env", extensions.env.env },
            },
          }
        end,
      },
    },
    keys = function()
      local builtin = require "telescope.builtin"
      local mappings = {
        { "<Leader>s<CR>", builtin.resume, desc = "Search resume previous" },
        { "<Leader>s/", builtin.live_grep, desc = "Search words" },
        {
          "<Leader>s?",
          function() builtin.live_grep { hidden = true, no_ignore = true } end,
          desc = "Search words in project",
        },
        { "<Leader>sf", builtin.find_files, desc = "Search files" },
        {
          "<Leader>sF",
          function() builtin.find_files { hidden = true, no_ignore = true } end,
          desc = "Search all files",
        },
        {
          "<Leader>sb",
          function() builtin.buffers { sort_mru = true, sort_lastused = true } end,
          desc = "Search buffers",
        },
        { "<Leader>sk", builtin.keymaps, desc = "Search keymaps" },
        { "<Leader>sc", builtin.grep_string, desc = "Search word under cursor" },
        { "<Leader>sC", builtin.commands, desc = "Search command" },
        {
          "<Leader>sd",
          function() builtin.diagnostics { bufnr = 0 } end,
          desc = "Search document diagnostics",
        },
        { "<Leader>sD", builtin.diagnostics, desc = "Search workspace diagnostics" },
        { "<Leader>ss", builtin.lsp_document_symbols, desc = "Search buffer symbol" },
        { "<Leader>sS", builtin.lsp_document_symbols, desc = "Search buffer symbol" },
        { "<Leader>sT", function() builtin.colorscheme { enable_preview = true } end, desc = "Search theme" },
        { "<Leader>s'", builtin.marks, desc = "Search marks" },
        { "<Leader>sr", builtin.registers, desc = "Search registers" },
        { "<Leader>sh", builtin.help_tags, desc = "Search help" },
        { "<Leader>sgb", builtin.git_branches, desc = "Search git branches" },
        { "<Leader>sgs", builtin.git_status, desc = "Search git status" },
        { "<Leader>sgc", builtin.git_bcommits, desc = "Search buffer git commit" },
        { "<Leader>sgC", builtin.git_commits, desc = "Search git commit" },
      }

      local extensions = require("telescope").extensions
      local is_available = require("astrocore").is_available
      if is_available "nvim-notify" then
        table.insert(mappings, { "<Leader>sn", extensions.notify.notify, desc = "Search notifications" })
      end

      if is_available "todo-comments.nvim" then
        table.insert(mappings, { "<Leader>st", "<Cmd>TodoTelescope<CR>", desc = "Search TODO comment" })
      end

      return mappings
    end,
    config = function(plugin, opts)
      -- run the core AstroNvim configuration function with the options table
      require "astronvim.plugins.configs.telescope"(
        plugin,
        astrocore_extend_tbl(opts, {
          defaults = {
            layout_config = {
              horizontal = { prompt_position = "bottom" },
            },
          },
          extensions = {
            ["zf-native"] = {
              file = { -- options for sorting file-like items
                enable = true, -- override default telescope file sorter
                highlight_results = true, -- highlight matching text in results
                match_filename = true, -- enable zf filename match priority
                initial_sort = nil, -- optional function to define a sort order when the query is empty
              },
              generic = { -- options for sorting all other items
                enable = true, -- override default telescope generic item sorter
                highlight_results = true, -- highlight matching text in results
                match_filename = false, -- disable zf filename match priority
                initial_sort = nil, -- optional function to define a sort order when the query is empty
              },
            },
          },
        })
      )
      -- require telescope and load extensions as necessary
      require("telescope").load_extension "zf-native"

      local actions, get_icon = require "telescope.actions", require("astroui").get_icon
      return {
        defaults = {
          git_worktrees = require("astrocore").config.git_worktrees,
          prompt_prefix = get_icon("Selected", 1), -- " "
          selection_caret = get_icon("Selected", 1), -- " "
          multi_icon = get_icon("Selected", 1),
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-N>"] = actions.cycle_history_next,
              ["<C-P>"] = actions.cycle_history_prev,
              ["<C-J>"] = actions.move_selection_next,
              ["<C-K>"] = actions.move_selection_previous,
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_with_trouble,
              ["<a-i>"] = find_files_no_ignore,
              ["<a-h>"] = find_files_with_hidden,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
            },
            n = { q = actions.close },
          },
        },
      }
    end,
  },
}
