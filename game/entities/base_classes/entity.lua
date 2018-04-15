local class = require("lib.middleclass")
local EntityBase = class("EntityBase")
local Vector2 = require("game.point")

function EntityBase:initialize(position, tileSize)
  self.position = position
  self.size = tileSize
  self.velocity = Vector2:new(0, 0)
end

return EntityBase