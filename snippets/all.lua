---@diagnostic disable: undefined-global

math.randomseed(os.time())
local function uuid()
  local random = math.random
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  local out = nil
  local function subs(c)
    local v = (((c == 'x') and random(0, 15)) or random(8, 11))
    return string.format('%x', v)
  end

  out = template:gsub('[xy]', subs)
  return out
end

local LOREM_IPSUM =
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

local function date() return { os.date('%Y-%m-%d') } end

local function uuid_() return { uuid() } end

local function lorem(_, snip)
  if snip.captures[1] == '' then
    return { LOREM_IPSUM }
  else
    local amount = tonumber(snip.captures[1])
    return { LOREM_IPSUM:sub(1, (amount + 1)) }
  end
end

local function replace_each(replacer)
  local function wrapper(args)
    local len = #args[1][1]
    return { replacer:rep(len) }
  end

  return wrapper
end

local function sf(trig, body, reg_trig) return s({ trig = trig, regTrig = reg_trig, wordTrig = true }, { f(body, {}), i(0) }) end

return {
  sf('date', date),
  sf('uuid', uuid_),
  sf('lorem(%d*)', lorem, true),
  s({ trig = 'bbox' }, {
    t({ '\226\149\148' }),
    f(replace_each('\226\149\144'), { 1 }),
    t({ '\226\149\151', '\226\149\145' }),
    i(1, { 'content' }),
    t({ '\226\149\145', '\226\149\154' }),
    f(replace_each('\226\149\144'), { 1 }),
    t({ '\226\149\157' }),
    i(0, 'asd'),
  }),
  s({ trig = 'td', name = 'TODO' }, {
    d(1, function()
      local function with_cmt(cmt) return string.format(vim.bo.commentstring, ' ' .. cmt) end
      return s('', {
        c(1, {
          t(with_cmt('TODO: ')),
          t(with_cmt('FIXME: ')),
          t(with_cmt('HACK: ')),
          t(with_cmt('BUG: ')),
        }),
      })
    end),
    i(0),
  }),
  s({ trig = 'cl', name = 'Console Log' }, fmt('console.log({});', i(1))),
  s({ trig = 'ds', name = 'Query Selector' }, fmt('document.querySelector({})', i(1))),
  s({ trig = 'dsa', name = 'Query SelectorAll' }, fmt('document.querySelectorAll(({}) => {})', { i(1), i(2) })),
  s(
    { trig = 'hr', name = 'Header' },
    fmt(
      [[
            {1}
            {2} {3}
            {1}
            {4}
          ]],
      {
        f(function()
          local comment = string.format(vim.bo.commentstring:gsub(' ', '') or '#%s', '-')
          local col = vim.bo.textwidth or 80
          return comment .. string.rep('-', col - #comment)
        end),
        f(function() return vim.bo.commentstring:gsub('%%s', '') end),
        i(1, 'HEADER'),
        i(0),
      }
    )
  ),
}
