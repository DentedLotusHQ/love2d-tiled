local class = require("lib.middleclass")

local Map = class("Map")

local Point = require("game.point")

local insert = table.insert

function Map:initialize(tileSet, quadInfo, tileString, tileW, tileH, graphics)
  self.tileSet = tileSet
  local tilesetW, tilesetH = self.tileSet:getWidth(), self.tileSet:getHeight()
  self.quadInfo = quadInfo
  self.tileW = tileW
  self.tileH = tileH
  self.graphics = graphics
  self.quads, self.entityMap = getQuads(quadInfo, self.tileW, self.tileH, tilesetW, tilesetH)
  self.tileTable, self.walkTable, self.pointLists = parseString(tileString)
end

function Map:update(dt)

end

function Map:draw()
  for rowIndex, row in ipairs(self.tileTable) do
    for columnIndex, char in ipairs(row) do
      local x,y = (columnIndex - 1) * self.tileW, (rowIndex - 1) * self.tileH
      self.graphics.draw(self.tileSet, self.quads[char], x, y)
    end
  end
end

return Map