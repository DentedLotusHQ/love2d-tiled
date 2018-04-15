local class = require("lib.middleclass")
local Entity = require("game.entities.base_classes.entity")
local Goblin = class("Goblin", Entity)

local Grid = require ("lib.jumper.grid")
local Pathfinder = require ("lib.jumper.pathfinder")
local Point = require("game.point")
local Stack = require("game.utilities.stack")

function Goblin:initialize(config, start, map)
  local size = config.tileWidth
  Entity:initialize(start, size)
  self._currentTasks = Stack:new()
  self.tileset = love.graphics.newImage(config.tileset)
  local tilesetW, tilesetH = self.tileset:getWidth(), self.tileset:getHeight()
  self.quad = love.graphics.newQuad(size, size * 20, size, size, tilesetW, tilesetH)
  self.movementSpeed = config.speed
  self.map = map
  self.waypoints = self.map:getPoints("food")
  self._waypointIndex = 1
  self.path = {}
  self.next = nil
  self:createWaypoints()
  local walkTable = self.map.walkTable
  local walkable = 0
  self._grid = Grid(walkTable)
  self._pathFinder = Pathfinder(self._grid, 'ASTAR', walkable)
  self._pathFinder:setMode('ORTHOGONAL')
end

function Goblin:addTask(task)
  self._currentTasks:push(task)
end

function Goblin:update(dt)
  self:move(dt)
end

function Goblin:createWaypoints()
  for i=1, #self.waypoints do
    self._currentTasks:push(self.waypoints[i])
  end
end

function Goblin:move(dt)
  -- if next is nil, then we need to compute a new path
  if self.next == nil then
    -- -- get our next waypoint
    -- local waypoint = self.waypoints[self._waypointIndex]
    -- local finish = Point:new(waypoint.x, waypoint.y)
    if self._currentTasks:size() == 0 then
      self:createWaypoints()
    end

    local finish = self._currentTasks:pop()

    -- increment the index into the waypoints table.
    -- if it's too large, then set it back to the beginning
    -- We'll just loop all the waypoints over and over again
    -- self._waypointIndex = self._waypointIndex + 1
    -- if self._waypointIndex > #self.waypoints then
    --   self._waypointIndex = 1
    -- end

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
  local x = self.position.x + dx * self.movementSpeed * dt
  local y = self.position.y + dy * self.movementSpeed * dt
  self.position = Point:new(x, y)

  if math.floor(dx + 0.5) == 0 and math.floor(dy + 0.5) == 0 and self.next ~= nil then
    self.next = table.remove(self.path, 1)
  end
end

function Goblin:draw()
  love.graphics.draw(self.tileset, self.quad, (self.position.x - 1) * self.size, (self.position.y - 1) * self.size)
end

return Goblin