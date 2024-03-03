return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = { style = "storm" },
  },
  { "EdenEast/nightfox.nvim" },
  --[[ {
    "levouh/tint.nvim",
    event = "LazyFile",
    opts = {
      highlight_ignore_patterns = { "WinSeparator", "neo-tree", "Status.*" },
      tint = -45, -- Darken colors, use a positive value to brighten
      saturation = 0.6, -- Saturation to preserve
    },
  }, ]]
  {
    "NvChad/nvim-colorizer.lua",
    event = "LazyFile",
    cmd = {
      "ColorizerToggle",
      "ColorizerAttachToBuffer",
      "ColorizerDetachFromBuffer",
      "ColorizerReloadAllBuffers",
    },
    opts = { user_default_options = { names = false } },
  },
}
