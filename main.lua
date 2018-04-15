class = require("lib.middleclass") -- make class Global for everything

-- Screen stuff
local push = require("lib.push")
local log = require("lib.log")
local gameWidth = 1440
local gameHeight = 900

local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowHeight = windowHeight*0.7
windowWidth = windowWidth*0.7--make the window a bit smaller than the screen itself

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true})

-- There are now local to this file
updatables = require("game.entities.update_list"):new()
drawables = require("game.entities.drawable_list"):new()
local Point = require("game.point")
local Goblin = require("game.entities.goblin")
local Map = require("game.entities.map")
local Tilemap = require("game.entities.tilemap")

Tileset = nil
TileW, TileH = 16, 16

Being = nil
Speed = 7.5

GameWorld = nil

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  Tileset = love.graphics.newImage("assets/images/gameboy-fantasy.png");

  local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()

  local getQuadInfo = require("game.maps.quad_info")
  local quadInfo = getQuadInfo(TileW, TileH)
  local mapString = require("game.maps.obey")

  local quad = love.graphics.newQuad(TileW, TileH * 20, TileW, TileH, tilesetW, tilesetH)

  GameWorld = Tilemap:new(Tileset, quadInfo, mapString, TileW, TileH, love.graphics)
  GameWorld:load("game/maps/test-map.lua")--Map:new(Tileset, quadInfo, mapString, TileW, TileH, love.graphics)
  local goblinPoints = GameWorld:getPoints("spawn")

  for _, point in ipairs(goblinPoints) do
    Being = Goblin:new(Tileset, quad, Speed, point, GameWorld, TileW, TileH, love.graphics)
  end

end

function love.update(dt)
  updatables:update(dt)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  push:start()
  drawables:draw()
  push:finish()
end
