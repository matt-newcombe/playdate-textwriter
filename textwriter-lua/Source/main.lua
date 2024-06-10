-- playdate imports
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

-- custom imports
import 'D'
import 'io'
import 'paginate'
import 'textwriter_gfx'
import 'textwriter_config'
import 'textwriter'

-- const defines
local gfx <const> = playdate.graphics -- do this at the top of your source file
local spritelib <const> = gfx.sprite
local screenWidth <const> = playdate.display.getWidth()
local screenHeight <const> = playdate.display.getHeight()

-- dialogue box pos (MATT: Should move to text writer)
local textRectWidth = 100
local textRectHeight = 50

local textRectX = 2
local textRectY = 2

local dialogue = ReadFileAsOneString("text/textsource.txt")
TextWriter.Write(dialogue)

local lastTime = 0.0

-- init
playdate.display.setRefreshRate(50)
gfx.setBackgroundColor(gfx.kColorWhite)
gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0, 0, screenWidth, screenHeight)

function playdate.update()
	-- reset to get a delta time each frame (should prob just calc from time)
	local elapsedTime = playdate.getElapsedTime()
	local deltaTime = elapsedTime - lastTime
	lastTime = elapsedTime

	animateButton(deltaTime)
	
	-- Rendering
	gfx.clear(gfx.kColorWhite)
	gfx.setColor(gfx.kColorBlack)
	spritelib.update()

	-- Text
	local writtenText = TextWriter.Update(deltaTime)
	gfx.imageWithText(writtenText, textRectWidth, textRectHeight):draw(textRectX,textRectY)
	gfx.drawRect(textRectX, textRectY, textRectWidth, textRectHeight)

	-- Debug
	playdate.drawFPS(250,20)

	D("deltaTime", deltaTime)
	D("elapsedTime", elapsedTime)

	DDraw()

end