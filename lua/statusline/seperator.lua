local u = require('utils.const')
local sp = {}
local arrow = u.get_arrow()

function sp.sep()
  return {
    stl = ' ',
    name = 'EmptySpace',
  }
end

function sp.arrow_right()
  return {
    stl = arrow.right,
    name = 'ArrowRight',
  }
end

function sp.arrow_left()
  return {
    stl = arrow.left,
    name = 'ArrowLeft',
  }
end

return sp
