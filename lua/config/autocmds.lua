local augroup = require("utils.augroup")
local api = vim.api
local fn = vim.fn
local get_option = api.nvim_get_option
local set_option = api.nvim_set_option
local win_get_option = api.nvim_win_get_option
local win_set_option = api.nvim_win_set_option
local buf_get_option = api.nvim_buf_get_option
local buf_set_option = api.nvim_buf_set_option

augroup("highlight_postyank", function(autocmd)
  autocmd("TextYankPost", "*", function()
    vim.highlight.on_yank()
  end)
end)

augroup("macro_recording", function(autocmd)
  local opts = { title = "Macro", icon = "", timeout = 250 }

  autocmd("RecordingEnter", "*", function()
    local msg = (" 壘Recording @%s"):format(vim.fn.reg_recording())
    vim.notify(msg, vim.log.levels.INFO, opts)
  end)

  autocmd("RecordingLeave", "*", function()
    local msg = ("  Recorded @%s"):format(vim.v.event.regname)
    vim.notify(msg, vim.log.levels.INFO, opts)
  end)
end)

augroup("prewrite_action", function(autocmd)
  autocmd("BufWritePre", "*", function()
    local cursor = api.nvim_win_get_cursor(0)
    vim.cmd([[:%s/\s\+$//e]])
    api.nvim_win_set_cursor(0, cursor)
  end)
end)

augroup("handle_large_file", function(autocmd)
  autocmd({ "BufReadPre", "BufRead", "BufReadPost", "BufwinEnter" }, "*", function(args)
    local size = fn.getfsize(fn.expand("<afile>"))
    local allowed_max_size = 1020 * 1024 * 2 -- 2MB
    if size > allowed_max_size then
      buf_set_option(args.buf, "filetype", "off")
      buf_set_option(args.buf, "syntax", "clear")
      buf_set_option(args.buf, "syntax", "off")
    end
  end)
end)
