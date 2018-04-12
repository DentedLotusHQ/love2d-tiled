return function(tileW, tileH)
  local quadInfo = {
    { 'grass', ' ', tileW * 2,  tileH * 5  }, -- grass 
    { 'bookshelf', '#', tileW * 8,  tileH * 8 }, -- bookshelf
    { 'side-wall', '-', tileW, tileH * 2 }, -- side wall
    { 'top-left', 'l', 0, tileH * 2 }, -- left top corner
    { 'top-right', 'r', tileW * 2, tileH * 2 }, -- right top corner
    { 'bottom-left', 'b', 0, tileH * 4 }, -- bottom left corner
    { 'bottom-right', 'i', tileW * 2, tileH * 4 }, -- bottom right
    { 'left-vertical', 'w', 0, tileH * 3 }, -- left vertical
    { 'right-vertical', 'v', tileW * 2, tileH * 3 }, -- right vertical
    { 'spawn', 'd', tileW, tileH * 4 }, -- door
    { 'waypoint', 'x', tileW * 6, tileH * 2 }, -- waypoint
    { 'castle', '*', tileW * 9, tileH * 8  }, -- castle
    { 'spikes', '^', tileW * 8, tileH }  -- spikes
  }
  return quadInfo
end