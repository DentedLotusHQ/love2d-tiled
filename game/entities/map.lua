local class = require("lib.middleclass")

local Map = class("Map")

local Point = require("game.point")

local insert = table.insert

function Map:initialize()
  updatables:add(self, 'map')
  drawables:add(self, 'map')
end

function Map:update(dt)

end

function Map:draw()
  for rowIndex, row in ipairs(self.tileTable) do
    for columnIndex, char in ipairs(row) do
      local x,y = (columnIndex - 1) * self.tileW, (rowIndex - 1) * self.tileH
      love.graphics.draw(self.tileSet, self.quads[char], x, y)
    end
  end
end

return Map