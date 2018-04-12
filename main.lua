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

TileTable = nil
WalkTable = nil

Being = nil

NextX = nil
NextY = nil

Done = false

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
    Being = Goblin:new(quad)
    start = point
    Being:moveTo(point)
  end

  local walkTable = GameWorld.walkTable

  local wayPoints = GameWorld:getPoints("waypoint")
  for _, point in ipairs(wayPoints) do
    waypoint:addWaypoint(point)
  end

  local walkable = 0
  waypoint:insertWaypoint(start, 1)
  waypoint:setWalkTable(walkTable, walkable)

  waypoint:calculate()

  Path = {}
  if waypoint:length() > 0 then
    for index,point in waypoint:path() do
      table.insert(Path, point)
    end
  end
  Next = table.remove(Path)
end

function love.update(dt)
  if done then
    return
  end

  if Next ~= nil then
    NextX = Next.x
    NextY = Next.y
  end

  local dx = NextX - Being.position.x
  local dy = NextY - Being.position.y

  local x = Being.position.x + dx * Speed * dt
  local y = Being.position.y + dy * Speed * dt
  local newPosition = Point:new(x, y)
  Being:moveTo(newPosition)

  if math.floor(dx + 0.5) == 0 and math.floor(dy + 0.5) == 0 and Next ~= nil then
    Next = table.remove(Path)
  end

  if math.abs(dx) < 0.01 and math.abs(dy) < 0.01 and Next == nil then
    done = true
  end

end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  push:start()
  GameWorld:draw(love.graphics)
  love.graphics.draw(Tileset, Being.quad, math.floor((Being.position.x - 1) + 0.5) * TileW, math.floor((Being.position.y - 1 ) + 0.5) * TileH)
  push:finish()
end
