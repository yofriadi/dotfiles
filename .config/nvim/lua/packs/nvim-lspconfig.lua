return function()
    local api = vim.api

    local format = {}
    local function nvim_create_augroup(group_name, definitions)
        vim.api.nvim_command("augroup " .. group_name)
        vim.api.nvim_command("autocmd!")
        for _, def in ipairs(definitions) do
            local command = table.concat(vim.tbl_flatten {"autocmd", def}, " ")
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command("augroup END")
    end

    function format.lsp_before_save()
        local defs = {}
        local ext = vim.fn.expand("%:e")
        table.insert(defs, {"BufWritePre", "*." .. ext, "lua vim.lsp.buf.formatting_sync(nil,1000)"})
        --[[ if ext == "go" then
            table.insert(defs,
                         {"BufWritePre", "*.go", "lua require('packs.nvim-lspconfig').go_organize_imports_sync(1000)"})
        end ]]
        nvim_create_augroup("lsp_before_save", defs)
    end

    -- Synchronously organise (Go) imports. Taken from
    -- https://github.com/neovim/nvim-lsp/issues/115#issuecomment-654427197.
    function format.go_organize_imports_sync(timeout_ms)
        local context = {source = {organizeImports = true}}
        vim.validate {context = {context, "t", true}}
        local params = vim.lsp.util.make_range_params()
        params.context = context

        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
        if not result then return end
        result = result[1].result
        if not result then return end
        local edit = result[1].edit
        vim.lsp.util.apply_workspace_edit(edit)
    end

    if not packer_plugins["lspsaga.nvim"].loaded then vim.cmd [[packadd lspsaga.nvim]] end

    local saga = require "lspsaga"
    saga.init_lsp_saga({code_action_icon = "💡"})

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    function _G.reload_lsp()
        vim.lsp.stop_client(vim.lsp.get_active_clients())
        vim.cmd [[edit]]
    end

    function _G.open_lsp_log()
        local path = vim.lsp.get_log_path()
        vim.cmd("edit " .. path)
    end

    vim.cmd("command! -nargs=0 LspLog call v:lua.open_lsp_log()")
    vim.cmd("command! -nargs=0 LspRestart call v:lua.reload_lsp()")

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Enable underline, use default values
        underline = true,
        -- Enable virtual text, override spacing to 4
        virtual_text = true,
        signs = {enable = true, priority = 20},
        -- Disable a feature
        update_in_insert = false,
    })

    local on_attach = function(client, bufnr)
        if client.resolved_capabilities.document_formatting then format.lsp_before_save() end
        api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    end

    local lspconfig = require "lspconfig"

    lspconfig.gopls.setup {
        cmd = {"gopls", "--remote=auto"},
        on_attach = on_attach,
        capabilities = capabilities,
        init_options = {usePlaceholders = true, completeUnimported = true},
    }

    lspconfig.sumneko_lua.setup {
        cmd = {os.getenv("HOME") .. "/lua-language-server/bin/Linux/lua-language-server", "-E", os.getenv("HOME") .. "/lua-language-server/main.lua"},
        settings = {
            Lua = {
                diagnostics = {enable = true, globals = {"vim", "packer_plugins"}},
                runtime = {version = "LuaJIT"},
                workspace = {library = vim.list_extend({[vim.fn.expand("$VIMRUNTIME/lua")] = true}, {})},
            },
        },
    }

    lspconfig.tsserver.setup {
        on_attach = function(client)
            client.resolved_capabilities.document_formatting = false
            on_attach(client)
        end,
    }

    local servers = {"dockerls"}

    for _, server in ipairs(servers) do lspconfig[server].setup {on_attach = on_attach} end
end
