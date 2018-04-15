local List = require("game.utilities.list")
local DrawingList = class('DrawingList', List)

function DrawingList:initialize()
  List:initialize()
end

function DrawingList:draw()
  for i=1, #self.list do
    print("drawing " ..self.list[i].id)
    self.list[i].object:draw()
  end
end

return DrawingList