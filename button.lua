local widget = require("widget")
local button = {}
button.__index = button
setmetatable(button, widget)

function button.new(app, x, y, label)
  local self = {}
  setmetatable(self, button)
  button.init(self, app, x, y, label)
  return self
end

function button.init(self, app, x, y, label)
  widget.init(self, app)
  self.width = 150
  self.height = 30
  self.x = x 
  self.y = y
  self.text = label
  self.textPos = "center"
end

function button.draw(self)
  
  love.graphics.setColor(self.color.fill)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.radius.x,self.radius.y)
  
  love.graphics.setColor(self.color.stroke)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.radius.x,self.radius.y)
  
  love.graphics.setColor(self.color.text)
  love.graphics.printf(self.text, self.x,self.y, self.width - self.padding.x * 2, self.textPos, 0, self.height / 30, self.height / 30, self.padding.x *-1, self.padding.y * -1)


end

function button.keyPressed(self, key)
  if self.focused then
    self.text = self.text .. key
  end
end

return button
