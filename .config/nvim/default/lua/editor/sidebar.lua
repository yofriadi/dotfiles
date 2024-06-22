return {
  { "cpea2506/relative-toggle.nvim" },
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

      require("neo-tree").setup {
        default_component_configs = {
          indent = {
            padding = 0,
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
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
        source_selector = {},
        window = {
          width = 40,
          ["<S-CR>"] = "system_open",
          ["<Space>"] = false, -- TODO: disable space until we figure out which-key disabling
          ["[b"] = "prev_source",
          ["]b"] = "next_source",
          O = "system_open",
          Y = "copy_selector",
          h = "parent_or_close",
          l = "child_or_open",
        },
        commands = {
          copy_file_name = function(state)
            local filepath = state.tree:get_node():get_id()
            local file = vim.fn.fnamemodify(filepath, ":.")
            vim.fn.setreg("+", file)
            require("notify").info(("Copied: `%s`").format(file), { title = "Clipboard" })
          end,
          copy_file_path = function(state)
            local filepath = state.tree:get_node():get_id()
            local file = vim.fn.fnamemodify(filepath, ":~")
            vim.fn.setreg("+", file)
            require("notify").info(("Copied: `%s`").format(file), { title = "Clipboard" })
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
        -- below from LazyVim
        deactivate = function() vim.cmd [[Neotree close]] end,
        init = function()
          -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
          -- because `cwd` is not set up properly.
          vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
            desc = "Start Neo-tree with directory",
            once = true,
            callback = function()
              if package.loaded["neo-tree"] then
                return
              else
                local stats = vim.uv.fs_stat(vim.fn.argv(0))
                if stats and stats.type == "directory" then require "neo-tree" end
              end
            end,
          })
        end,
      }
    end,
  },
}
