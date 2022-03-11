local util = require("util")

return function()
    util.keymaps("n", {
        noremap = true,
        silent = true,
    }, {
        {"j", "gj"}, -- move top by visual line
        {"k", "gk"}, -- move bottom by visual line
        {"d", "\"_d"}, -- use a different register for delete and paste
        {"x", "\"_x"}, -- use a different register for delete and paste
        {"<M-j>", ":m .+1<CR>=="}, -- move a line to bottom
        {"<M-k>", ":m .-2<CR>=="}, -- move a line to top
        {"<Esc>", "<Esc>:noh<CR>"}, -- Remove highlight after search
        -- {'<Tab>', ':BufferNext<CR>'}, -- Barbar - Tab navigation next
        -- {'<S-Tab>', ':BufferPrevious<CR>'}, -- Barbar - Tab navigation prev
        -- {'<F5>', ':UndotreeToggle<CR>'}, -- UndoTree toggle
        -- {'<C-n>', ':e %:h/filename<CR>'}, -- Create new file in current directory
        {"<C-s>", ":w<CR>"}, -- Save
        -- {'<C-a>', ':wa<CR>'}, -- Save all
        -- {'<C-e>', ':qa!<CR>'}, -- Close all, exit nvim
        -- {'<C-x>', ':BufferClose<CR>'}, -- Buffer close
        -- {'<C-q>', ':BufferClose!<CR>'}, -- Buffer Close whitout saving
        -- {'<C-d>', ':bdelete<CR>'}, -- BDelete
        {"<C-h>", "<C-w>h"}, -- Move to window left
        {"<C-l>", "<C-w>l"}, -- Move to window right
        {"<C-j>", "<C-w>j"}, -- Move to window down
        {"<C-k>", "<C-w>k"}, -- Move to window up
        {"<C-Left>", ":vertical resize -2<CR>"}, -- Resize width -
        {"<C-Right>", ":vertical resize +2<CR>"}, -- Resize width +
        {"<C-Up>", ":resize -2<CR>"}, -- Resize height -
        {"<C-Down>", ":resize +2<CR>"}, -- Resize height +
        {"<S-r>", "<C-W>v"}, -- Split right
        {"<S-b>", "<C-W>s"}, -- Split bottom
        {"<leader><leader>", "<c-^>"}, -- switch between current and last file
        -- {'<S-e>', ':NvimTreeToggle<CR>'}, -- NvimTree explorer toggle
        -- {'<S-h>', ':RnvimrToggle<CR>'}, -- Ranger explorer toggle
        -- {'<S-u>', ':Vifm<CR>'}, -- Vifm explorer
        -- {'<S-f>', ':Telescope find_files<CR>'}, -- File search
        -- {'<S-w>', ':Telescope live_grep<CR>'}, -- Text search
        -- {'<S-p>', ':Telescope project<CR>'}, -- Projects
        -- {'<S-l>', ':FloatermNew lazygit<CR>'}, -- Lazygit
        -- {'<S-m>', ':MarkdownPreviewToggle<CR>'}, -- Markdown preview toggle
        -- {'<A-j>', ':AnyJump<CR>'}, -- Any jump
        {"<M-v>", ":SymbolsOutline<CR>"}, -- Symbols outline
        -- {"<M-[>", ":foldopen<CR>"}, -- Fold open
        -- {"<M-]>", ":foldclose<CR>"}, -- Fold close
        {"<M-.>", ":BookmarkToggle<CR>"}, -- Bookmark toggle
        -- {"<M-,>", ":Neoformat<CR>"}, -- Format code
        -- {"<M-/>", ":CommentToggle<CR>"}, -- Comment toggle
        -- {"<M-f>", ":LspFormatting<CR>"}, -- Lsp format code
        {"<M-g>", ":LspReferences<CR>"}, -- Lsp references
        {"<M-d>", ":LspDeclaration<CR>"}, -- Lsp declaration
        -- {"<M-p>", ":LspDefinition<CR>"}, -- Lsp definition
        -- {"<M-r>", ":LspRename<CR>"}, -- Lsp rename
        -- {"<M-n>", ":LspGoToNext<CR>"}, -- Lsp go to next
        -- {"<M-p>", ":LspGoToPrev<CR>"}, -- Lsp go to prev
        -- {'<M-h>', ':LspHover<CR>'}, -- Lsp hover
        {"K", ":Lspsaga hover_doc<CR>"},
        {"gh", ":Lspsaga lsp_finder<CR>"},
        {"gs", ":Lspsaga signature_help<CR>"},
        {"gr", ":Lspsaga rename<CR>"},
        {"gd", ":Lspsaga preview_definition<CR>"},
        {"ca", ":Lspsaga code_action<CR>"},
        {"<C-d>", ":lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>"},
        {"<C-u", ":lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>"},
        {"<M-e>", ":LspTroubleToggle<CR>"}, -- Lsp trouble toggle
        {"<leader>cd", ":Lspsaga show_line_diagnostics<CR>"},
        {"[e", ":Lspsaga diagnostic_jump_prev<CR>"},
        {"]e", ":Lspsaga diagnostic_jump_next<CR>"},
        {"<leader>cc", ":Lspsaga show_cursor_diagnostics<CR>"}, -- USED BY PLUGIN
        --[[{"<leader>ff", ":Telescope find_files<CR>"}, -- File search
        {"<leader>fg", ":Telescope live_grep<CR>"}, -- Text search
        {"<leader>fb", ":Telescope buffers show_all_buffers=true<CR>"}, -- Buffer search
        {"<leader>fp", ":Telescope project<CR>"}, -- Projects search
        {"<leader>fc", ":Telescope commands<CR>"}, -- Command search ]] --
        {"<C-n>", ":NvimTreeToggle<CR>"}, -- toggle NvimTree
        {"$", ":HopWord<CR>"}, -- trigger HopWord
        {"q", ":BufDel<CR>"},
        {"<C-q>", ":q!<CR>"},
        {"<leader>x", ":<Plug>RestNvim<CR>"}, -- trigger RestNvim
        {"<leader>xp", ":<Plug>RestNvimPreview<CR>"}, -- trigger RestNvimPreview
        {"<leader>xl", ":<Plug>RestNvimLast<CR>"}, -- trigger RestNvimLast
    })

    util.keymaps("x", {
        noremap = true,
        silent = true,
    }, {
        {"<", "<gv"}, -- Tab left
        {">", ">gv"}, -- Tab right
        -- { '*', ':<C-u>lua require("core.funcs.search").visual_selection("/")<CR>/<C-r>=@/<CR><CR>' }, -- Visual search /
        -- { '#', ':<C-u>lua require("core.funcs.search").visual_selection("?")<CR>?<C-r>=@/<CR><CR>' }, -- Visual search ?
        {"K", ":move '<-2<CR>gv-gv"}, -- Move up
        {"J", ":move '>+1<CR>gv-gv"}, -- Move down
        {"<M-j>", ":AnyJumpVisual<CR>"}, -- Any jump visual
        {"<M-/>", ":CommentToggle<CR>"}, -- Comment toggle
    })

    util.keymaps("v", {
        noremap = true,
    }, {
        {"d", "\"_d"}, -- use a different register for delete and paste
        {"p", "\"_dP"}, -- use a different register for delete and paste
        {"<M-j>", ":m '>+1<CR>gv=gv"}, -- move a line to bottom
        {"<M-k>", ":m '<-2<CR>gv=gv"}, -- move a line to top
        {"ca", ":<C-u>Lspsaga range_code_action<CR>"},
    })

    util.keymaps("i", {
        noremap = true,
        silent = true,
    }, {
        {"jk", "<Esc>"}, -- use jk to escape
        {"<C-s>", "<Esc>:w<CR>"}, -- Save
        {"<M-j>", "<Esc>:m .+1<CR>==gi"}, -- move a line to bottom
        {"<M-k>", "<Esc>:m .-2<CR>==gi"}, -- move a line to top
    })

    util.keymaps("t", {
        noremap = true,
    }, {{"jk", "<C-\\><C-n>"}})
end
