local notif = require "utils.notif"

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
      { "MunifTanjim/nui.nvim", lazy = true },
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    opts = {
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      enable_normal_mode_for_inputs = true,
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        width = 30,
        mappings = {
          ["<Space>"] = false, -- disable space until we figure out which-key disabling
          ["<Esc>"] = "quit",
          --J = "navigate_down",  not exist
          K = "navigate_up",
          p = "prev_source",
          n = "next_source",
          y = "copy_file_name",
          Y = "copy_file_path",
          h = "parent_or_close",
          l = "child_or_open",
        },
      },
      default_component_configs = {
        indent = {
          padding = 0,
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
        },
        icon = {
          folder_closed = "󰉋",
          folder_open = "󰝰",
          folder_empty = "",
        },
        name = {
          trailing_slash = true,
        },
        git_status = {
          symbols = {
            added = "A", -- 󰐗
            modified = "M", -- 󰻂
            deleted = "D", -- 󰅙
            renamed = "R", -- 󰰟
            untracked = "?", -- 󰋗
            ignored = "-", -- 󰍶
            unstaged = "U", -- 
            staged = "S", -- 󰗠
            conflict = "!", -- 󰀨
          },
        },
      },
      commands = {
        copy_file_name = function(state)
          local filepath = state.tree:get_node():get_id()
          local file = vim.fn.fnamemodify(filepath, ":.")
          vim.fn.setreg("+", file)
          notif.info(("Copied: `%s`").format(file), { title = "Clipboard" })
        end,
        copy_file_path = function(state)
          local filepath = state.tree:get_node():get_id()
          local file = vim.fn.fnamemodify(filepath, ":~")
          vim.fn.setreg("+", file)
          notif.info(("Copied: `%s`").format(file), { title = "Clipboard" })
        end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if (node.type == "directory" or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" or node:has_children() then
            if not node:is_expanded() then -- if unexpanded, expand
              state.commands.toggle_node(state)
            else -- if expanded and has children, seleect the next child
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          else -- if not a directory just open it
            state.commands.open(state)
          end
        end,
      },
    },
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
    deactivate = function() vim.cmd [[Neotree close]] end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then require "neo-tree" end
      end
    end,
  },
  {
    "lewis6991/satellite.nvim",
    event = "LazyFile",
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
  --[[ {
    "wfxr/minimap.vim",
    event = "LazyFile",
    cmd = { "Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight" },
    keys = {
      { "<leader>tm", "<cmd>MinimapToggle<CR>", desc = "Toggle minimap" },
    },
    init = function()
      vim.g.minimap_width = 10
      vim.g.minimap_auto_start = 1
      vim.g.minimap_auto_start_win_enter = 1
      vim.g.minimap_highlight_search = 1
      vim.g.minimap_git_colors = 1
      vim.g.minimap_block_filetypes = {
        "fugitive",
        "nerdtree",
        "tagbar",
        "fzf",
        "qf",
        "netrw",
        "NvimTree",
        "lazy",
        "mason",
        "prompt",
        "TelescopePrompt",
        "noice",
        "notify",
        "neo-tree",
      }
    end,
  }, ]]
}
