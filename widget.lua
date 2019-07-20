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

function widget.getColor(self)
    
    local currentColor = self.colors.released
    if self.pressed then
        currentColor = self.colors.pressed
    elseif self.focused then
        currentColor = self.colors.focused
    end
    
    return currentColor

end

function widget.onClick(self)
  -- empty click handler
end

function widget.mousePressed(self, handled, x, y, button, isTouch)
  if self:hit(x,y) and not handled then 
    self.pressed = true
    return true
  end
end

function widget.mouseReleased(self, handled, x, y, button, isTouch)
  
  if self:hit(x,y) and self.pressed then
      if not handled then
        self.focused = true
        handled = true
      end
  else
    self.focused = false
  end
  self.pressed = false
  return handled
end

function widget.wheelMoved(self, x, y)
  -- empty function for widgets that do not respond to wheel movement. 
end

function widget.textInput(self, handled, text)
  -- empty function for widgets that do not receive text.
end

function widget.drawAfter(self)
  -- empty function for widgets that do not have foreground graphics  
end

return widget
