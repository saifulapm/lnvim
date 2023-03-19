local u = require('utils.const')
local api, uv = vim.api, vim.loop
local pd = {}
local arrow = u.get_arrow()

local function alias_mode()
  return {
    n = { 'NRM', 'Normal' },
    niI = { 'N·I', 'Normal' }, -- i_CTRL_O
    niR = { 'N·R', 'Normal' }, -- R_CTRL_O
    niV = { 'NRV', 'Normal' }, -- gR_CTRL_O
    no = { 'NOP', 'Normal' },
    nov = { 'NOV', 'Normal' }, -- o_v
    noV = { 'NVL', 'Normal' }, -- o_V
    ['no'] = { 'NVB', 'Normal' }, -- o_CTRL-V
    nt = { 'N·T', 'Normal' },
    i = { 'INS', 'Insert' },
    ix = { 'I·X', 'Insert' }, -- i_CTRL_X
    ic = { 'I·C', 'Insert' }, -- i_CTRL_N | i_CTRL_P
    v = { 'VIS', 'Visual' },
    [''] = { 'V·B', 'Visual' },
    V = { 'V·L', 'Visual' },
    vs = { 'S·V', 'Visual' }, -- gh_CTRL_O
    Vs = { 'SVL', 'Visual' }, -- gH_CTRL_O
    c = { 'CMD', 'Command' },
    s = { 'SEL', 'Select' }, -- gh
    S = { 'S·L', 'Select' }, -- gH
    [''] = { 'S·B', 'Select' }, -- g_CTRL_H
    R = { 'REP', 'Replace' }, -- R
    Rx = { 'R·X', 'Replace' }, -- R_CTRL_X
    Rc = { 'R·C', 'Replace' }, -- R_CTRL_P
    Rv = { 'R·V', 'Replace' }, -- gR
    Rvc = { 'RVC', 'Replace' }, -- gR_CTRL_P
    Rvx = { 'RVX', 'Replace' }, -- gR_CTRL_X
    t = { 'TRM', 'Terminal' },
  }
end

function pd.mode()
  local alias = alias_mode()
  local result = {
    stl = function()
      local mode = api.nvim_get_mode().mode
      return ' ' .. alias[mode][1] or mode
    end,
    name = function()
      local mode = api.nvim_get_mode().mode
      return alias[mode][2] or 'Normal'
    end,
    event = { 'ModeChanged', 'BufEnter' },
  }

  return result
end

function pd.mode_sep()
  local alias = alias_mode()
  local result = {
    stl = function() return arrow.right end,
    name = function()
      local mode = api.nvim_get_mode().mode
      return alias[mode][2] .. 'Sep' or 'NormalSep'
    end,
    event = { 'ModeChanged', 'BufEnter' },
  }

  return result
end

local function path_sep() return uv.os_uname().sysname == 'Windows_NT' and '\\' or '/' end

function pd.fileinfo()
  local function stl_path()
    local i = 1
    local trunc = 2
    local path = vim.fn.expand('%:.:h')
    local path_split = vim.split(path, '/')
    local sep = path_sep()
    sep = ('%%#StatusLinePathSep#%s%%#StatusLinePath#'):format(sep)
    i = #path_split > trunc and #path_split - (trunc - 1) or i
    path = table.concat(path_split, (' %s '):format(sep), i)

    if i > 1 then path = ('%s%s'):format(('… %s '):format(sep), path) end

    if path == '' then
      path = ('%s%%#StatusLinePathArrow#%s'):format(path, arrow.right)
    else
      path = (' %s%%#StatusLinePathArrow#%s'):format(path, arrow.right)
    end

    local name = vim.fn.expand('%:.:t')
    if name ~= '' then
      name = ('%%#StatusLineFileName#%s'):format(name)
      local ok, devicon = pcall(require, 'nvim-web-devicons')
      if ok then
        local icon = devicon.get_icon_by_filetype(vim.bo.filetype, { default = true })
        icon = ('%%#StatusLineIcon%s#%s%%#StatusLineFileName#'):format(vim.bo.filetype, icon)
        name = ('%s%s'):format(icon, (' %s '):format(name))
      end

      path = ('%s%s'):format(path, (' %s'):format(name))
    end

    path = ('%s%%#StatusLineFileArrow#%s'):format(path, arrow.right)

    return path
  end

  return { stl = stl_path, name = 'Path', event = { 'BufEnter' } }
end

local function get_progress_messages()
  local new_messages = {}
  local progress_remove = {}

  for _, client in ipairs(vim.lsp.get_active_clients()) do
    local messages = client.messages
    local data = messages
    for token, ctx in pairs(data.progress) do
      local new_report = {
        name = data.name,
        title = ctx.title or 'empty title',
        message = ctx.message,
        percentage = ctx.percentage,
        done = ctx.done,
        progress = true,
      }
      table.insert(new_messages, new_report)

      if ctx.done then table.insert(progress_remove, { client = client, token = token }) end
    end
  end

  if not vim.tbl_isempty(progress_remove) then
    for _, item in ipairs(progress_remove) do
      item.client.messages.progress[item.token] = nil
    end
    return {}
  end

  return new_messages
end

local index = 1
function pd.lsp()
  local function lsp_stl()
    local new_messages = get_progress_messages()
    local res = {}
    local spinner = { '🌖', '🌗', '🌘', '🌑', '🌒', '🌓', '🌔' }

    if not vim.tbl_isempty(new_messages) then
      table.insert(res, spinner[index] .. ' Waiting')
      index = index + 1 > #spinner and 1 or index + 1
    end

    if #res == 0 then
      local client = vim.lsp.get_active_clients({ bufnr = 0 })
      if #client ~= 0 then table.insert(res, client[1].name) end
    end
    return '%.20{"' .. table.concat(res, '') .. '"}'
  end

  local result = {
    stl = lsp_stl,
    name = 'Lsp',
    event = { 'LspProgressUpdate', 'LspAttach' },
  }

  return result
end

local function gitsigns_data(type)
  ---@diagnostic disable-next-line: undefined-field
  if not vim.b.gitsigns_status_dict then return '' end

  local val = vim.b.gitsigns_status_dict[type]
  val = (val == 0 or not val) and '' or tostring(val) .. (type == 'head' and '' or ' ')
  return val
end

local function git_icons(type)
  local tbl = {
    ['added'] = ' ',
    ['changed'] = ' ',
    ['deleted'] = ' ',
  }
  return tbl[type]
end

function pd.gitadd()
  local result = {
    stl = function()
      local res = gitsigns_data('added')
      return #res > 0 and git_icons('added') .. res or ''
    end,
    name = 'gitadd',
    event = { 'GitSignsUpdate' },
  }
  return result
end

function pd.gitchange()
  local result = {
    stl = function()
      local res = gitsigns_data('changed')
      return #res > 0 and git_icons('changed') .. res or ''
    end,
    name = 'gitchange',
    event = { 'GitSignsUpdate' },
  }

  return result
end

function pd.gitdelete()
  local result = {
    stl = function()
      local res = gitsigns_data('deleted')
      return #res > 0 and git_icons('deleted') .. res or ''
    end,
    name = 'gitdelete',
    event = { 'GitSignsUpdate' },
  }

  return result
end

function pd.branch()
  local result = {
    stl = function()
      local icon = ' '
      local res = gitsigns_data('head')
      return #res > 0 and icon .. res or 'UNKOWN'
    end,
    name = 'gitbranch',
    event = { 'GitSignsUpdate' },
  }
  return result
end

function pd.pad()
  return {
    stl = '%=',
    name = 'pad',
    attr = {
      background = 'NONE',
      foreground = 'NONE',
    },
  }
end

function pd.lnumcol()
  -- local sep = path_sep()
  local sep = ('%%#StatusLineLinesArrow#%s%%#StatusLineLines#'):format(arrow.left)
  local stl = ('%%-4.(%%l:%%c%%) %s %%L '):format(sep)
  local result = {
    stl = stl,
    name = 'LineCol',
    event = { 'CursorHold' },
  }

  return result
end

local function diagnostic_info(severity)
  if vim.diagnostic.is_disabled(0) then return '' end

  local signs = {
    ' ',
    ' ',
    ' ',
    ' ',
  }
  local count = #vim.diagnostic.get(0, { severity = severity })
  return count == 0 and '' or signs[severity] .. tostring(count) .. ' '
end

function pd.diagError()
  local result = {
    stl = function() return diagnostic_info(1) end,
    name = 'diagError',
    event = { 'DiagnosticChanged' },
  }
  return result
end

function pd.diagWarn()
  local result = {
    stl = function() return diagnostic_info(2) end,
    name = 'diagWarn',
    event = { 'DiagnosticChanged', 'BufEnter' },
  }
  return result
end

function pd.diagInfo()
  local result = {
    stl = function() return diagnostic_info(3) end,
    name = 'diaginfo',
    event = { 'DiagnosticChanged', 'BufEnter' },
  }
  return result
end

function pd.diagHint()
  local result = {
    stl = function() return diagnostic_info(4) end,
    name = 'diaghint',
    event = { 'DiagnosticChanged', 'BufEnter' },
  }
  return result
end

function pd.encoding()
  local result = {
    stl = '%{&fileencoding?&fileencoding:&encoding}',
    name = 'filencode',
    event = { 'BufEnter' },
  }
  return result
end

return pd
