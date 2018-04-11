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

Tileset = nil
TileW, TileH = 16, 16

TileTable = nil
WalkTable = nil

Being = nil

NextX = nil
NextY = nil

Done = false

Speed = 7.5

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  Tileset = love.graphics.newImage("assets/images/gameboy-fantasy.png");

  local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()

  local quadInfo = {
    { ' ', TileW * 2,  TileH * 5  }, -- grass 
    { '#', TileW * 8,  TileH * 8 }, -- bookshelf
    { '-', TileW, TileH * 2 }, -- side wall
    { 'l', 0, TileH * 2 }, -- left top corner
    { 'r', TileW * 2, TileH * 2 }, -- right top corner
    { 'b', 0, TileH * 4 }, -- bottom left corner
    { 'i', TileW * 2, TileH * 4 }, -- bottom right
    { 'w', 0, TileH * 3 }, -- left vertical
    { 'v', TileW * 2, TileH * 3 }, -- right vertical
    { 'd', TileW, TileH * 4 }, -- door
    { 's', TileW * 5, TileH * 2 }, -- start
    { 'x', TileW * 6, TileH * 2 }, -- waypoint
    { '*', TileW * 9, TileH * 8  }, -- castle
    { '^', TileW * 8, TileH }  -- spikes
  }

  Quads = {}
  for _,info in ipairs(quadInfo) do
    -- info[1] = character, info[2]= x, info[3] = y
    Quads[info[1]] = love.graphics.newQuad(info[2], info[3], TileW, TileH, tilesetW, tilesetH)
  end

  local quad = love.graphics.newQuad(TileW, TileH * 20, TileW, TileH, tilesetW, tilesetH)
  Being = Goblin:new(quad)

  local tileString = [[
l-----------------------r
w        x           *  v
w  *                    v
w              *        v
w                       v
w    ##  ###  ### # #   v
w   #  # #  # #   # #   v
w x #  # # *# #   # #   v
w   #  # ###  ### # #   v
w   #  # #  # #    #  * v
w * #  # #  # #    #    v
w   #  # #* # #  * # x  v
w    ##  ###  ###  #    v
w                       v
w   *****************   v
w           s           v
w  *              x   * v
b----------d------------i
]]

  TileTable = {}
  WalkTable = {}
  PrintTable = "{\n"

  local start = nil
  local waypoint = Waypoint:new()

  local rowIndex,columnIndex = 1,1
  for row in tileString:gmatch("[^\n]+") do
    columnIndex = 1

    -- Create a table for each row
    TileTable[rowIndex] = {}
    WalkTable[rowIndex] = {}
    PrintTable = PrintTable .. rowIndex .. "{ "

    for character in row:gmatch(".") do
      if character == " " or character == "s" or character == "x" then
        if character == "s" then
          start = Point:new(columnIndex, rowIndex)
          WalkTable[rowIndex][columnIndex] = 0
          PrintTable = PrintTable .. "s, "
        elseif character == "x" then
          local point = Point:new(columnIndex, rowIndex)
          waypoint:addWaypoint(point)
          WalkTable[rowIndex][columnIndex] = 0
          PrintTable = PrintTable .. "x, "
        else
          WalkTable[rowIndex][columnIndex] = 0
          PrintTable = PrintTable .. " , "
        end
      else
        WalkTable[rowIndex][columnIndex] = 1
        PrintTable = PrintTable .. character .. ", "
      end

      TileTable[rowIndex][columnIndex] = character
      columnIndex = columnIndex + 1
    end
    PrintTable = PrintTable .. " }\n"
    rowIndex=rowIndex+1
  end

  print(PrintTable)

  Being:moveTo(start)

  local walkable = 0
  waypoint:insertWaypoint(start, 1)
  waypoint:setWalkTable(WalkTable, walkable)

  waypoint:calculate()

  Path = {}
  if waypoint:length() > 0 then
    for index,point in waypoint:path() do
      table.insert(Path, point)
      print(('Step %d - x: %d - y: %d'):format(index, point.x, point.y))
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
  for rowIndex, row in ipairs(TileTable) do
    for columnIndex, char in ipairs(row) do
      local x,y = (columnIndex - 1) * TileW, (rowIndex - 1) * TileH
      love.graphics.draw(Tileset, Quads[char], x, y)
    end
  end
  love.graphics.draw(Tileset, Being.quad, math.floor((Being.position.x - 1) + 0.5) * TileW, math.floor((Being.position.y - 1 ) + 0.5) * TileH)
  push:finish()
end
