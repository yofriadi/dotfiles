---@type LazySpec
return {
  {
    "rubiin/fortune.nvim",
    version = "*",
    config = function() require("fortune").setup { max_width = 60 } end,
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local logo = [[
                        ▄ ▄               
              ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄       
              █ ▄ █▄█ ▄▄▄ █ █▄█ █ █       
           ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █       
         ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄    
         █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄  
       ▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █  
       █▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █  
           █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█      
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
          tabline = true,
          winbar = true,
        },
        config = {
          header = vim.split(logo, "\n"),
          center = {
            {
              action = "ene | startinsert",
              desc = " New file",
              icon = " ",
              key = "n",
            },
            {
              --action = require("search").open,
              desc = " Search",
              icon = " ",
              key = "s",
            },
            {
              action = "ToggleTerm direction=float",
              desc = " Terminal",
              icon = " ",
              key = "t",
            },
            {
              --action = require("dbee").open,
              desc = " Database",
              icon = " ",
              key = "d",
            },
            {
              action = "Lazy",
              desc = " Lazy",
              icon = "󰒲 ",
              key = "l",
            },
            {
              action = "Mason",
              desc = " Mason",
              icon = " ",
              key = "m",
            },
            {
              action = "q",
              desc = " Quit",
              icon = " ",
              key = "q",
            },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            local startup =
              { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
            local fortune = require("fortune").get_fortune()
            return vim.list_extend(startup, fortune)
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function() require("lazy").show() end,
        })
      end

      return opts
    end,
  },
}
