-- Screen stuff
local push = require("lib.push")
local log = require("lib.log")

updatables = require("game.entities.update_list"):new()
drawables = require("game.entities.drawable_list"):new()

-- There are now local to this file
local Tilemap = require("game.entities.tilemap")
local Goblin = require("game.entities.goblin")
local Vector2 = require("game.point")
local input = require("game.managers.input"):new()
-- local Camera = require("game.entities.camera")
local Camera = require("lib.hump.camera")
local camera = Camera:new()
camera:zoom(0.5)
camera:lookAt(love.graphics.getWidth(),love.graphics.getHeight())
local Hud = require("game.ui.hud")

GameWorld = nil

function love.load()
  local setup = require("game.utilities.screen")
  setup()

  local parseConfig = require("config")
  local config = parseConfig()

  GameWorld = Tilemap:new(Goblin, "goblins")
  GameWorld:load(config, camera)

  local hud = Hud:new(push:getWidth(), push:getHeight(), love.graphics)
end

function love.update(dt)
  -- camera:checkInputs(dt)
  -- local x, y = camera:position()
  -- camera:lookAt(x - 1, y - 1)
  local x, y = camera:position()
  if love.keyboard.isDown("up") then
    y = y - 10
  end

  if love.keyboard.isDown("down") then
    y = y + 10
  end

  if love.keyboard.isDown("left") then
    x = x - 10
  end

  if love.keyboard.isDown("right") then
    x = x + 10
  end

  camera:lookAt(x, y)

  updatables:update(dt)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()

  -- camera:set()

  -- camera:moveCamera()
  push:start()
  -- GameWorld:draw()

  -- camera:attach()
  drawables:draw()
  -- camera:detach()

  push:finish()
  -- camera:unset()
end

function love.wheelmoved(x, y)
  input._scrollDelta = y
end
