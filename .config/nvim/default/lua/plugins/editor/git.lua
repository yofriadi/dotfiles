return {
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        add = { text = "▌" },
        change = { text = "▌" },
        delete = { text = "" }, -- ▁
        topdelete = { text = "" }, -- ▔
        changedelete = { text = "▌" },
        untracked = { text = "▌" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

        map("n", "]h", gs.next_hunk, "Git next hunk")
        map("n", "[h", gs.prev_hunk, "Git prev hunk")
        map({ "n", "v" }, "<Leader>gs", ":Gitsigns stage_hunk<CR>", "Git stage hunk")
        map({ "n", "v" }, "<Leader>gr", ":Gitsigns reset_hunk<CR>", "Git reset hunk")
        map("n", "<Leader>gS", gs.stage_buffer, "Git stage buffer")
        map("n", "<Leader>gu", gs.undo_stage_hunk, "Git undo stage hunk")
        map("n", "<Leader>gR", gs.reset_buffer, "Git reset buffer")
        map("n", "<Leader>gp", gs.preview_hunk, "Git preview hunk")
        map("n", "<Leader>gb", function() gs.blame_line { full = true } end, "Git blame line")
        --map("n", "<Leader>gd", gs.diffthis, "Git diff this")
        --map("n", "<Leader>gD", function() gs.diffthis "~" end, "Git diff this ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  {
    "sindrets/diffview.nvim",
    keys = function()
      local function DiffviewToggle()
        local view = require("diffview.lib").get_current_view()
        if view then
          vim.cmd ":DiffviewClose"
        else
          vim.cmd ":DiffviewOpen"
        end
      end
      return {
        { "<Leader>gd", DiffviewToggle, desc = "Git diff" },
      }
    end,
  },
  {
    "FabijanZulj/blame.nvim",
    keys = {
      { "<Leader>gB", "<Cmd>ToggleBlame window<CR>", desc = "Git blame" },
    },
    config = function() require("blame").setup { date_format = "%d/%m/%Y %H:%M" } end,
  },
}
