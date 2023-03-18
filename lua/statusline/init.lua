local co, api = coroutine, vim.api
local whk = {}

local function stl_format(name, val)
  return '%#StatusLine' .. name .. '#' .. val .. '%*'
end

local function default()
  local p = require('statusline.provider')
  local s = require('statusline.seperator')
  return {
    --
    p.mode,
    p.mode_sep,
    --
    p.fileinfo,
    --
    p.pad,
    p.diagError,
    p.diagWarn,
    p.diagInfo,
    p.diagHint,
    p.pad,
    --
    s.sep,
    --
    s.sep,
    p.lsp,
    s.sep,
    --
    s.sep,
    p.gitadd,
    p.gitchange,
    p.gitdelete,
    p.branch,
    s.sep,
    --
    s.sep,
    --
    -- s.sep,
    -- p.encoding,
    -- s.sep,
    --
    s.arrow_left,
    p.lnumcol,
  }
end

local function whk_init(event, pieces)
  whk.cache = {}
  for i, e in pairs(whk.elements) do
    local res = e()
    if type(res.stl) == 'string' then
      pieces[#pieces + 1] = stl_format(res.name, res.stl)
    else
      local name = type(res.name) == 'function' and res.name() or res.name
      if res.event and vim.tbl_contains(res.event, event) then
        local val = type(res.stl) == 'function' and res.stl() or res.stl
        pieces[#pieces + 1] = stl_format(name, val)
      else
        pieces[#pieces + 1] = stl_format(name, '')
      end
    end
    whk.cache[i] = {
      event = res.event,
      name = res.name,
      stl = res.stl,
    }
  end
  return table.concat(pieces, '')
end

local stl_render = co.create(function(event)
  local pieces = {}
  while true do
    if not whk.cache then
      whk_init(event, pieces)
    else
      for i, item in pairs(whk.cache) do
        if item.event and vim.tbl_contains(item.event, event) and type(item.stl) == 'function' then
          local comp = whk.elements[i]
          local res = comp()
          local name = type(item.name) == 'function' and item.name() or item.name
          pieces[i] = stl_format(name, res.stl())
        end
      end
    end

    vim.schedule(function()
      vim.opt.stl = table.concat(pieces)
    end)
    event = co.yield()
  end
end)

function whk.setup()
  whk.elements = default()

  api.nvim_create_autocmd({ 'User' }, {
    pattern = { 'LspProgressUpdate', 'GitSignsUpdate' },
    callback = function(opt)
      if opt.event == 'User' then
        opt.event = opt.match
      end
      co.resume(stl_render, opt.event)
    end,
  })

  local events = { 'DiagnosticChanged', 'ModeChanged', 'BufEnter', 'BufWritePost', 'LspAttach' }
  api.nvim_create_autocmd(events, {
    callback = function(opt)
      co.resume(stl_render, opt.event)
    end,
  })
end

return whk
