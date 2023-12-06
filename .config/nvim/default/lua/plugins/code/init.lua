--[[ local M = {}
M.mason = {
  dap = {
    "delve"
  },
  linter = {
    "luacheck",
    "golangci_lint",
    "staticcheck",
  },
  formatter = {
    "stylua",
    "goimports",
    "gofumpt",
    "golines",
    "gomodifytags",
  },
} ]]

return {
  {
    "nat-418/boole.nvim",
    event = "BufRead",
    config = function ()
      require('boole').setup({
        mappings = {
          increment = '<c-a>', -- TODO: map to a proper key, because CTRL-A is mapped to TMUX
          decrement = '<c-x>'
        },
        -- User defined loops
        additions = {
          {'Foo', 'Bar'},
          {'tic', 'tac', 'toe'}
        },
        allow_caps_additions = {
          {'enable', 'disable'}
          -- enable → disable
          -- Enable → Disable
          -- ENABLE → DISABLE
        }
      })
    end
  },
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      --"MasonUpdate", -- AstroNvim extension here as well
      --"MasonUpdateAll", -- AstroNvim specific
    },
    build = ":MasonUpdate",
    config = function ()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_uninstalled = "✗",
            package_pending = "⟳",
          },
        },
      })
    end
  },
}
