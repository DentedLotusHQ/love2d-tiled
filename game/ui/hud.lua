local class = require("lib.middleclass")
local Hud = class("Hud")

catui = require("lib/catui")
local label = UIControl.label

function Hud:initialize(gameWidth, gameHeight, graphics)
  self.graphics = graphics
  self.text = "Something Stupid"
  self.labelBuffer = 10
  label = UILabel:new("assets/fonts/Roboto.ttf", self.text, 10)
  label:setAutoSize(true)
  self.labelX = ((gameWidth - label:measureWidth(self.text)) - self.labelBuffer)
  self.labelY = ((gameHeight - label:getFontSize()) - self.labelBuffer)
  drawables:add(self, "hud")
end

function Hud:update()
end

function Hud:draw()
  self.graphics.draw(label:getDrawable(), self.labelX, self.labelY)
end

return Hud
