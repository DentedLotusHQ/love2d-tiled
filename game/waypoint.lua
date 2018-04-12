local Waypoint = class("Waypoint")

local Grid = require ("lib.jumper.grid") -- The grid class
local Pathfinder = require ("lib.jumper.pathfinder") -- The pathfinder class

local Point = require("game.point")

function Waypoint:initialize()
  self._waypoints = {}
  self._path = {}
end

function Waypoint:setWalkTable(walkTable, walkable)
  self._walkTable = walkTable
  self._walkable = walkable

  self._grid = Grid(self._walkTable)
  self._pathFinder = Pathfinder(self._grid, 'ASTAR', self._walkable)
  self._pathFinder:setMode('ORTHOGONAL')
end

function Waypoint:insertWaypoint(point, index)
  table.insert(self._waypoints, index, point)
end

function Waypoint:addWaypoint(point)
  table.insert(self._waypoints, point)
end

function Waypoint:path()
  return ipairs(self._path)
end

function Waypoint:length()
  return #self._path
end

function Waypoint:calculate()
  local start = table.remove(self._waypoints)
  local finish = table.remove(self._waypoints)

  while finish ~= nil do
    local path = self._pathFinder:getPath(start.x, start.y, finish.x, finish.y)
    for node, count in path:nodes() do
      local point = Point:new(node:getX(), node:getY())
      table.insert(self._path, point)
    end
    start = finish
    finish = table.remove(self._waypoints)
  end
end

function Waypoint:waypoints()
  return self._waypoints
end

return Waypoint