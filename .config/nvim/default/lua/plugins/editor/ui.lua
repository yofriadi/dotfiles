local M = {}
function M.get_hlgroup(name, fallback)
  if vim.fn.hlexists(name) == 1 then
    local hl
    if vim.api.nvim_get_hl then -- check for new neovim 0.9 API
      hl = vim.api.nvim_get_hl(0, { name = name, link = false })
      if not hl.fg then hl.fg = "NONE" end
      if not hl.bg then hl.bg = "NONE" end
    else
      hl = vim.api.nvim_get_hl_by_name(name, vim.o.termguicolors)
      if not hl.foreground then hl.foreground = "NONE" end
      if not hl.background then hl.background = "NONE" end
      hl.fg, hl.bg = hl.foreground, hl.background
      hl.ctermfg, hl.ctermbg = hl.fg, hl.bg
      hl.sp = hl.special
    end
    return hl
  end
  return fallback or {}
end

return {
  {"cpea2506/relative-toggle.nvim"},
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      require("utils").load_plugin_with_func("dressing.nvim", vim.ui, { "input", "select" })
    end,
    opts = {
      input = { default_prompt = "➤ " },
      select = { backend = { "telescope", "builtin" } },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
    keys = {
      { "<leader>en", function() require("noice").cmd("history") end, desc = "Noice History" },
      -- { "<leader>tN", function() require("noice").cmd("dismiss") end, desc = "Noice dismiss All" }, -- NOTE: look if the same as toggle vim-notify
      {
        "<c-f>",
        function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = {"i", "n", "s"},
      },
      {
        "<c-b>",
        function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = {"i", "n", "s"},
      },
    },
    dependencies = {
      { "MunifTanjim/nui.nvim", lazy = true },
      {
        "rcarriga/nvim-notify",
        init = function() require("utils").load_plugin_with_func("nvim-notify", vim, "notify") end,
        keys = {
          {
            "<leader>tn",
            function() require("notify").dismiss({ silent = true, pending = true }) end,
            desc = "Dismiss all Notifications",
          },
        },
        opts = {
          timeout = 3000,
          max_height = function()
            return math.floor(vim.o.lines * 0.75)
          end,
          max_width = function()
            return math.floor(vim.o.columns * 0.75)
          end,
          on_open = function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
            if not vim.g.ui_notifications_enabled then vim.api.nvim_win_close(win, true) end
            if not package.loaded["nvim-treesitter"] then pcall(require, "nvim-treesitter") end
            vim.wo[win].conceallevel = 3
            local buf = vim.api.nvim_win_get_buf(win)
            if not pcall(vim.treesitter.start, buf, "markdown") then vim.bo[buf].syntax = "markdown" end
            vim.wo[win].spell = false
          end,
        },
        config = function ()
          local notify = require "notify"
          notify.setup()
          vim.notify = notify
        end
      }
    }
  },
  {
    "rebelot/heirline.nvim",
    event = "BufEnter",
    opts = function()
      local utils_buffer = require("utils.buffer")
      local cond = require("config.heirline.condition")
      local comp = require("config.heirline.component")
      return {
        opts = {
          disable_winbar_cb = function(args)
            return not utils_buffer.is_valid(args.buf) or cond.buffer_matches({
              buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
              filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline" },
            }, args.buf)
          end,
        },
        statusline = {
          hl = { fg = "fg", bg = "bg" },
          comp.vi_mode(),
          comp.file_info(),
          comp.git_branch(),
        },
        winbar = {},
        tabline = {},
        statuscolumn = {},
      }
    end,
    config = function (_, opts)
      local C = require("config.heirline.env").fallback_colors
      local heirline = require("heirline")
      local function setup_colors()
        local Normal = M.get_hlgroup("Normal", { fg = C.fg, bg = C.bg })
        local Comment = M.get_hlgroup("Comment", { fg = C.bright_grey, bg = C.bg })
        local Error = M.get_hlgroup("Error", { fg = C.red, bg = C.bg })
        local StatusLine = M.get_hlgroup("StatusLine", { fg = C.fg, bg = C.dark_bg })
        local TabLine = M.get_hlgroup("TabLine", { fg = C.grey, bg = C.none })
        local TabLineFill = M.get_hlgroup("TabLineFill", { fg = C.fg, bg = C.dark_bg })
        local TabLineSel = M.get_hlgroup("TabLineSel", { fg = C.fg, bg = C.none })
        local WinBar = M.get_hlgroup("WinBar", { fg = C.bright_grey, bg = C.bg })
        local WinBarNC = M.get_hlgroup("WinBarNC", { fg = C.grey, bg = C.bg })
        local Conditional = M.get_hlgroup("Conditional", { fg = C.bright_purple, bg = C.dark_bg })
        local String = M.get_hlgroup("String", { fg = C.green, bg = C.dark_bg })
        local TypeDef = M.get_hlgroup("TypeDef", { fg = C.yellow, bg = C.dark_bg })
        local GitSignsAdd = M.get_hlgroup("GitSignsAdd", { fg = C.green, bg = C.dark_bg })
        local GitSignsChange = M.get_hlgroup("GitSignsChange", { fg = C.orange, bg = C.dark_bg })
        local GitSignsDelete = M.get_hlgroup("GitSignsDelete", { fg = C.bright_red, bg = C.dark_bg })
        local DiagnosticError = M.get_hlgroup("DiagnosticError", { fg = C.bright_red, bg = C.dark_bg })
        local DiagnosticWarn = M.get_hlgroup("DiagnosticWarn", { fg = C.orange, bg = C.dark_bg })
        local DiagnosticInfo = M.get_hlgroup("DiagnosticInfo", { fg = C.white, bg = C.dark_bg })
        local DiagnosticHint = M.get_hlgroup("DiagnosticHint", { fg = C.bright_yellow, bg = C.dark_bg })
        local HeirlineInactive = M.get_hlgroup("HeirlineInactive", { bg = nil })
        local HeirlineNormal = M.get_hlgroup("HeirlineNormal", { bg = nil })
        local HeirlineInsert = M.get_hlgroup("HeirlineInsert", { bg = nil })
        local HeirlineVisual = M.get_hlgroup("HeirlineVisual", { bg = nil })
        local HeirlineReplace = M.get_hlgroup("HeirlineReplace", { bg = nil })
        local HeirlineCommand = M.get_hlgroup("HeirlineCommand", { bg = nil })
        local HeirlineTerminal = M.get_hlgroup("HeirlineTerminal", { bg = nil })

        local colors = {
          close_fg = Error.fg,
          fg = StatusLine.fg,
          bg = StatusLine.bg,
          section_fg = StatusLine.fg,
          section_bg = StatusLine.bg,
          git_branch_fg = Conditional.fg,
          mode_fg = StatusLine.bg,
          treesitter_fg = String.fg,
          scrollbar = TypeDef.fg,
          git_added = GitSignsAdd.fg,
          git_changed = GitSignsChange.fg,
          git_removed = GitSignsDelete.fg,
          diag_ERROR = DiagnosticError.fg,
          diag_WARN = DiagnosticWarn.fg,
          diag_INFO = DiagnosticInfo.fg,
          diag_HINT = DiagnosticHint.fg,
          winbar_fg = WinBar.fg,
          winbar_bg = WinBar.bg,
          winbarnc_fg = WinBarNC.fg,
          winbarnc_bg = WinBarNC.bg,
          tabline_bg = TabLineFill.bg,
          tabline_fg = TabLineFill.bg,
          buffer_fg = Comment.fg,
          buffer_path_fg = WinBarNC.fg,
          buffer_close_fg = Comment.fg,
          buffer_bg = TabLineFill.bg,
          buffer_active_fg = Normal.fg,
          buffer_active_path_fg = WinBarNC.fg,
          buffer_active_close_fg = Error.fg,
          buffer_active_bg = Normal.bg,
          buffer_visible_fg = Normal.fg,
          buffer_visible_path_fg = WinBarNC.fg,
          buffer_visible_close_fg = Error.fg,
          buffer_visible_bg = Normal.bg,
          buffer_overflow_fg = Comment.fg,
          buffer_overflow_bg = TabLineFill.bg,
          buffer_picker_fg = Error.fg,
          tab_close_fg = Error.fg,
          tab_close_bg = TabLineFill.bg,
          tab_fg = TabLine.fg,
          tab_bg = TabLine.bg,
          tab_active_fg = TabLineSel.fg,
          tab_active_bg = TabLineSel.bg,
          inactive = HeirlineInactive,
          normal = HeirlineNormal,
          insert = HeirlineInsert,
          visual = HeirlineVisual,
          replace = HeirlineReplace,
          command = HeirlineCommand,
          terminal = HeirlineTerminal,
        }

        for _, section in ipairs {
          "git_branch",
          "file_info",
          "git_diff",
          "diagnostics",
          "lsp",
          "macro_recording",
          "mode",
          "cmd_info",
          "treesitter",
          "nav",
        } do
          if not colors[section .. "_bg"] then colors[section .. "_bg"] = colors["section_bg"] end
          if not colors[section .. "_fg"] then colors[section .. "_fg"] = colors["section_fg"] end
        end
        return colors
      end

      heirline.load_colors(setup_colors())
      heirline.setup(opts)
    end
  }
}
