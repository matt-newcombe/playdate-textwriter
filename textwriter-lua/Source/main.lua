import 'textwriter_config'

-- playdate imports
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/nineslice"

-- custom imports
import 'D'
import 'io'
import 'paginate'
import 'textwriter'
import 'textwriter_gfx'

-- const defines
local gfx <const> = playdate.graphics -- do this at the top of your source file
local spritelib <const> = gfx.sprite
local screenWidth <const> = playdate.display.getWidth()
local screenHeight <const> = playdate.display.getHeight()

TextWriter.ConfigureDialogue(0,0,300,100)
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

	-- Rendering
	gfx.clear(gfx.kColorWhite)
	gfx.setColor(gfx.kColorBlack)
	spritelib.update()

	-- logic
	TextWriter.Update(deltaTime)
	
	-- Debug
	playdate.drawFPS(250,20)

	D("deltaTime", deltaTime)
	D("elapsedTime", elapsedTime)

	--DDraw()

end