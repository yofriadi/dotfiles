return {
  "lewis6991/gitsigns.nvim",
  event = "LazyFile",
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      -- stylua: ignore start
      map("n", "]h", gs.next_hunk, "Next Hunk")
      map("n", "[h", gs.prev_hunk, "Prev Hunk")
      map({ "n", "v" }, "<Leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "v" }, "<Leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<Leader>ghS", gs.stage_buffer, "Stage Buffer")
      map("n", "<Leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<Leader>ghR", gs.reset_buffer, "Reset Buffer")
      map("n", "<Leader>ghp", gs.preview_hunk, "Preview Hunk")
      map("n", "<Leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
      map("n", "<Leader>ghd", gs.diffthis, "Diff This")
      map("n", "<Leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
    end,
  },
}
