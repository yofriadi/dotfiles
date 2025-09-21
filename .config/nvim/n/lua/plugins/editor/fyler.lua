return {
  "A7Lavinraj/fyler.nvim",
  branch = "stable",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-tree/nvim-web-devicons",
      optional = true,
    },
  },
  config = function()
    local ok, fyler = pcall(require, "fyler")
    if ok and type(fyler.setup) == "function" then
      fyler.setup()
    end
  end,
}
