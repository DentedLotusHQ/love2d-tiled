local class = require("lib.middleclass")
local EntityBase = class("EntityBase")
local Vector2 = require("game.point")

function EntityBase:initialize()
  self.name = 'EntityBase'
  self.position = Vector2:new(0, 0)
  self.size = Vector2:new(16, 16)
  self.velocity = Vector2:new(0, 0)
  self.components = {}

end

function EntityBase:addComponent(c)
  c:decorate(self)
end

function EntityBase:update(dt)
  for i=#self.components, 1, -1 do
    compName = self.components[i]
    if self[compName].remove then
      self[compName] = nil
      table.remove(self.components, i)
    end
    if self[compName] then
      self[compName]:update(dt)
    end
  end
end

return EntityBase