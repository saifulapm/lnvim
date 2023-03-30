---@diagnostic disable: undefined-global
--
return {
  -- Require statement
  s(
    'req',
    fmt([[local {} = require('{}')]], {
      f(function(import_name)
        ---@diagnostic disable-next-line: param-type-mismatch
        local parts = vim.split(import_name[1][1], '.', true)
        return parts[#parts] or ''
      end, { 1 }),
      i(1),
    })
  ),

  -- Function declaration
  s(
    'f',
    fmt(
      [[
function({})
  {}
end
  ]],
      { i(1), i(2) }
    )
  ),

  -- If statement
  s(
    'lf',
    fmt(
      [[
local {} = function({})
  {}
end
  ]],
      { i(1), i(2), i(3) }
    )
  ),
}
