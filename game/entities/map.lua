local Map = class("Map")

local Point = require("game.point")

local insert = table.insert

function Map:initialize(tileSet, quadInfo, tileString, tileW, tileH)
  self.tileSet = tileSet
  local tilesetW, tilesetH = self.tileSet:getWidth(), self.tileSet:getHeight()
  self.quadInfo = quadInfo
  self.tileW = tileW
  self.tileH = tileH
  self.quads, self.entityMap = getQuads(quadInfo, self.tileW, self.tileH, tilesetW, tilesetH)
  self.tileTable, self.walkTable, self.pointLists = parseString(tileString)
end

function Map:getPoints(entity)
  local character = self.entityMap[entity]
  return self.pointLists[character]
end

function Map:addPoint(character, point)
  if self.pointLists[character] == nil then
    self.pointLists[character] = {}
  end
  insert(self.pointLists[character], point)
end

function Map:draw(graphics)
  for rowIndex, row in ipairs(self.tileTable) do
    for columnIndex, char in ipairs(row) do
      local x,y = (columnIndex - 1) * self.tileW, (rowIndex - 1) * self.tileH
      graphics.draw(self.tileSet, self.quads[char], x, y)
    end
  end
end

function getQuads(quadInfo, tileW, tileH, tilesetW, tilesetH)
  local quads = {}
  local entityMap = {}
  for _,info in ipairs(quadInfo) do
    -- info[1] = character, info[2]= x, info[3] = y
    quads[info[2]] = love.graphics.newQuad(info[3], info[4], tileW, tileH, tilesetW, tilesetH)
    -- keeps track of the human readable names to their character representation
    entityMap[info[1]] = info[2]
  end

  return quads, entityMap
end

-- parse the string that will be our map
function parseString(tileString)
  local rowIndex = 1
  local columnIndex = 1

  local tileTable = {}
  local walkTable = {}
  local pointLists = {}

  local rows = tileString:gmatch("[^\n]+")
  for row in rows do
    columnIndex = 1

    -- Create a table for each row
    tileTable[rowIndex] = {}
    walkTable[rowIndex] = {}

    for character in row:gmatch(".") do
      -- Keep track of our different characters and their position
      if pointLists[character] == nil then
        pointLists[character] = {}
      end
      local point = Point:new(columnIndex, rowIndex)
      insert(pointLists[character], point)

      -- Fill in the walk table for this map. Only certain things can be walked on
      if character == " " or character == "d" or character == "x" then
        walkTable[rowIndex][columnIndex] = 0
      else
        walkTable[rowIndex][columnIndex] = 1
      end

      -- Keep track of our actual tileMap
      -- tileTable[rowIndex][columnIndex] = {}
      tileTable[rowIndex][columnIndex] = character
      columnIndex = columnIndex + 1
    end
    rowIndex=rowIndex+1
  end

  return tileTable, walkTable, pointLists
end

return Map