local Map = require("game.entities.map")
local class = require("lib.middleclass")
local Tilemap = class("Tilemap", Map)
local Point = require("game.point")
local sti = require("lib.sti")

function Tilemap:load(mapLocator)
  love.physics.setMeter(16)
  self.map = sti(mapLocator, { "box2d" })
  self.width = self.map.width
  self.tilewidth = self.map.tilewidth
  self.height = self.map.height
  self.tileheight = self.map.tileheight
  world = love.physics.newWorld(0, 0)
  map:box2d_init(world)
  self.entities = {}
  local walls = map.layers["walls"]
  local walkTable = {}

  if walls ~= nil then
    for y = 1, walls.height do
      walkTable[y] = {}
      for x = 1, walls.width do
        if walls.data[y][x] ~= nil then
          walkTable[y][x] = 1
        else
          walkTable[y][x] = 0
        end
      end
    end
  end

  local spawn = map.layers["spawn"]
  self.entities["spawn"] = {}
  if spawn ~= nil then
    for y,xTable in pairs(spawn.data) do
      for x, _ in pairs(xTable) do
        local point = Point:new(x, y)
        table.insert(self.entities["spawn"], point)
      end
    end
  end

  local food = map.layers["food"]
  self.entities["food"] = {}

  if food ~= nil then
    for y,xTable in pairs(food.data) do
      for x, _ in pairs(xTable) do
        local point = Point:new(x, y)
        table.insert(self.entities["food"], point)
      end
    end
  end

  self.walkTable = walkTable
end

function Tilemap:getPoints(entity)
  return self.entities[entity]
end

function Tilemap:update(dt)
  self.map:update(dt)
end

function Tilemap:draw()
  -- Draw the map and all objects within
  love.graphics.setColor(255, 255, 255)
  self.map:draw()

  -- Draw Collision Map (useful for debugging)
  love.graphics.setColor(255, 0, 0)
  self.map:box2d_draw()
  love.graphics.setColor(255, 255, 255)
end

return Tilemap