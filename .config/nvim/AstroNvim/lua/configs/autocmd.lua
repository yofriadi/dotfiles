-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    return require("astrocore").extend_tbl(opts, {
      autocmds = {
        highlighturl = { -- first key is the `augroup` (:h augroup)
          -- list of auto commands to set
          {
            event = { "VimEnter", "FileType", "BufEnter", "WinEnter" }, -- events to trigger
            -- the rest of the autocmd options (:h nvim_create_autocmd)
            desc = "URL Highlighting",
            callback = function() require("astrocore").set_url_match() end,
          },
        },
      },
    })
  end,
}
