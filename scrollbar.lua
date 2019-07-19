local pretty = require("pl.pretty")

local scrollBar = {}
scrollBar.__index = scrollBar

function scrollBar.new(widget)
  local self = {}
  setmetatable(self, scrollBar)
  scrollBar.init(self, widget) 
  return self
end

function scrollBar.init(self, widget, callBack)
    self.widget = widget
    self.callBack = callBack
    self.width = 10
    self.pos = 0
    self.bar =  {x=self.widget.x + self.widget.width - self.width, y=self.widget.y, width=self.width, height=self.widget.height}
    self.minHandle = self.width
    pretty.dump(self.widget:getContentRect())
    local handleHeight = self.widget.height * self.widget.height / self.widget:getContentRect().height 
    handleHeight = math.max(handleHeight, self.minHandle)
    handleHeight = math.min(self.bar.height, handleHeight)
    self.handle =  {x=self.widget.x + self.widget.width - self.width, y=self.widget.y, width=self.width, height=handleHeight}
    return self
end

function scrollBar.draw(self)
  
  --love.graphics.setColor(self.color.fill)
  --love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.radius.x, self.radius.y)
  
  love.graphics.setColor(self.widget.color.stroke)
  love.graphics.rectangle("line", self.widget.x + self.widget.width - self.width, self.widget.y, self.width, self.widget.height, self.widget.radius.x, self.widget.radius.y)
  
  love.graphics.setColor(self.widget.color.fill)
  love.graphics.rectangle("fill", self.widget.x + self.widget.width - self.width, self.widget.y, self.width, self.widget.height, self.widget.radius.x, self.widget.radius.y)
  
  love.graphics.setColor(self.widget.color.stroke)
  love.graphics.rectangle("fill", self.handle.x, self.handle.y, self.handle.width, self.handle.height, self.widget.radius.x, self.widget.radius.y)
  
end


function scrollBar.mousePressed(self, x, y, button, isTouch)
  if self:hit(x,y) then 
    self.color = self.colors.pressed
    self.pressed = true
  end
end

function scrollBar.mouseReleased(self, x, y, button, isTouch)
  
  if self:hit(x,y) and self.pressed then
    self.focused = true
    self.open = not self.open
    self.color = self.colors.focused
  else
    self.focused = false
    self.color = self.colors.released
    self.open = false
  end
  
end

return scrollBar
