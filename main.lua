-- Screen stuff
local push = require("lib.push")
local log = require("lib.log")

updatables = require("game.entities.update_list"):new()
drawables = require("game.entities.drawable_list"):new()

-- There are now local to this file
local Point = require("game.point")
local Goblin = require("game.entities.goblin")
local Map = require("game.entities.map")
local Tilemap = require("game.entities.tilemap")

local Vector2 = require("game.point")
local Camera = require("game.entities.camera")
local camera = Camera:new()
local Hud = require("game.ui.hud")

Being = nil

GameWorld = nil

function love.load()
  local setup = require("game.utilities.screen")
  setup()

  local parseConfig = require("config")
  local config = parseConfig()

  GameWorld = Tilemap:new()
  GameWorld:load(config.world)
  local goblinPoints = GameWorld:getPoints("spawn")
  for _, point in ipairs(goblinPoints) do
    Being = Goblin:new(config.goblins, point, GameWorld)
  end

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
  camera:moveCamera()
  push:start()
  drawables:draw()
  push:finish()
end
