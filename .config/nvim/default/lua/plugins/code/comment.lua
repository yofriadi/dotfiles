-- TODO: to read plugin page
return {
  "numToStr/Comment.nvim",
  event = "BufRead",
  opts = function()
    local commentstring_avail, commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
    return commentstring_avail and commentstring and { pre_hook = commentstring.create_pre_hook() } or {}
  end,
}
