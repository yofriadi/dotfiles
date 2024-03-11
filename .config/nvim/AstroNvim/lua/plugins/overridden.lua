--local astrocore_extend_tbl = require("astrocore").extend_tbl

---@type LazySpec
return {
  --[[ {
    "windwp/nvim-autopairs",
    opts = function(_, opts)
      return astrocore_extend_tbl(opts, {
        mappings = {
          n = {
            ["<Leader>ua"] = false,
            ["<Leader>ta"] = { require("astrocore.toggles").autopairs, desc = "Toggle autopairs" },
          },
        },
      })
    end,
  }, ]]
}
