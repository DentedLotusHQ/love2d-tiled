local class = require("lib.middleclass")
local Stack = class("Stack")

function Stack:initialize()
  self._stack = {}
end

function Stack:push(obj)
  if obj == nil then
    return
  end
  table.insert(self._stack, obj)
end

function Stack:pop()
  return table.remove(self._stack,#self._stack)
end

function Stack:size()
  return #self._stack
end

return Stack