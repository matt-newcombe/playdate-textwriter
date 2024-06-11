local gfx <const> = playdate.graphics -- do this at the top of your source file
local spritelib <const> = gfx.sprite

-- A button to continue text image prompt
local btnContinue = spritelib.new()
local btnImageTable = playdate.graphics.imagetable.new("images/btn")
assert(btnImageTable)
btnContinue:setImage(btnImageTable:getImage(2))
btnContinue:moveTo(120, 100)
btnContinue:setZIndex(950)
btnContinue:addSprite()

-- Expect a nine slicable texture for the background dialogue box
local textBoxBg = gfx.nineSlice.new("images/text_box_dark_nine", 5, 5, 5, 3)
assert(textBoxBg)

-- This function handles the animating of the image prompt which
-- expects the player to press a button to advance the current pagination page
local timer = 0.0
local currFrame = 1
local switchTime = 0.5
local function AnimateButton(deltaTime)
	timer += deltaTime

	if timer > switchTime then
		timer = 0.0

		if currFrame == 1 then
			currFrame = 2
		else
			currFrame = 1
		end
	end

	btnContinue:setImage(btnImageTable:getImage(currFrame))
	btnContinue:update()
end

function TextWriter.UpdateGraphics(deltaTime)
	textBoxBg:drawInRect(50, 50, 100, 60)
	AnimateButton(deltaTime)
end