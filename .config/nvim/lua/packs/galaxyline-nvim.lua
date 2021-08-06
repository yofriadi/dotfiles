return function()
    local gl = require("galaxyline")
    gl.short_line_list = {"NvimTree", "vista", "dbui", "packer"}
    local colors = {
        bg = "#4C566A",
        fg = "#E7BC74",
        line_bg = "#4C566A",
        lbg = "#4C566A",
        fg_green = "#458588",
        yellow = "#E6B673",
        cyan = "#39A291",
        darkblue = "#458588",
        green = "#689d6a",
        orange = "#F2994B",
        purple = "#008080",
        magenta = "#ea6962",
        gray = "#E7BC74",
        blue = "#83a598",
        red = "#F24949",
        error_red = "#F24949"
    }
    local condition = require("galaxyline.condition")
    local gls = gl.section
    gl.short_line_list = {"NvimTree", "vista", "dbui", "packer"}
    gls.left[1] = {
        ViMode = {
            provider = function()
                -- auto change color according the vim mode
                local alias = {
                    n = "NORMAL",
                    v = "VISUAL",
                    V = "V-LINE",
                    [""] = "V-BLOCK",
                    s = "SELECT",
                    S = "S-LINE",
                    [""] = "S-BLOCK",
                    i = "INSERT",
                    R = "REPLACE",
                    c = "COMMAND",
                    r = "PROMPT",
                    ["!"] = "EXTERNAL",
                    t = "TERMINAL"
                }
                local mode_color = {
                    n = colors.green,
                    v = colors.orange,
                    V = colors.orange,
                    [""] = colors.orange,
                    s = colors.orange,
                    S = colors.orange,
                    [""] = colors.orange,
                    i = colors.red,
                    R = colors.red,
                    c = colors.blue,
                    r = colors.magenta,
                    ["!"] = colors.darkblue,
                    t = colors.darkblue
                }
                local vim_mode = vim.fn.mode()
                vim.api.nvim_command("hi GalaxyViMode guifg=" .. mode_color[vim_mode])
                return alias[vim_mode] .. "    "
            end,
            highlight = {colors.red, colors.line_bg, "bold"}
        }
    }
    gls.left[2] = {
        FileIcon = {
            provider = "FileIcon",
            condition = condition.buffer_not_empty,
            highlight = {colors.magenta, colors.line_bg}
        }
    }
    gls.left[3] = {
        FileName = {
            provider = {"FileName"},
            condition = condition.buffer_not_empty,
            separator = " ",
            separator_highlight = {"NONE", colors.bg},
            highlight = {colors.magenta, colors.line_bg}
        }
    }
    gls.left[4] = {
        GitIcon = {
            provider = function()
                return "  "
            end,
            condition = condition.check_git_workspace,
            -- separator = " ",
            separator_highlight = {"NONE", colors.bg},
            highlight = {colors.orange, colors.bg}
        }
    }
    gls.left[5] = {
        GitBranch = {
            provider = "GitBranch",
            condition = condition.check_git_workspace,
            separator = " ",
            separator_highlight = {"NONE", colors.bg},
            highlight = {colors.grey, colors.bg}
        }
    }
    gls.left[6] = {
        DiffAdd = {
            provider = "DiffAdd",
            condition = condition.hide_in_width,
            icon = "   ",
            highlight = {colors.green, colors.bg}
        }
    }
    gls.left[7] = {
        DiffModified = {
            provider = "DiffModified",
            condition = condition.hide_in_width,
            icon = "   ",
            highlight = {colors.orange, colors.bg}
        }
    }
    gls.left[8] = {
        DiffRemove = {
            provider = "DiffRemove",
            condition = condition.hide_in_width,
            icon = "   ",
            highlight = {colors.red, colors.bg}
        }
    }
    gls.right[1] = {
        DiagnosticError = {
            provider = "DiagnosticError",
            icon = "  ",
            highlight = {colors.error_red, colors.bg}
        }
    }
    gls.right[2] = {
        DiagnosticWarn = {
            provider = "DiagnosticWarn",
            icon = "  ",
            highlight = {colors.orange, colors.bg}
        }
    }
    gls.right[3] = {
        DiagnosticHint = {
            provider = "DiagnosticHint",
            icon = "  ",
            highlight = {colors.orange, colors.bg}
        }
    }
    gls.right[4] = {
        DiagnosticInfo = {
            provider = "DiagnosticInfo",
            icon = "  ",
            highlight = {colors.blue, colors.bg}
        }
    }
    gls.right[5] = {
        ShowLspClient = {
            provider = "GetLspClient",
            condition = function()
                local tbl = {["dashboard"] = true, [" "] = true}
                if tbl[vim.bo.filetype] then
                    return false
                end
                return true
            end,
            icon = "   ",
            highlight = {colors.purple, colors.bg}
        }
    }
    gls.right[6] = {
        LineInfo = {
            provider = "LineColumn",
            separator = "  ",
            separator_highlight = {"NONE", colors.bg},
            highlight = {colors.grey, colors.bg}
        }
    }
    gls.right[7] = {
        PerCent = {
            provider = "LinePercent",
            separator = " ",
            separator_highlight = {"NONE", colors.bg},
            highlight = {colors.grey, colors.bg}
        }
    }
    gls.right[8] = {
        Tabstop = {
            provider = function()
                return "Spaces: " .. vim.api.nvim_buf_get_option(0, "tabstop") .. " "
            end,
            condition = condition.hide_in_width,
            separator = " ",
            separator_highlight = {"NONE", colors.bg},
            highlight = {colors.grey, colors.bg}
        }
    }
    gls.right[9] = {
        BufferType = {
            provider = "FileTypeName",
            condition = condition.hide_in_width,
            separator = " ",
            separator_highlight = {"NONE", colors.bg},
            highlight = {colors.grey, colors.bg}
        }
    }
    gls.right[10] = {
        FileEncode = {
            provider = "FileEncode",
            condition = condition.hide_in_width,
            separator = " ",
            separator_highlight = {"NONE", colors.bg},
            highlight = {colors.grey, colors.bg}
        }
    }
    gls.right[11] = {
        Space = {
            provider = function()
                return " "
            end,
            separator = " ",
            separator_highlight = {"NONE", colors.bg},
            highlight = {colors.orange, colors.bg}
        }
    }
    gls.short_line_left[1] = {
        BufferType = {
            provider = "FileTypeName",
            separator = " ",
            separator_highlight = {"NONE", colors.bg},
            highlight = {colors.grey, colors.bg}
        }
    }
    gls.short_line_left[2] = {
        SFileName = {
            provider = "SFileName",
            condition = condition.buffer_not_empty,
            highlight = {colors.grey, colors.bg}
        }
    }
    gls.short_line_right[1] = {
        BufferIcon = {
            provider = "BufferIcon",
            highlight = {colors.grey, colors.bg}
        }
    }
end
