Goblin = class("Goblin")

function Goblin:initialize(quad)
  self.quad = quad
  self.position = nil
end

function Goblin:moveTo(point)
  self.position = point
end