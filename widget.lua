local widget = {}
widget.__index = widget

widget.colors = {
    released = {text={0,0,0,1}, fill={0.9,0.9,0.9,1}, stroke={0.5,0.5,0.5,1}},
    pressed = {text={0,0,0,1}, fill={0.7,0.7,0.7,1}, stroke={1,1,1,1}},
    hovered = {text={0,0,0,1}, fill={0.8,0.8,1,1}, stroke={1,1,1,1}},
    focused = {text={0,0,0,1}, fill={0.9,0.9,0.9,1}, stroke={0.5,0.5,0.5,1}},
}

widget.padding = {x=8, y=8}
widget.radius = {x=5, y=5}
widget.focused = false
widget.color = widget.colors.released
widget.pressed = false
widget.clock = 0

function widget.init(self, app) 
    self.application = app
    if app and app.addWidget then
        app:addWidget(self)
    end
end

function widget.update(self,dt)
  self.clock = self.clock + dt
end

function widget.hit(self, x, y)
  return x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height
end

function widget.getClientSize(self)
  return {x = self.width - self.padding.x * 2, y = self.height - self.padding.y * 2}
end

function widget.onClick(self)
  -- empty click handler
end

function widget.mousePressed(self, x, y, button, isTouch)
  if self:hit(x,y) then 
    self.color = self.colors.pressed
    self.pressed = true
  end
end

function widget.mouseReleased(self, x, y, button, isTouch)
  
  if self:hit(x,y) and self.pressed then
    self.focused = true
    self.color = self.colors.focused
  else
    self.focused = false
    self.color = self.colors.released
  end
  self.pressed = false
end

function widget.textInput(self, text)
  -- empty function for widgets that do not receive text.
end

function widget.drawAfter(self)
  -- empty function for widgets that do not have foreground graphics  
end

return widget
