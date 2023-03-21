---@diagnostic disable: undefined-global
--
return {
  s({ trig = 'cl', name = 'Console Log' }, fmt('console.log({});', i(1))),
  s({ trig = 'ds', name = 'Query Selector' }, fmt('document.querySelector({})', i(1))),
}
