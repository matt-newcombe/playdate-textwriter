import 'D'
import 'io'
import 'paginate'
import 'textwriter_config'
import 'textwriter'
import "CoreLibs/graphics"

local gfx = playdate.graphics

local windowWidth = 100
local windowHeight = 50

local windowXPos = 2
local windowYPos = 2

local text = ReadFileAsOneString("textsource.txt")

TextWriter.Write(text)

function playdate.update()
	-- reset to get a delta time each frame (should prob just calc from time)
	local deltaTime = playdate.getElapsedTime()
	playdate.resetElapsedTime()

	-- Rendering
	gfx.clear(gfx.kColorWhite)
	gfx.setColor(gfx.kColorBlack)

	local writtenText = TextWriter.Update(deltaTime)

	-- Text
	playdate.graphics.imageWithText(writtenText, windowWidth, windowHeight):draw(windowXPos,windowYPos)
	playdate.graphics.drawRect(windowXPos, windowYPos, windowWidth, windowHeight)

	-- Debug
	playdate.drawFPS(250,20)

	D("deltaTime", deltaTime)

	DDraw()

end


