local sp = {}

function sp.sep()
  return {
    stl = ' ',
    name = 'EmptySpace',
  }
end

function sp.pad()
  return {
    stl = '%=',
    name = 'pad',
    attr = {
      background = 'NONE',
      foreground = 'NONE',
    },
  }
end

return sp
