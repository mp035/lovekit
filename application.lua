local application = {}
application.__index = application


function application.new()
  local self = {widgets = {}}
  self.color = {text={1,1,1,1}, fill= {0.8,0.8,0.8,1}, stroke = {1,1,1,1}},
  setmetatable(self, application)
  love.keyboard.setTextInput( true )
  love.keyboard.setKeyRepeat( true )
  return self
end

function application.draw(self)
  local width, height = love.graphics.getDimensions( )
  love.graphics.setColor(self.color.fill)
  love.graphics.rectangle("fill", 0, 0, width, height, 0,0)
  for k,v in pairs(self.widgets) do
    v:draw()
  end
  for k,v in pairs(self.widgets) do
    v:drawAfter()
  end
end

function application.addWidget(self, widget)
  table.insert(self.widgets, widget)
end

function application.update(self, dt)
  for k,v in pairs(self.widgets) do
    v:update(dt)
  end
end

function application.mouseReleased(self, x, y, button, isTouch)
  local handled = false
  for k,v in pairs(self.widgets) do
    handled = v:mouseReleased(handled, x, y, button, isTouch) or handled
  end
end

function application.mousePressed(self, x, y, button, isTouch)
  local handled = false
  for k,v in pairs(self.widgets) do
    handled = v:mousePressed(handled, x, y, button, isTouch) or handled
  end
end

function application.keyPressed(self, key, code, isRepeat)
  local handled = false
  for k,v in pairs(self.widgets) do
    handled = v:keyPressed(handled, key, code, isRepeat) or handled
  end
end

function application.textInput(self, key)
  local handled = false
  for k,v in pairs(self.widgets) do
    handled = v:textInput(handled, key) or handled
  end
end

return application
