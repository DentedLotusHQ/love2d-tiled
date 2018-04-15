local class = require("lib.middleclass")
local Stack = require("game.utilities.stack")
local TargetList = class("TargetList", Stack)

function TargetList:initialize()
  Stack:initialize()
end

function TargetList:getNearest(position)
  return pop()
end

function TargetList:getBest()
  return pop()
end

return TargetList