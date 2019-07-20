local widget = require("widget")
local selectBox = {}
selectBox.__index = selectBox
setmetatable(selectBox, widget)

function selectBox.new(app, x, y, content, drop)
  local self = {}
  setmetatable(self, selectBox)
  selectBox.init(self, app, x, y, content, drop) 
  return self
end

function selectBox.init(self, app, x, y, content, drop)
  self.width = 150
  self.height = 30
  self.x = x 
  self.y = y
  self.text = content[1]
  self.drop = "down" -- use "down" or "up"
  self.open = false
  
  
  self.dropWidth = 200
  self.dropHeight = 200
  if drop == nil then 
    self.drop = "down"
  else
    self.drop = drop
  end
  
  if self.drop == "down" then
    self.dropY = self.y + self.height
    self.dropX = self.x
  else
    self.dropY = self.y - self.dropHeight
    self.dropX = self.x
  end
  
  widget.init(self, app)
  return self
end

function selectBox.draw(self)
  
  local currentColor = self:getColor()

  local bw = 30 -- the width of the button on the right of the combo.
  
  love.graphics.setColor(currentColor.fill)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.radius.x, self.radius.y)
  
  love.graphics.setColor(currentColor.stroke)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.radius.x, self.radius.y)
  
  love.graphics.setColor(currentColor.stroke)
  love.graphics.rectangle("line", self.x + self.width - bw, self.y, bw, self.height, self.radius.x, self.radius.y)
  
  if self.drop == "down" then
    love.graphics.polygon( "fill", self.x + self.width - bw/2, self.y + self.height/3*2, self.x + self.width - bw/3*2, self.y + self.height/3, self.x + self.width - bw/3, self.y + self.height/3 )
  else
    love.graphics.polygon( "fill", self.x + self.width - bw/2, self.y + self.height/3, self.x + self.width - bw/3*2, self.y + self.height/3*2, self.x + self.width - bw/3, self.y + self.height/3*2 )
  end
  
  love.graphics.setColor(currentColor.text)
  love.graphics.printf(self.text, self.x, self.y, self.width - self.padding.x * 2 - bw, "center", 0, self.height / 30, self.height / 30, self.padding.x *-1, self.padding.y * -1)

end

function selectBox.drawAfter(self)
  
  local currentColor = self:getColor()

  if self.open then
    love.graphics.setColor(currentColor.fill)
    love.graphics.rectangle("fill", self.dropX, self.dropY, self.dropWidth, self.dropHeight, self.radius.x, self.radius.y)
    love.graphics.setColor(currentColor.stroke)
    love.graphics.rectangle("line", self.dropX, self.dropY, self.dropWidth, self.dropHeight, self.radius.x, self.radius.y)
  end
end

function selectBox.keyPressed(self, handled, key)
  if self.focused then
    self.text = self.text .. key
  end
end

function selectBox.mousePressed(self, handled, x, y, button, isTouch)
  if self:hit(x,y) then 
    self.color = self.colors.pressed
    self.pressed = true
  end
end

function selectBox.mouseReleased(self, handled, x, y, button, isTouch)
  
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

return selectBox
