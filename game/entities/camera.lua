local class = require("lib.middleclass")
local Camera = class("Camera")
local Vector2 = require("game.point")
local Input = require("game.managers.input")

function Camera:initialize()
  self.position = Vector2:new(0, 0)
  self.movementSpeed = 150
  self.scale = Vector2:new(1, 1)
  self.input = Input:new()
end

function Camera:checkInputs(dt)
  delta = self.input:getCameraMovement()
  self.position.x = self.position.x + (delta.x * dt * self.movementSpeed)
  self.position.y = self.position.y + (delta.y * dt * self.movementSpeed)

  scaleDelta = self.input.getCameraZoom()
end

function Camera:moveCamera()
  love.graphics.translate(self.position.x, self.position.y)
  love.graphics.scale(self.scale.x, self.scale.y)
end

return Camera