local application = require("application")
local button = require("button")
local textBox = require("textbox")
local selectBox = require("select")
local listBox = require('list')

local app, buttonSend, textBoxHistory, selectCommand, listCommand


function love.load()
  app = application.new()
  textBoxHistory = textBox.new(app, 10,10, 570, 500, true)
  textBoxHistory:appendText("Hello World!")
  buttonSend = button.new(app, 310, 520, "Send")
  selectCommand = selectBox.new(app, 10, 520, {"First", "Second", "Third"}, "up")
  textBoxHistory:appendText("Hello World!")
  listBoxCommand = listBox.new(app, 590,10,200,500, {"Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth", "Tenth", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth", "Tenth", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth", "Tenth", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth", "Tenth"})
end
 

function love.update(dt)
   app:update(dt)
end

function love.draw()
  app:draw()
end

function love.mousereleased(x, y, button, istouch)
   app:mouseReleased(x, y, button, istouch)
end

function love.mousepressed(x, y, button, istouch)
   app:mousePressed(x, y, button, istouch)
end

function love.keypressed(key, keycode, isRepeat)
  app:keyPressed(key, keycode, isRepeat)
end

function love.textinput(text)
  -- for some reason this is never called!
  app:textInput(text)
end
