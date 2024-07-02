---@type LazySpec
return {
  { "cpea2506/relative-toggle.nvim" },
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },
  {
    "AstroNvim/astroui",
    lazy = true,
    ---@type AstroUIOpts
    opts = {
      colorscheme = "cyberdream",
      icons = {
        ActiveLSP = "",
        ActiveTS = "",
        ArrowLeft = "",
        ArrowRight = "",
        Bookmarks = "",
        BufferClose = "󰅖",
        DapBreakpoint = "",
        DapBreakpointCondition = "",
        DapBreakpointRejected = "",
        DapLogPoint = "󰛿",
        DapStopped = "󰁕",
        Debugger = "",
        DefaultFile = "󰈙",
        Diagnostic = "󰒡",
        DiagnosticError = "",
        DiagnosticHint = "󰌵",
        DiagnosticInfo = "󰋼",
        DiagnosticWarn = "",
        Ellipsis = "…",
        Environment = "",
        FileNew = "",
        FileModified = "",
        FileReadOnly = "",
        FoldClosed = "",
        FoldOpened = "",
        FoldSeparator = " ",
        FolderClosed = "",
        FolderEmpty = "",
        FolderOpen = "",
        Git = "󰊢",
        GitAdd = "",
        GitBranch = "",
        GitChange = "",
        GitConflict = "",
        GitDelete = "",
        GitIgnored = "◌",
        GitRenamed = "➜",
        GitSign = "▎",
        GitStaged = "✓",
        GitUnstaged = "✗",
        GitUntracked = "★",
        LSPLoading1 = "",
        LSPLoading2 = "󰀚",
        LSPLoading3 = "",
        MacroRecording = "",
        Package = "󰏖",
        Paste = "󰅌",
        Refresh = "",
        Search = "",
        Selected = "❯",
        Session = "󱂬",
        Sort = "󰒺",
        Spellcheck = "󰓆",
        Tab = "󰓩",
        TabClose = "󰅙",
        Terminal = "",
        Window = "",
        WordFile = "󰈭",
      },
      -- A table of only text "icons" used when icons are disabled
      text_icons = {
        ActiveLSP = "LSP:",
        ArrowLeft = "<",
        ArrowRight = ">",
        BufferClose = "x",
        DapBreakpoint = "B",
        DapBreakpointCondition = "C",
        DapBreakpointRejected = "R",
        DapLogPoint = "L",
        DapStopped = ">",
        DefaultFile = "[F]",
        DiagnosticError = "X",
        DiagnosticHint = "?",
        DiagnosticInfo = "i",
        DiagnosticWarn = "!",
        Ellipsis = "...",
        Environment = "Env:",
        FileModified = "*",
        FileReadOnly = "[lock]",
        FoldClosed = "+",
        FoldOpened = "-",
        FoldSeparator = " ",
        FolderClosed = "[D]",
        FolderEmpty = "[E]",
        FolderOpen = "[O]",
        GitAdd = "[+]",
        GitChange = "[/]",
        GitConflict = "[!]",
        GitDelete = "[-]",
        GitIgnored = "[I]",
        GitRenamed = "[R]",
        GitSign = "|",
        GitStaged = "[S]",
        GitUnstaged = "[U]",
        GitUntracked = "[?]",
        MacroRecording = "Recording:",
        Paste = "[PASTE]",
        Search = "?",
        Selected = "*",
        Spellcheck = "[SPELL]",
        TabClose = "X",
      },
    },
  },
}
