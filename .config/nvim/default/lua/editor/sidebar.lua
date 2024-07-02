return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
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
    config = function()
      -- TODO: check this diagnostic being left out the rest
      local get_icon = require("astroui").get_icon
      vim.fn.sign_define("DiagnosticSignError", { text = get_icon "DiagnosticError", texthl = "DiagnosticSignError" })

      local sources = {
        { source = "filesystem", display_name = get_icon("FolderClosed", 1, true) .. "File" },
        { source = "buffers", display_name = get_icon("DefaultFile", 1, true) .. "Bufs" },
        { source = "diagnostics", display_name = get_icon("Diagnostic", 1, true) .. "Diagnostic" },
        { source = "document_symbols", display_name = get_icon("Spellcheck", 1, true) .. "Symbol" },
      }

      require("neo-tree").setup {
        auto_clean_after_session_restore = true,
        close_if_last_window = true,
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
        open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
        filesystem = {
          bind_to_cwd = false,
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
        },
        window = {
          width = 40,
          mappings = {
            ["<Space>"] = "none", -- disable space until we figure out which-key disabling
            ["<Esc>"] = "quit",
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
          name = {
            trailing_slash = true,
          },
          git_status = {
            symbols = {
              added = "󰐗", --"A",
              modified = "󰻂", --"M",
              deleted = "󰅙", --"D",
              renamed = "󰰟", --"R",
              untracked = "󰋗", --"?",
              ignored = "󰍶", --"-",
              unstaged = "", --"U",
              staged = "󰗠", --"S",
              conflict = "󰀨", --"!",
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
      }
    end,
  },
  {
    "FabijanZulj/blame.nvim",
    enabled = vim.fn.executable "git" == 1,
    keys = {
      { "<Leader>gB", "<Cmd>BlameToggle<CR>", desc = "Git blame" },
    },
    config = function() require("blame").setup { date_format = "%d/%m/%Y %H:%M" } end,
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
