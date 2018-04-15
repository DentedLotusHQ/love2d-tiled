local Map = require("game.entities.map")
local class = require("lib.middleclass")
local Tilemap = class("Tilemap", Map)
local sti = require("lib.sti")

function Tilemap:load(mapLocator)
  windowWidth = love.graphics.getWidth()
  windowHeight = love.graphics.getHeight()
  
  love.physics.setMeter(16)
  self.map = sti(mapLocator, { "box2d" })
  self.width = self.map.width
  self.tilewidth = self.map.tilewidth
  self.height = self.map.height
  self.tileheight = self.map.tileheight
  world = love.physics.newWorld(0, 0)
  self.map:box2d_init(world)
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