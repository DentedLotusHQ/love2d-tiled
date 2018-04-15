local push = require("lib.push")

function setup()
  local windowWidth, windowHeight = love.window.getDesktopDimensions()
  windowHeight = windowHeight*0.7
  windowWidth = windowWidth*0.7--make the window a bit smaller than the screen itself

  local gameWidth = windowWidth * 0.9
  local gameHeight = windowHeight * 0.9

  push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false})

  love.graphics.setDefaultFilter('nearest', 'nearest')
end

return setup