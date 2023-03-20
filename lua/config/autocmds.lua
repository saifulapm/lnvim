local augroup = require('utils.augroup')
local api = vim.api
local fn = vim.fn

augroup('handle_large_file', function(autocmd)
  autocmd({ 'BufReadPre', 'BufRead', 'BufReadPost', 'BufwinEnter' }, '*', function(args)
    local size = fn.getfsize(fn.expand('<afile>'))
    local allowed_max_size = 1020 * 1024 * 2 -- 2MB
    if size > allowed_max_size then
      api.nvim_buf_set_option(args.buf, 'filetype', 'off')
      api.nvim_buf_set_option(args.buf, 'syntax', 'clear')
      api.nvim_buf_set_option(args.buf, 'syntax', 'off')
    end
  end)
end)

augroup('macro_recording', function(autocmd)
  local opts = { title = 'Macro', icon = '', timeout = 250 }

  autocmd('RecordingEnter', '*', function()
    local msg = (' 壘Recording @%s'):format(vim.fn.reg_recording())
    vim.notify(msg, vim.log.levels.INFO, opts)
  end)

  autocmd('RecordingLeave', '*', function()
    local msg = ('  Recorded @%s'):format(vim.v.event.regname)
    vim.notify(msg, vim.log.levels.INFO, opts)
  end)
end)
