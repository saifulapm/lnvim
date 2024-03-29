---@diagnostic disable: undefined-global
--
return {
  s({ trig = 'cl', name = 'Console Log' }, fmt('console.log({});', i(1))),
  s({ trig = 'ds', name = 'Query Selector' }, fmt('document.querySelector({})', i(1))),
  s({ trig = 'dsa', name = 'Query SelectorAll' }, fmt('document.querySelectorAll(({}) => {})', { i(1), i(2) })),
  -- Function declaration
  s(
    'f',
    fmt(
      [[
{}const {} = ({}) => {{
  {}
}};
]],
      {
        i(1, 'export '),
        i(2),
        i(3),
        i(4),
      }
    )
  ),

  -- If statement
  s(
    'if',
    fmt(
      [[
if ({}) {{
  {}
}}
]],
      { i(1), i(2) }
    )
  ),

  -- Export statement
  s(
    'export',
    fmt([[export {{ {} }} from './{}';]], {
      d(2, function(args)
        return sn(nil, {
          i(1, args[1][1]),
        })
      end, { 1 }),
      i(1),
    })
  ),

  -- Component index file export
  s(
    'indexport',
    fmt([[export {{ default }} from './{}';]], {
      d(1, function()
        local folder_name = vim.fn.expand('%:h:t')
        return sn(nil, {
          c(1, { i(nil, folder_name), i(nil, folder_name .. '.vue') }),
        })
      end),
    })
  ),

  -- Test describe block
  s(
    'desc',
    fmt(
      [[
describe('{}', () => {{
  {}
}});
]],
      {
        d(1, function(_, snip)
          local filename, _ = (snip.env.TM_DIRECTORY .. '/' .. snip.env.TM_FILENAME_BASE):gsub(vim.pesc(vim.loop.cwd() .. '/'), '')
          local filename_without_junk, _ =
            filename:gsub('^test/', ''):gsub('^src/', ''):gsub('.spec$', ''):gsub('.test$', ''):gsub('__tests__/', '')

          return sn(nil, {
            i(1, filename_without_junk),
          })
        end, { 1 }),
        i(2),
      }
    )
  ),

  -- Test case
  s(
    'it',
    fmt(
      [[
it('{}', {}() => {{
  {}
}});
]],
      { i(1), c(2, { t('async '), t('') }), i(3) }
    )
  ),

  -- Computed variable
  -- TODO: Can we somehow automatically import `computed` if it's not imported?
  s(
    'computed',
    fmt(
      [[
const {} = computed(() => {});
  ]],
      { i(1), c(2, { fmt(
        [[
{{
  return {}
}}
]],
        { i(1) }
      ), i(nil, '') }) }
    )
  ),
}
