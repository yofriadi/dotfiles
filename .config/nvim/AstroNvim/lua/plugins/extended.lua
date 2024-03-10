local astronvim_telescope = require "astronvim.plugins.configs.telescope"
local astrocore_extend_tbl = require("astrocore").extend_tbl

---@type LazySpec
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { -- add a new dependency to telescope that is our new plugin
      "natecraddock/telescope-zf-native.nvim",
    },
    -- the first parameter is the plugin specification
    -- the second is the table of options as set up in Lazy with the `opts` key
    config = function(plugin, opts)
      -- run the core AstroNvim configuration function with the options table
      astronvim_telescope(
        plugin,
        astrocore_extend_tbl(opts, {
          extensions = {
            ["zf-native"] = {
              file = { -- options for sorting file-like items
                enable = true, -- override default telescope file sorter
                highlight_results = true, -- highlight matching text in results
                match_filename = true, -- enable zf filename match priority
                initial_sort = nil, -- optional function to define a sort order when the query is empty
              },
              generic = { -- options for sorting all other items
                enable = true, -- override default telescope generic item sorter
                highlight_results = true, -- highlight matching text in results
                match_filename = false, -- disable zf filename match priority
                initial_sort = nil, -- optional function to define a sort order when the query is empty
              },
            },
          },
        })
      )
      -- require telescope and load extensions as necessary
      require("telescope").load_extension "zf-native"
    end,
  },
}
