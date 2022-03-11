return function()
    local M = {}
    local gs = require("gitsigns")
    gs.setup {
        signs = {
            add = {
                hl = "GitSignsAdd",
                text = "▎",
                numhl = "GitSignsAddNr",
                linehl = "GitSignsAddLn",
            },
            change = {
                hl = "GitSignsChange",
                text = "▎",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn",
            },
            delete = {
                hl = "GitSignsDelete",
                text = "契",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn",
            },
            topdelete = {
                hl = "GitSignsDelete",
                text = "契",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn",
            },
            changedelete = {
                hl = "GitSignsChange",
                text = "▎",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn",
            },
        },
        numhl = false,
        linehl = false,
        keymaps = {
            -- Default keymap options
            noremap = true,
            buffer = true,
            -- ['n ]g'] = { expr = true, "&diff ? ']g' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
            -- ['n [g'] = { expr = true, "&diff ? '[g' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

            ["n <leader>hs"] = "<cmd>lua require\"gitsigns\".stage_hunk()<CR>",
            ["n <leader>hu"] = "<cmd>lua require\"gitsigns\".undo_stage_hunk()<CR>",
            ["n <leader>hr"] = "<cmd>lua require\"gitsigns\".reset_hunk()<CR>",
            ["n <leader>hp"] = "<cmd>lua require\"gitsigns\".preview_hunk()<CR>",
            ["n <leader>hb"] = "<cmd>lua require\"gitsigns\".blame_line()<CR>",

            -- Text objects
            -- ['o ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
            -- ['x ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>'
        },
        watch_index = {
            interval = 1000,
        },
        sign_priority = 6,
        update_debounce = 200,
        status_formatter = nil, -- Use default
        use_decoration_api = false,
    }

    function M.preview_hunk() gs.preview_hunk() end
    function M.next_hunk() gs.next_hunk() end
    function M.prev_hunk() gs.prev_hunk() end
    function M.stage_hunk() gs.stage_hunk() end
    function M.undo_stage_hunk() gs.undo_stage_hunk() end
    function M.reset_hunk() gs.reset_hunk() end
    function M.reset_buffer() gs.reset_buffer() end
    function M.blame_line() gs.blame_line() end

    vim.cmd("command! GitPreviewHunk lua require(\"fn\").preview_hunk()")
    vim.cmd("command! GitNextHunk lua require(\"fn\").next_hunk()")
    vim.cmd("command! GitPrevHunk lua require(\"fn\").prev_hunk()")
    vim.cmd("command! GitStageHunk lua require(\"fn\").stage_hunk()")
    vim.cmd("command! GitUndoStageHunk lua require(\"fn\").undo_stage_hunk()")
    vim.cmd("command! GitResetHunk lua require(\"fn\").reset_hunk()")
    vim.cmd("command! GitResetBuffer lua require(\"fn\").reset_buffer()")
    vim.cmd("command! GitBlameLine lua require(\"fn\").blame_line()")

    return M
end
