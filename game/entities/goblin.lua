local class = require("lib.middleclass")

local Goblin = class("Goblin")

local Grid = require ("lib.jumper.grid")
local Pathfinder = require ("lib.jumper.pathfinder")
local Point = require("game.point")

function Goblin:initialize(config, start, map, graphics)
  self.tileset = love.graphics.newImage(config.tileset)
  local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()
  self.tileW = config.tileWidth
  self.tileH = config.tileHeight
  self.quad = love.graphics.newQuad(self.tileW, self.tileH * 20, self.tileH, self.tileH, tilesetW, tilesetH)
  self.speed = config.speed
  self.position = Point:new(start.x, start.y)
  self.map = map
  self.waypoints = self.map:getPoints("waypoint")

  self._waypointIndex = 1
  self.path = {}
  self.next = nil

  local walkTable = self.map.walkTable
  local walkable = 0
  self._grid = Grid(walkTable)
  self._pathFinder = Pathfinder(self._grid, 'ASTAR', walkable)
  self._pathFinder:setMode('ORTHOGONAL')
  self.graphics = graphics
  updatables:add(self, 'player')
  drawables:add(self, 'player')
end

function Goblin:update(dt)
  self:move(dt)
end

function Goblin:move(dt)
  -- if next is nil, then we need to compute a new path
  if self.next == nil then
    -- get our next waypoint
    local waypoint = self.waypoints[self._waypointIndex]
    local finish = Point:new(waypoint.x, waypoint.y)

    -- increment the index into the waypoints table.
    -- if it's too large, then set it back to the beginning
    -- We'll just loop all the waypoints over and over again
    self._waypointIndex = self._waypointIndex + 1
    if self._waypointIndex > #self.waypoints then
      self._waypointIndex = 1
    end

    local start_x = math.floor(self.position.x + 0.5)
    local start_y = math.floor(self.position.y + 0.5)

    local path = self._pathFinder:getPath(start_x, start_y, finish.x, finish.y)

    -- assumes path is not nil
    -- Have to change this assumption and handle it
    self.path = {}
    for node, count in path:nodes() do
      local point = Point:new(node:getX(), node:getY())
      -- insert the next point into our path
      table.insert(self.path, count, point)
    end

    self.next = table.remove(self.path, 1)
  end

  local dx = self.next.x - self.position.x
  local dy = self.next.y - self.position.y

  local x = self.position.x + dx * self.speed * dt
  local y = self.position.y + dy * self.speed * dt
  self.position = Point:new(x, y)

  if math.floor(dx + 0.5) == 0 and math.floor(dy + 0.5) == 0 and self.next ~= nil then
    self.next = table.remove(self.path, 1)
  end

  -- if math.abs(dx) < 0.01 and math.abs(dy) < 0.01 and self.next == nil then
  --   self.idle = true
  -- end
end

function Goblin:draw()  
  self.graphics.draw(self.tileset, self.quad, math.floor((self.position.x - 1) + 0.5) * self.tileW, math.floor((self.position.y - 1 ) + 0.5) * self.tileH)
end

return Goblin