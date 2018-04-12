local Goblin = class("Goblin")

local Grid = require ("lib.jumper.grid")
local Pathfinder = require ("lib.jumper.pathfinder")

local Waypoint = require("game.waypoint")

function Goblin:initialize(quad)
  self.quad = quad
  -- self.speed = speed
  -- self.position = start
end

function Goblin:moveTo(point)
  self.position = point
end

return Goblin