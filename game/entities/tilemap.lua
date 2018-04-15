local Map = require("game.entities.map")
local class = require("lib.middleclass")
local Tilemap = class("Tilemap", Map)
local sti = require("lib.sti")

function Tilemap:load(mapLocator)
  windowWidth = love.graphics.getWidth()
  windowHeight = love.graphics.getHeight()
  love.physics.setMeter(16)
  map = sti(mapLocator, { "box2d" })
  world = love.physics.newWorld(0, 0)
  map:box2d_init(world)
end

function Tilemap:update(dt)
  map:update(dt)
end

function Tilemap:draw()
  -- Draw the map and all objects within
  love.graphics.setColor(255, 255, 255)
  map:draw()

  -- Draw Collision Map (useful for debugging)
  love.graphics.setColor(255, 0, 0)
  map:box2d_draw()
end

return Tilemap