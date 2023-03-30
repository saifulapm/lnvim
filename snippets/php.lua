---@diagnostic disable: undefined-global
local function capitalized(args) return (args[1][1]:gsub('^%l', string.upper)) end

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

  ------------------------------------------------------------------------------------------------------------------------------------------------------
  --  Some more
  ------------------------------------------------------------------------------------------------------------------------------------------------------
  -- Setter
  s(
    'set',
    fmt(
      [[
public function set{}({} ${}): void {{
	$this->{} = ${};
}}
]],
      {
        f(capitalized, { 1 }),
        i(2),
        rep(1),
        i(1),
        rep(1),
      }
    )
  ),
  -- Getter and setter
  s(
    'getset',
    fmt(
      [[
public function get{}(): {} {{
	return $this->{};
}}
public function set{}({} ${}): void {{
	$this->{} = ${};
}}
]],
      {
        f(capitalized, { 1 }),
        i(2),
        i(1),
        f(capitalized, { 1 }),
        rep(2),
        rep(1),
        rep(1),
        rep(1),
      }
    )
  ),
}
