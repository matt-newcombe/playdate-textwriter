import "CoreLibs/graphics"

local gfx = playdate.graphics

function playdate.update()

	-- Rendering
	gfx.clear(gfx.kColorWhite)
	gfx.setColor(gfx.kColorBlack)

	-- Text
	playdate.graphics.drawText("Hello World", 5, 5)

	-- Debug
	playdate.drawFPS(250,20)
end


