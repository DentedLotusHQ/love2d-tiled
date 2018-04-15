local class = require("lib.middleclass")

local List = require("game.utilities.list")
local DrawableList = class('DrawableList', List)

function DrawableList:initialize()
  List:initialize()
end

function DrawableList:draw()
  for i=1, #self.list do
    self.list[i].object:draw()
  end
end

return DrawableList