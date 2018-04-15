local class = require("lib.middleclass")
local List = require("game.utilities.list")
local DrawingList = class('DrawingList', List)

function DrawingList:initialize()
  List:initialize()
end

function DrawingList:draw()
  for i=1, #self.list do
    self.list[i].object:draw()
  end
end

return DrawingList