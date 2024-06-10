-- custom imports
import 'D'
import 'io'
import 'paginate'
import 'textwriter_config'
import 'textwriter'

-- playdate imports
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics -- do this at the top of your source file
local spritelib <const> = gfx.sprite
local screenWidth <const> = playdate.display.getWidth()
local screenHeight <const> = playdate.display.getHeight()

local textRectWidth = 100
local textRectHeight = 50

local textRectX = 2
local textRectY = 2

local dialogue = ReadFileAsOneString("text/textsource.txt")
playdate.display.setRefreshRate(50)
TextWriter.Write(dialogue)

-- reset the screen to white
gfx.setBackgroundColor(gfx.kColorWhite)
gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0, 0, screenWidth, screenHeight)

local titleSprite = spritelib.new()
local image = gfx.image.new( 'images/generic_button_finger' )
assert(image)
titleSprite:setImage(image)
titleSprite:moveTo(screenWidth / 2, screenHeight / 2.5)
titleSprite:setZIndex(950)
titleSprite:addSprite()

function playdate.update()
	-- reset to get a delta time each frame (should prob just calc from time)
	local deltaTime = playdate.getElapsedTime()
	playdate.resetElapsedTime()

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

	DDraw()

end