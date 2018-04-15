-- Screen stuff
local push = require("lib.push")
local log = require("lib.log")

updatables = require("game.entities.update_list"):new()
drawables = require("game.entities.drawable_list"):new()

-- There are now local to this file
local Tilemap = require("game.entities.tilemap")
local Goblin = require("game.entities.goblin")
local Vector2 = require("game.point")
local Camera = require("game.entities.camera")
local input = require("game.managers.input"):new()
local Hud = require("game.ui.hud")

GameWorld = nil

function love.load()
  local setup = require("game.utilities.screen")
  setup()

  local parseConfig = require("config")
  local config = parseConfig()

  GameWorld = Tilemap:new(Goblin, "goblins")
  GameWorld:load(config)

  camera = require("game.entities.camera"):new(input, GameWorld)
  local hud = Hud:new(push:getWidth(), push:getHeight(), love.graphics)
end

function love.update(dt)
  camera:checkInputs(dt)
  updatables:update(dt)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  camera:set()
  push:start()
  drawables:draw()
  push:finish()
  camera:unset()
end

function love.wheelmoved(x, y)
  input._scrollDelta = y
end
