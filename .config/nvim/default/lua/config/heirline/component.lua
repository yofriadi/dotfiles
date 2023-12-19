local M = {}
local hc = require("config.heirline")
local hl = require("config.heirline.highlight")
local util = require("config.heirline.util")
local cond = require("config.heirline.condition")

function M.vi_mode()
  return {
    init = function(self) self.mode = vim.fn.mode(1) end,
    static = {
      mode_names = {
        n = "N",
        no = "N?",
        nov = "N?",
        noV = "N?",
        ["no\22"] = "N?",
        niI = "Ni",
        niR = "Nr",
        niV = "Nv",
        nt = "Nt",
        v = "V",
        vs = "Vs",
        V = "V_",
        Vs = "Vs",
        ["\22"] = "^V",
        ["\22s"] = "^V",
        s = "S",
        S = "S_",
        ["\19"] = "^S",
        i = "I",
        ic = "Ic",
        ix = "Ix",
        R = "R",
        Rc = "Rc",
        Rx = "Rx",
        Rv = "Rv",
        Rvc = "Rv",
        Rvx = "Rv",
        c = "C",
        cv = "Ex",
        r = "...",
        rm = "M",
        ["r?"] = "?",
        ["!"] = "!",
        t = "T",
      },
      mode_colors = {
        n = "red" ,
        i = "green",
        v = "cyan",
        V =  "cyan",
        ["\22"] =  "cyan",
        c =  "orange",
        s =  "purple",
        S =  "purple",
        ["\19"] =  "purple",
        R =  "orange",
        r =  "orange",
        ["!"] =  "red",
        t =  "red",
      }
    },
    provider = function(self)
      return " %1("..self.mode_names[self.mode].."%)"
    end,
    hl = function(self)
      local mode = self.mode:sub(1, 1)
      return { fg = self.mode_colors[mode], bold = true, }
    end,
    update = {
      "ModeChanged",
      pattern = "*:*",
      callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end),
    },
  }
end

function M.file_info(opts)
  return util.builder(util.setup_providers(vim.tbl_deep_extend("force", {
    file_icon = { hl = hl.file_icon("statusline"), padding = { left = 1, right = 1 } },
    filetype = {},
    filename = {},
    file_modified = { padding = { left = 1 } },
    file_read_only = { padding = { left = 1 } },
    surround = { separator = "left", color = "file_info_bg", condition = cond.has_filetype },
    hl = hl.get_attributes("file_info"),
  }, opts), {
    "file_icon",
    "unique_path",
    "filename",
    "filetype",
    "file_modified",
    "file_read_only",
    "close_button",
  }))
end

function M.git_branch()
  return util.builder(util.setup_providers({
    git_branch = { icon = { kind = "GitBranch", padding = { right = 1 } } },
    surround = { separator = "left", color = "git_branch_bg", condition = cond.is_git_repo },
    hl = hl.get_attributes("git_branch"),
    update = { "User", pattern = "GitSignsUpdate" },
    init = hc.update_events({ "BufEnter" }),
  }, { "git_branch" }))
end

function M.tabline_file_info()
  return M.file_info({
    file_icon = {
      condition = function(self) return not self._show_picker end,
      hl = hl.file_icon "tabline",
    },
    unique_path = {
      hl = function(self) return hl.get_attributes(self.tab_type .. "_path") end,
    },
    close_button = {
      hl = function(self) return hl.get_attributes(self.tab_type .. "_close") end,
      padding = { left = 1, right = 1 },
      on_click = {
        callback = function(_, minwid) buffer_utils.close(minwid) end,
        minwid = function(self) return self.bufnr end,
        name = "heirline_tabline_close_buffer_callback",
      },
    },
    padding = { left = 1, right = 1 },
    hl = function(self)
      local tab_type = self.tab_type
      if self._show_picker and self.tab_type ~= "buffer_active" then tab_type = "buffer_visible" end
      return hl.get_attributes(tab_type)
    end,
    surround = false,
  })
end

return M
