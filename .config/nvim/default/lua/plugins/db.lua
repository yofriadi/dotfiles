return {
  {
    "kndndrj/nvim-dbee",
    dependencies = { "MunifTanjim/nui.nvim" },
    build = function() require("dbee").install() end,
    config = function() require("dbee").setup() end,
    keys = {
      { "<Leader>D", function() require("dbee").toggle() end, desc = "Database toggle" },
    },
  },
}
