return function()
    vim.g.dashboard_custom_header = {

        '888     Y88b      / 888      e    e',
        '888      Y88b    /  888     d8b  d8b',
        '888       Y88b  /   888    d888bdY88b',
        '888        Y888/    888   / Y88Y Y888b',
        '888         Y8/     888  /   YY   Y888b',
        '888____      Y      888 /          Y888b'

    }
    vim.g.dashboard_preview_file_height = 12
    vim.g.dashboard_preview_file_width = 80
    vim.g.dashboard_default_executive = 'telescope'
    vim.g.dashboard_custom_section = {
        last_session = {
            description = {'  Recently laset session                  SPC s l'},
            command =  'SessionLoad',
        },
        find_history = {
            description = {'  Recently opened files                   SPC f h'},
            command =  'DashboardFindHistory',
        },
        find_word = {
             description = {'  Find  word                              SPC f w'},
             command = 'DashboardFindWord',
        },
        a = {
            description = {'  Projects           '},
            command = 'Telescope project'
        },
        b = {
            description = {'  File Browser       '},
            command = 'Telescope file_browser'
        },
        c = {
            description = {'  Find File          '},
            command = 'Telescope find_files find_command=rg,--hidden,--files'
        },
        d = {
            description = {'  Recently Used Files'},
            command = 'Telescope oldfiles'
        },
        e = {
            description = {'  Find Word          '},
            command = 'Telescope live_grep'
        },
        h = {
            description = {'  Readme             '},
            command = ':e ~/.config/nvim/README.md'
        }
    }
end
