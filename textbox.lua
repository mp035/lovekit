local widget = require("widget")
local textBox = {}
textBox.__index = textBox
setmetatable(textBox, widget)

textBox.new = function(app, x, y, width, height, multiline)
    local self = {}
    setmetatable(self, textBox)
    textBox.init(self, app, x, y, width, height, multiline)
    return self
end

textBox.init = function(self, app, x, y, width, height, multiline)
    widget.init(self, app)
    self.width = width
    self.height = height
    self.x = x 
    self.y = y
    self.text = ""
    self.cursorPos = 0
    self.maxLen = 1024
    self.radius = {x=2, y=2}
    if multiline == nil then 
        self.multiLine = false
    else
        self.multiLine = multiline
    end

    self.colors = {
        released = {text={0,0,0,1}, fill= {1,1,1,1}, stroke = {0.5,0.5,0.5,1}},
        pressed = {text={0,0,0,1}, fill= {1,1,1,1}, stroke={0.5,0.5,0.5,1}},
        hovered = {text={0,0,0,1}, fill= {1,1,1,1}, stroke={0.5,0.5,0.5,1}},
        focused = {text={0,0,0,1}, fill= {1,1,1,1}, stroke = {0.5,0.5,1,1}},   
    }
end

textBox.draw = function(self)
    local currentColor = self:getColor()
    
    love.graphics.setColor(currentColor.fill)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.radius.x,self.radius.y)
    love.graphics.setColor(currentColor.stroke)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.radius.x,self.radius.y)
    love.graphics.setColor(currentColor.text)
    local text = string.sub(self.text, 1, self.cursorPos) 
    local cursor = ''
    if self.focused and (self.clock % 1 > 0.5) then
        cursor = '|'
    end

    love.graphics.printf(self.text, self.x, self.y, self:getClientSize().x, "left", 0, 1, 1, self.padding.x *-1, self.padding.y * -1)
    local textBeforeCursor = string.sub(self.text, 1, self.cursorPos)
    local _,textLines = love.graphics.getFont():getWrap(textBeforeCursor, self:getClientSize().x)
    local lastLine = textLines[#textLines]
    if string.sub(self.text, #self.text, #self.text) == "\n" then
        love.graphics.printf(
        cursor,
        self.x-love.graphics.getFont():getWidth(cursor)/2,
        self.y + love.graphics.getFont():getHeight() * #textLines,
        self.width - self.padding.x * 2, "left", 0, 1, 1, self.padding.x *-1, self.padding.y * -1
        )
    elseif #self.text == 0 then 
        love.graphics.printf(cursor, self.x, self.y, self.width - self.padding.x * 2, "left", 0, 1, 1, self.padding.x *-1, self.padding.y * -1 )
    else
        love.graphics.printf(
        cursor,
        self.x + love.graphics.getFont():getWidth(lastLine)-love.graphics.getFont():getWidth(cursor)/2,
        self.y + love.graphics.getFont():getHeight() * (#textLines - 1),
        self.width - self.padding.x * 2, "left", 0, 1, 1, self.padding.x *-1, self.padding.y * -1
        )
    end

    --text = text .. string.sub(self.text, self.cursorPos + 1)
    --love.graphics.printf(text, self.x, self.y, self.width - self.padding.x * 2, "left", 0, 1, 1, self.padding.x *-1, self.padding.y * -1)
end

function textBox.keyPressed(self, handled, key, keycode, isRepeat)

    if key == "backspace" and self.cursorPos > 0 then
        self.text = string.sub(self.text, 1, self.cursorPos-1) .. string.sub(self.text, self.cursorPos+1)
        self.cursorPos = self.cursorPos-1
    elseif key == "left" then
        self.cursorPos = math.max(0, self.cursorPos-1)
    elseif key == "right" then
        self.cursorPos = math.min(self.text:len(), self.cursorPos+1)
    elseif key == "delete" then
        self.text = string.sub(self.text, 1, self.cursorPos) .. string.sub(self.text, self.cursorPos+2)
    elseif key == "return" then
        print(self.multiLine)
        if self.multiLine then 
            self:appendText("\n")
        else
            --self.callback()
        end
    end

    print (key)

end

function textBox.textInput(self, handled, key)
    if self.focused then
        self.text = string.sub(self.text, 1, self.cursorPos) .. key .. string.sub(self.text, self.cursorPos + 1)
        self.cursorPos = self.cursorPos + 1
    end
end

function textBox.appendText(self, text)
    self.text = self.text .. text
    self.cursorPos = self.cursorPos + #text
end

return textBox
