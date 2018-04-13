class = require("lib.middleclass") -- make class Global for everything

-- Screen stuff
local push = require("lib.push")
local gameWidth = 800
local gameHeight = 600

local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowHeight = windowHeight*0.7
windowWidth = windowWidth*0.7--make the window a bit smaller than the screen itself

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

-- There are now local to this file
local Waypoint = require("game.waypoint")
local Point = require("game.point")
local Goblin = require("game.entities.goblin")
local Map = require("game.entities.map")

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

  local start = nil
  local waypoint = Waypoint:new()

  GameWorld = Map:new(Tileset, quadInfo, mapString, TileW, TileH)
  local goblinPoints = GameWorld:getPoints("spawn")

  for _, point in ipairs(goblinPoints) do
    Being = Goblin:new(Tileset, quad, Speed, point, GameWorld, TileW, TileH)
  end

end

function love.update(dt)
  Being:move(dt)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  push:start()
  GameWorld:draw(love.graphics)
  Being:draw(love.graphics)
  push:finish()
end
