local pd = require('statusline.provider')
local sp = {}

local default_sep_icons = {
  default = { left = "", right = " " },
  round = { left = "", right = "" },
  block = { left = "█", right = "█" },
  arrow = { left = "", right = "" },
}

function sp.sep()
  return {
    stl = ' ',
    name = 'EmptySpace',
  }
end

function sp.arrow_right()
  return {
    stl = '',
    name = 'ArrowRight',
  }
end

function sp.arrow_left()
  return {
    stl = '',
    name = 'ArrowLeft',
  }
end

return sp
