local pretty = require("pl.pretty")
local widget = require("widget")

local scrollBar = {}
scrollBar.__index = scrollBar

function scrollBar.new(widget)
  local self = {}
  setmetatable(self, scrollBar)
  scrollBar.init(self, widget) 
  return self
end

function scrollBar.calculateHandle(self)
    local handleHeight = self.widget.height * self.widget.height / self.widget:getContentRect().height 
    handleHeight = math.max(handleHeight, self.minHandle)
    handleHeight = math.min(self.bar.height, handleHeight)
    self.handle.width=self.width; 
    self.handle.height=handleHeight;
end

function scrollBar.init(self, widget, callBack)
    self.widget = widget
    self.callBack = callBack
    self.width = 10
    self.pos = 0
    self.bar =  {x=self.widget.x + self.widget.width - self.width, y=self.widget.y, width=self.width, height=self.widget.height}
    self.minHandle = self.width
    self.handle =  {x=self.widget.x + self.widget.width - self.width, y=self.widget.y, width=self.width, height=handleHeight}
    self:calculateHandle()
    self.diffX = 0
    self.diffY = 0
    self.dragging = false
    return self
end

function scrollBar.draw(self)
  
  self:calculateHandle()

  --love.graphics.setColor(self.color.fill)
  --love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.radius.x, self.radius.y)
  local currentColor = self.widget:getColor()
  
  love.graphics.setColor(currentColor.stroke)
  love.graphics.rectangle("line", self.widget.x + self.widget.width - self.width, self.widget.y, self.width, self.widget.height, self.widget.radius.x, self.widget.radius.y)
  
  love.graphics.setColor(currentColor.fill)
  love.graphics.rectangle("fill", self.widget.x + self.widget.width - self.width, self.widget.y, self.width, self.widget.height, self.widget.radius.x, self.widget.radius.y)
  
  love.graphics.setColor(currentColor.stroke)
  love.graphics.rectangle("fill", self.handle.x, self.handle.y, self.handle.width, self.handle.height, self.widget.radius.x, self.widget.radius.y)
  
end

function scrollBar.hit(self, x, y)
  return x >= self.handle.x and x < self.handle.x + self.handle.width and y >= self.handle.y and y < self.handle.y + self.handle.height
end

function scrollBar.mousePressed(self, handled, x, y, button, isTouch)
  if self:hit(x,y) then 
    --self.color = self.colors.pressed
    self.dragging = true
    self.diffX = x - self.handle.x
    self.diffY = y - self.handle.y
    return true
  end
end

function scrollBar.mouseReleased(self, handled, x, y, button, isTouch)
  
  if self:hit(x,y) and self.pressed then
    self.focused = true
    self.open = not self.open
    --self.color = self.colors.focused
    return true
  else
    self.focused = false
    --self.color = self.colors.released
    self.open = false
  end
  self.dragging = false
  
end

function scrollBar.update(self, dt)
  if self.dragging then
    --self.handle.x = love.mouse.getX() - self.diffX
    self.handle.y = love.mouse.getY() - self.diffY
    self.handle.y = math.max(self.handle.y, self.bar.y)
    self.handle.y = math.min(self.handle.y, self.bar.y+self.bar.height-self.handle.height)
    local contentPos = self.widget:getContentRect()
    local posPercent = 0
    if self.bar.height ~= self.handle.height then
        posPercent = (self.handle.y - self.bar.y) / (self.bar.height - self.handle.height) 
    end
    local ypos = self.widget.y
    if(contentPos.height > self.widget.height) then
        yPos = self.widget.y - (contentPos.height - self.widget.height) * posPercent
    end
    self.widget:setContentPosition({x=contentPos.x, y=yPos})
  end
end

return scrollBar
