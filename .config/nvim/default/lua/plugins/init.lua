-- Properly load file based plugins without blocking the UI
(function()
  local use_lazy_file = true
  local lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }
  use_lazy_file = use_lazy_file and vim.fn.argc(-1) > 0

  -- Add support for the LazyFile event
  local Event = require "lazy.core.handler.event"

  if use_lazy_file then
    -- We'll handle delayed execution of events ourselves
    Event.mappings.LazyFile = { id = "LazyFile", event = "User", pattern = "LazyFile" }
    Event.mappings["User LazyFile"] = Event.mappings.LazyFile
  else
    -- Don't delay execution of LazyFile events, but let lazy know about the mapping
    Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
    Event.mappings["User LazyFile"] = Event.mappings.LazyFile
    return
  end

  local events = {} ---@type {event: string, buf: number, data?: any}[]

  local done = false
  local function load()
    if #events == 0 or done then return end
    done = true
    vim.api.nvim_del_augroup_by_name "lazy_file"

    ---@type table<string,string[]>
    local skips = {}
    for _, event in ipairs(events) do
      skips[event.event] = skips[event.event] or Event.get_augroups(event.event)
    end

    vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
    for _, event in ipairs(events) do
      if vim.api.nvim_buf_is_valid(event.buf) then
        Event.trigger {
          event = event.event,
          exclude = skips[event.event],
          data = event.data,
          buf = event.buf,
        }
        if vim.bo[event.buf].filetype then
          Event.trigger {
            event = "FileType",
            buf = event.buf,
          }
        end
      end
    end
    vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
    events = {}
  end

  -- schedule wrap so that nested autocmds are executed
  -- and the UI can continue rendering without blocking
  load = vim.schedule_wrap(load)

  vim.api.nvim_create_autocmd(lazy_file_events, {
    group = vim.api.nvim_create_augroup("lazy_file", { clear = true }),
    callback = function(event)
      table.insert(events, event)
      load()
    end,
  })
end)()

-- NOTE: here lies all plugin that does not yet categorized
return {
  --[[ {
    "00sapo/visual.nvim",
    event = "VeryLazy",
    opts = { treesitter_textobjects = true },
    dependencies = { "nvim-treesitter", "nvim-treesitter-textobjects" },
    keys = {
      { "<Leader>tv", "<Cmd>VisualEnable<CR>", desc = "Enable Kakoune mode" },
    },
  }, ]]
  {
    "LunarVim/bigfile.nvim",
    opts = {},
  },
  {
    "tris203/hawtkeys.nvim",
    config = true,
  },
  {
    "TobinPalmer/Tip.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim", lazy = true },
    init = function()
      require("tip").setup {
        seconds = 2,
        title = "Tip!",
        url = "https://vtip.43z.one",
      }
    end,
  },
  {
    "Nexmean/caskey.nvim",
    config = function() require("caskey").setup(require "config.keymaps") end,
  },
  { "gbprod/cutlass.nvim", event = "LazyFile" },
  {
    "onsails/lspkind.nvim",
    -- TODO: add proper lazy event
    lazy = true,
    opts = {
      mode = "symbol",
      symbol_map = {
        Array = "󰅪",
        Boolean = "⊨",
        Key = "󰌆",
        Namespace = "󰅪",
        Null = "NULL",
        Number = "#",
        Object = "󰀚",
        Package = "󰏗",
        String = "󰀬",
        TypeParameter = "󰊄",
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
      },
      menu = {},
    },
    enabled = vim.g.icons_enabled,
    config = function(_, opts) require("lspkind").init(opts) end,
  },
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  --[[ {
    "epwalsh/pomo.nvim",
    version = "*",
    lazy = true,
    cmd = { "TimerStart", "TimerRepeat" },
    dependencies = { "rcarriga/nvim-notify" },
  }, ]]
}
