local gfx <const> = playdate.graphics -- do this at the top of your source file
local spritelib <const> = gfx.sprite

local btnContinue = {}
local dialogueNineSlice = {}
local btnImageTable = {}
local textBoxSprite = {}

local BASE_Z_LAYER = 300

local dialogueBoxW = 200
local dialogueBoxH = 90

local dialogueBoxX = 150
local dialogueBoxY = 120

local textPadding = 5

function TextWriter.InitGraphics()
    -- Sprite for text box (note nineslice image will overwrite this)
    textBoxSprite = spritelib.new()
    textBoxSprite:setImage(gfx.image.new(dialogueBoxW, dialogueBoxH, gfx.kColorWhite))
    textBoxSprite:addSprite()
    textBoxSprite:setZIndex(0 + BASE_Z_LAYER)

    -- Sprite Continue Button
    btnContinue = spritelib.new()
    btnImageTable = playdate.graphics.imagetable.new("images/btn")
    assert(btnImageTable)
    btnContinue:setImage(btnImageTable:getImage(2))
    btnContinue:addSprite()
    btnContinue:setZIndex(1 + BASE_Z_LAYER)
    btnContinue:setOpaque(true)

    -- Expect a nine slicable texture for the background dialogue box
    dialogueNineSlice = gfx.nineSlice.new("images/text_box_nine", 5, 5, 5, 3)
    assert(dialogueNineSlice)
end

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

local function MoveButtonPromptToBoxPos()
    local xOffset = -10
    local yOffset = -10

    local xPos = dialogueBoxX + dialogueBoxW/2 - xOffset
    local yPos = dialogueBoxY + dialogueBoxH/2 - yOffset

    btnContinue:moveTo(xPos, yPos)
end

local function DrawDialogueBackground()
    textBoxSprite:moveTo(dialogueBoxX, dialogueBoxY)

    -- use lock focus to overwrite the spriteNS image with the nineslice draw
    gfx.lockFocus(textBoxSprite:getImage())
    dialogueNineSlice:drawInRect(0, 0, dialogueBoxW, dialogueBoxH)
    gfx.unlockFocus()
end

local function DrawText(writtenText)
    local xPos = dialogueBoxX - (dialogueBoxW/2) + textPadding
    local yPos = dialogueBoxY - (dialogueBoxH/2) + textPadding
    
        -- Text
	gfx.imageWithText(writtenText, dialogueBoxW, dialogueBoxH):draw(xPos, yPos)

end

function TextWriter.UpdateGraphics(deltaTime, writtenText)
    AnimateButton(deltaTime)
    MoveButtonPromptToBoxPos()
    DrawDialogueBackground()
    DrawText(writtenText)
end