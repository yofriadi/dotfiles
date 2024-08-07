-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  {
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
          _filetype = {
            {
              event = "FileType",
              pattern = { "sql", "go" },
              command = "setlocal ts=4 sw=4",
            },
            {
              event = "FileType",
              pattern = { "lua", "json", "javascript", "javascriptreact", "typescript", "typescriptreact" },
              command = "setlocal ts=2 sw=2",
            },
            {
              event = "FileType",
              desc = "Unlist quickfist buffers",
              pattern = "qf",
              callback = function() vim.opt_local.buflisted = false end,
            },
          },
          FocusDisable = {
            {
              event = "WinEnter",
              callback = function(_)
                if vim.tbl_contains({ "nofile", "prompt", "popup" }, vim.bo.buftype) then
                  vim.w.focus_disable = true
                else
                  vim.w.focus_disable = false
                end
              end,
              desc = "Disable focus autoresize for BufType",
            },
            {
              event = "FileType",
              callback = function(_)
                if vim.tbl_contains({ "neo-tree" }, vim.bo.filetype) then
                  vim.b.focus_disable = true
                else
                  vim.b.focus_disable = false
                end
              end,
              desc = "Disable focus autoresize for FileType",
            },
          },
          SaveView = {
            {
              event = { "BufWinLeave", "BufWritePost", "WinLeave" },
              desc = "Save view with mkview for real files",
              callback = function(args)
                if vim.b[args.buf].view_activated then vim.cmd.mkview { mods = { emsg_silent = true } } end
              end,
            },
            {
              event = { "BufWinEnter" },
              desc = "Try to load file view if available and enable view saving for real files",
              callback = function(args)
                if not vim.b[args.buf].view_activated then
                  local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
                  local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
                  local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
                  if
                    buftype == ""
                    and filetype
                    and filetype ~= ""
                    and not vim.tbl_contains(ignore_filetypes, filetype)
                  then
                    vim.b[args.buf].view_activated = true
                    vim.cmd.loadview { mods = { emsg_silent = true } }
                  end
                end
              end,
            },
          },
          CreateParentDir = {
            {
              event = { "BufWritePre" },
              desc = "Automatically create parent directories if they don't exist when saving a file",
              callback = function(args)
                local buf_is_valid_and_listed = vim.api.nvim_buf_is_valid(args.buf) and vim.bo[args.buf].buflisted

                if buf_is_valid_and_listed then
                  vim.fn.mkdir(vim.fn.fnamemodify(vim.loop.fs_realpath(args.match) or args.match, ":p:h"), "p")
                end
              end,
            },
          },
        },
      })
    end,
  },
  {
    "AstroNvim/astrolsp",
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        -- Configure buffer local auto commands to add when attaching a language server
        autocmds = {
          -- first key is the `augroup` to add the auto commands to (:h augroup)
          lsp_document_highlight = {
            -- Optional condition to create/delete auto command group
            -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
            -- condition will be resolved for each client on each execution and if it ever fails for all clients,
            -- the auto commands will be deleted for that buffer
            cond = "textDocument/documentHighlight",
            -- cond = function(client, bufnr) return client.name == "lua_ls" end,
            -- list of auto commands to set
            {
              -- events to trigger
              event = { "CursorHold", "CursorHoldI" },
              -- the rest of the autocmd options (:h nvim_create_autocmd)
              desc = "Document Highlighting",
              callback = function() vim.lsp.buf.document_highlight() end,
            },
            {
              event = { "CursorMoved", "CursorMovedI", "BufLeave" },
              desc = "Document Highlighting Clear",
              callback = function() vim.lsp.buf.clear_references() end,
            },
          },
        },
      })
    end,
  },
}
