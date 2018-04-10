Tileset = nil
TileW, TileH = 16, 16

TileTable = nil
WalkTable = nil

PlayerX = nil
PlayerY = nil
PlayerQuad = nil

NextX = nil
NextY = nil

Done = false

Speed = 5

function love.load()
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
    { 'f', TileW * 6, TileH * 2 }, -- finish
    { '*', TileW * 9, TileH * 8  }, -- castle
    { '^', TileW * 8, TileH }  -- spikes
  }

  print("before pairs")
  Quads = {}
  for _,info in ipairs(quadInfo) do
    -- info[1] = character, info[2]= x, info[3] = y
    Quads[info[1]] = love.graphics.newQuad(info[2], info[3], TileW, TileH, tilesetW, tilesetH)
  end

  PlayerQuad = love.graphics.newQuad(TileW, TileH * 20, TileW, TileH, tilesetW, tilesetH)

  print("after pairs")

  local tileString = [[
l-----------------------r
w                    *  v
w  *                    v
w              *        v
w                       v
w    ##  ###  ### # #   v
w   #  # #  # #   # #   v
w f #  # # *# #   # #   v
w   #  # ###  ### # #   v
w   #  # #  # #    #  * v
w * #  # #  # #    #    v
w   #  # #* # #  * #    v
w    ##  ###  ###  #    v
w                       v
w   *****************   v
w           s           v
w  *                  * v
b----------d------------i
]]

  TileTable = {}
  WalkTable = {}
  PrintTable = "{\n"

  local width = #(tileString:match("[^\n]+"))

  local startx, starty = 1,1
  local endx, endy = 5,1

  local rowIndex,columnIndex = 1,1
  for row in tileString:gmatch("[^\n]+") do
    columnIndex = 1

    -- Create a table for each row
    TileTable[rowIndex] = {}
    WalkTable[rowIndex] = {}
    PrintTable = PrintTable .. rowIndex .. "{ "

    for character in row:gmatch(".") do
      if character == " " or character == "s" or character == "f" then
        if character == "s" then
          startx = columnIndex
          PlayerX = columnIndex
          starty = rowIndex
          PlayerY = rowIndex
          WalkTable[rowIndex][columnIndex] = 0
          PrintTable = PrintTable .. "s, "
        elseif character == "f" then
          endx = columnIndex
          endy = rowIndex
          WalkTable[rowIndex][columnIndex] = 0
          PrintTable = PrintTable .. "f, "
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
  print(startx)
  print(starty)

  local Grid = require ("lib.jumper.grid") -- The grid class
  local Pathfinder = require ("lib.jumper.pathfinder") -- The pathfinder class

  local walkable = 0
  -- Creates a grid object
  local grid = Grid(WalkTable) 
  -- Creates a pathfinder object using Jump Point Search
  local myFinder = Pathfinder(grid, 'ASTAR', walkable)
  myFinder:setMode('ORTHOGONAL')
  local path = myFinder:getPath(startx, starty, endx, endy)

  Path = {}

  if path then
    print(('Path found! Length: %.2f'):format(path:getLength()))
    for node, count in path:nodes() do
      table.insert(Path, node)
      print(('Step: %d - x: %d - y: %d'):format(count, node:getX(), node:getY()))
    end
  end
  Next = table.remove(Path, 1)
end

function love.update(dt)
  if done then
    return
  end

  if Next ~= nil then
    NextX = Next:getX()
    NextY = Next:getY()
  end

  local dx = NextX - PlayerX
  local dy = NextY - PlayerY

  PlayerX = PlayerX + dx * Speed * dt
  PlayerY = PlayerY + dy * Speed * dt

  if math.abs(dx) < 0.4 and math.abs(dy) < 0.4 and Next ~= nil then
    Next = table.remove(Path, 1)
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
  for rowIndex, row in ipairs(TileTable) do
    for columnIndex, char in ipairs(row) do
      local x,y = (columnIndex - 1) * TileW, (rowIndex - 1) * TileH
      love.graphics.draw(Tileset, Quads[char], x, y)
    end
  end
  love.graphics.draw(Tileset, PlayerQuad, (PlayerX - 1) * TileW, (PlayerY - 1 ) * TileH)
end
