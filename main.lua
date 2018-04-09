Tileset = nil
TileW, TileH = 16,16

TileTable = nil

function love.load()
  Tileset = love.graphics.newImage("resources/gameboy-fantasy.png");

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
    { '*', TileW * 9, TileH * 8  }, -- castle
    { '^', TileW * 8, TileH }  -- spikes
  }

  Quads = {}
  for _,info in ipairs(quadInfo) do
    -- info[1] = character, info[2]= x, info[3] = y
    Quads[info[1]] = love.graphics.newQuad(info[2], info[3], TileW, TileH, tilesetW, tilesetH)
  end

  local tileString = [[
l-----------------------r
w                    *  v
w  *                    v
w              *        v
w                       v
w    ##  ###  ### # #   v
w   #  # #  # #   # #   v
w   #  # # *# #   # #   v
w   #  # ###  ### # #   v
w   #  # #  # #    #  * v
w * #  # #  # #    #    v
w   #  # #* # #  * #    v
w    ##  ###  ###  #    v
w                       v
w   *****************   v
w                       v
w  *                  * v
b----------d------------i
]]

  TileTable = {}

  local width = #(tileString:match("[^\n]+"))

  for x = 1,width,1 do TileTable[x] = {} end  

  local rowIndex,columnIndex = 1,1
  for row in tileString:gmatch("[^\n]+") do
    assert(#row == width, 'Map is not aligned: width of row ' .. tostring(rowIndex) .. ' should be ' .. tostring(width) .. ', but it is ' .. tostring(#row))
    columnIndex = 1
    print(rowIndex .. " " .. row)
    for character in row:gmatch(".") do
      TileTable[columnIndex][rowIndex] = character
      columnIndex = columnIndex + 1
    end
    rowIndex=rowIndex+1
  end
end

function love.draw()
  for columnIndex,column in ipairs(TileTable) do
    for rowIndex,char in ipairs(column) do
      local x,y = (columnIndex-1)*TileW, (rowIndex-1)*TileH
      love.graphics.draw(Tileset, Quads[char], x, y)
    end
  end
end
