---@type LazySpec
return {
  {
    "David-Kunz/gen.nvim",
    opts = {
      model = "mistral", -- The default model to use.
      no_auto_close = false, -- Never closes the window automatically.
      display_mode = "split",
      init = function() pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
      command = function(options)
        local body = { model = options.model, stream = true }
        return "curl --silent --no-buffer -X POST http://"
          .. options.host
          .. ":"
          .. options.port
          .. "/api/chat -d $body"
      end,
    },
  },
}
