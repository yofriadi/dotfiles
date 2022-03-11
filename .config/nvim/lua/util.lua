local M = {}

M.set_global_path = function()
    local path = M.change_path()
    vim.api.nvim_command("silent :cd " .. path)
end

M.set_window_path = function()
    local path = M.change_path()
    vim.api.nvim_command("silent :lcd " .. path)
end

local function get_size(tabl)
    local size = 0
    for _ in pairs(tabl) do
        size = size + 1
    end
    return size
end

M.virtualtext_show = function()
    local buffer = vim.fn.bufnr()
    local clients = vim.lsp.get_active_clients()
    local size = get_size(clients)
    for i = 1, size, 1 do
        vim.lsp.diagnostic.display(vim.lsp.diagnostic.get(buffer, i), buffer, i, {virtual_text = true, underline = false})
    end
end

M.virtualtext_hide = function()
    local buffer = vim.fn.bufnr()
    local clients = vim.lsp.get_active_clients()
    local size = get_size(clients)
    for i = 1, size, 1 do
        vim.lsp.diagnostic.display(vim.lsp.diagnostic.get(buffer, i), buffer, i, {virtual_text = false, underline = false})
    end
end

M.augroups = function(defs)
    for group_name, def in pairs(defs) do
        vim.cmd("augroup " .. group_name)
        vim.cmd("autocmd!")
        for _, v in pairs(def) do
            local cmd = table.concat(vim.tbl_flatten {"autocmd", v}, " ")
            vim.cmd(cmd)
        end
        vim.cmd("augroup END")
    end
end

M.keymaps = function(mode, opts, keymaps)
    for _, keymap in ipairs(keymaps) do
        vim.api.nvim_set_keymap(mode, keymap[1], keymap[2], opts)
    end
end

M.opt_global = function(opts)
    for name, value in pairs(opts) do
        vim.o[name] = value
    end
end

M.opt_local = function(opts)
    for k, v in pairs(opts) do
        if v == true or v == false then
            vim.cmd("set " .. k)
        else
            vim.cmd("set " .. k .. "=" .. v)
        end
    end
end

--[[ M.packer_lazy_load = function(plugin, timer)
   if plugin then
      timer = timer or 0
      vim.defer_fn(function()
         require("packer").loader(plugin)
      end, timer)
   end
end ]]--

return M
