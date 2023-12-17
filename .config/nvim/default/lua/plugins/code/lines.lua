return {
  {
    "numToStr/Comment.nvim",
    event = "BufRead",
    opts = function()
      local commentstring_avail, commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      return commentstring_avail and commentstring and { pre_hook = commentstring.create_pre_hook() } or {}
    end,
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "LspAttach",
    keys = {
      {
        "<Leader>td",
        function() vim.diagnostic.config({ virtual_text = not require("lsp_lines").toggle() }) end,
        desc = "Toggle virtual diagnostic lines",
      },
    },
    config = function()
      local lsp_lines = require("lsp_lines")
      -- Disable the plugin in Lazy.nvim
      vim.api.nvim_create_autocmd("FileType", {
          pattern = "lazy",
          callback = function()
              local previous = not lsp_lines.toggle()
              if not previous then lsp_lines.toggle() end
          end
      })

      lsp_lines.setup()
    end,
  },
}
