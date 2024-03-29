local pretty = require("pl.pretty")

local button = require("button")
local widget = require("widget")
local scrollBar = require("scrollbar")
local listBox = {}
listBox.__index = listBox
setmetatable(listBox, widget)

function listBox.new(app, x, y, width, height, content)
    local self = {}
    setmetatable(self, listBox)
    listBox.init(self, app, x, y, width, height, content)
    return self
end

function listBox.init(self, app, x, y, width, height, content)
    widget.init(self, app)
    self.width = width
    self.height = height
    self.x = x 
    self.y = y
    self.radius = {x=2, y=2}
    self.content = content
    self.buttons ={}
    self.buttonHeight = 30 

    self.colors = {
        released = {text={0,0,0,1}, fill= {1,1,1,1}, stroke = {0.5,0.5,0.5,1}},
        pressed = {text={0,0,0,1}, fill= {1,1,1,1}, stroke={0.5,0.5,0.5,1}},
        hovered = {text={0,0,0,1}, fill= {1,1,1,1}, stroke={0.5,0.5,0.5,1}},
        focused = {text={0,0,0,1}, fill= {1,1,1,1}, stroke = {0.5,0.5,1,1}},   
    }

    for k,v in ipairs(content) do
        local bt = button.new(self, self.x, self.y + (self.buttonHeight * (k - 1)), v)
        bt.colors =  {
            released = {text={0,0,0,1}, fill= {1,1,1,1}, stroke = {1,1,1,1}},
            pressed = {text={1,0,0,1}, fill= {0.5,0.5,0.5,1}, stroke={0.5,0.5,0.5,1}},
            hovered = {text={0,0,0,1}, fill= {1,1,1,1}, stroke = {1,1,1,1}},
            focused = {text={1,1,1,1}, fill= {0,0,1,1}, stroke = {0,0,1,1}},   
        }
        bt.color = bt.colors.released
        bt.radius = {x = 0, y = 0}
        bt.width = self.width
        bt.height = self.buttonHeight
        bt.textPos = "left"
        table.insert(self.buttons, bt)
    end
    self.contentRect = {x=self.x, y=self.y, width = self.width, height = #self.buttons * self.buttonHeight}
    self.scrollBar = scrollBar.new(self)
end

function listBox.draw(self)

    local currentColor = self:getColor()

    love.graphics.setColor(currentColor.fill)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.radius.x, self.radius.y)

    love.graphics.setScissor(self.x, self.y, self.width, self.height)
    for k,v in ipairs(self.buttons) do
        v:draw()
    end
    love.graphics.setScissor()

    self.scrollBar:draw()
    love.graphics.setColor(currentColor.stroke)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.radius.x, self.radius.y)

end

function listBox.keyPressed(self, handled, key)
    if self.focused then
    end
end

function listBox.mousePressed(self, handled, x, y, button, isTouch)
    if self:hit(x,y) then 
        handled = handled or self.scrollBar:mousePressed(handled, x, y, button, isTouch)
        self.pressed = true
        if not handled then
            for k,v in ipairs(self.buttons) do
                handled = handled or v:mousePressed(handled, x,y,button,isTouch)
            end
        end
    else
        self.pressed = false
        self.focused = false
    end
    return handled
end

function listBox.mouseReleased(self, handled, x, y, button, isTouch)
    
    handled = handled or self.scrollBar:mouseReleased(handled, x, y, button, isTouch)

    if self:hit(x,y) and self.pressed then
        self.focused = true
    else
        self.focused = false
    end

    if self:hit(x,y) then
        if not handled then
            for k,v in ipairs(self.buttons) do
                handled = handled or v:mouseReleased(handled, x,y,button,isTouch)
            end
        end
    end
    self.pressed = false
    return handled
end

function listBox.getContentRect(self)
    return {
        x = self.contentRect.x,
        y = self.contentRect.y,
        width = self.contentRect.width,
        height = self.contentRect.height
    }
end

function listBox.setContentPosition(self, position)
    self.contentPosition = {x=position.x, y=position.y}

    for pos,button in pairs(self.buttons) do
        button.x = self.contentPosition.x
        button.y = self.contentPosition.y + self.buttonHeight * (pos - 1)
    end
end

function listBox.update(self, dt)
    self.scrollBar:update(dt)
end

return listBox
