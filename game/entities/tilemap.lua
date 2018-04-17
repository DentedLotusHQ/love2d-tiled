local class = require("lib.middleclass")
local sti = require("lib.sti")
local Dynamic = require("game.maps.dynamic")
local Point = require("game.point")

local Tilemap = class("Tilemap")

function Tilemap:initialize(being_class, config_key)
  self.being_class = being_class
  self.config_key = config_key
  updatables:add(self, "map")
  drawables:add(self, "map")
end

function Tilemap:load(config)
  local mapLocator = config.world.map
  local dynamic = Dynamic:new(config.world.map)
  -- randomize the ground layer of the map
  dynamic:randomize("ground")
  love.physics.setMeter(16)
  self.map = sti(dynamic:getMap(), {"box2d"})
  self.width = self.map.width
  self.tilewidth = self.map.tilewidth
  self.height = self.map.height
  self.tileheight = self.map.tileheight
  world = love.physics.newWorld(0, 0)
  self.map:box2d_init(world)
  self.entities = {}
  local walls = self.map.layers["walls"]
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

  -- get our spawn location
  local spawn = self.map.layers["spawn"]
  self.entities["spawn"] = {}
  local spawnPoint = nil
  if spawn ~= nil then
    for y, xTable in pairs(spawn.data) do
      for x, _ in pairs(xTable) do
        spawnPoint = Point:new(x, y)
        break
      end
    end
  end

  local food = self.map.layers["food"]
  self.entities["food"] = {}

  if food ~= nil then
    for y, xTable in pairs(food.data) do
      for x, _ in pairs(xTable) do
        local point = Point:new(x, y)
        table.insert(self.entities["food"], point)
      end
    end
  end

  self.walkTable = walkTable

  if spawnPoint ~= nil then
    self.map:addCustomLayer("Beings", 5)
    local beingLayer = self.map.layers["Beings"]
    beingLayer.beings = {}
    local being = self.being_class:new(config[self.config_key], spawnPoint, self)
    table.insert(beingLayer.beings, being)

    function beingLayer:update(dt)
      for _, being in ipairs(self.beings) do
        being:update(dt)
      end
    end

    function beingLayer:draw()
      for _, being in ipairs(self.beings) do
        being:draw()
      end
    end
  end
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
  -- self.map:draw(1, 1, 0.45, 0.45)
end

return Tilemap
