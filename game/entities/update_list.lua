local List = require("game.utilities.list")
local UpdateList = class('UpdateList', List)

function UpdateList:initialize()
  List:initialize()
end

function UpdateList:update(dt)
  for i=1, #self.list do
    self.list[i].object:update(dt)
  end
end

return UpdateList