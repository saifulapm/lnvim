---@diagnostic disable: undefined-global

return {
  s(
    { trig = 'met', name = 'Method' },
    fmt(
      [[
        public function {}({})
        {{
            {}
        }}{}
      ]],
      { i(1), i(2), i(3), i(4) }
    )
  ),
  ------------------------------------------------------------------------------------------------------------------------
  --  Laravel Code Generations
  ------------------------------------------------------------------------------------------------------------------------
  -- Controller
  s(
    { trig = 'lcon', name = 'Laravel Controller' },
    fmt(
      [[
        <?php
        namespace App\Http\Controllers;
        class {}{} extends Controller
        {{
            public function {}()
            {{
                {}
            }}{}
        }}
      ]],
      {
        i(1, 'Demo'),
        i(2, 'Controller'),
        c(3, { t('index'), t('__invoke') }),
        i(4),
        i(0),
      }
    )
  ),
}
