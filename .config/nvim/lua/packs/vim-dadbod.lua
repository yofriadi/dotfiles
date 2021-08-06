return function()
    vim.g.db_ui_show_help = 0
    vim.g.db_ui_win_position = "left"
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_winwidth = 35
    vim.g.db_ui_save_location = os.getenv("HOME") .. "/.cache/vim/db_ui_queries"
    vim.g.db_ui_auto_execute_table_helpers = true
    vim.g.dbs = {
        staging = "mysql://user@127.0.0.1/db_wms_inventory"
    }
end
