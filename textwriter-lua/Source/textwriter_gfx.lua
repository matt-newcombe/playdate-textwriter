local gfx <const> = playdate.graphics -- do this at the top of your source file
local spritelib <const> = gfx.sprite

-- Load up sprite image table for button press graphics and add to sprite
local titleSprite = spritelib.new()
local btnImageTable = playdate.graphics.imagetable.new("images/btn")
assert(btnImageTable)
titleSprite:setImage(btnImageTable:getImage(2))
titleSprite:moveTo(120, 100)
titleSprite:setZIndex(950)
titleSprite:addSprite()

local timer = 0.0
local currFrame = 1
local switchTime = 0.5
function animateButton(deltaTime)
	timer += deltaTime

	if timer > switchTime then
		timer = 0.0

		if currFrame == 1 then
			currFrame = 2
		else
			currFrame = 1
		end
	end

	titleSprite:setImage(btnImageTable:getImage(currFrame))
	titleSprite:update()
end