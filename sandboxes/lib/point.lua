local class = require("lib.middleclass")

local Point = class("Point")

function Point:initialize(x, y)
  self.x = x
  self.y = y
end

return Point