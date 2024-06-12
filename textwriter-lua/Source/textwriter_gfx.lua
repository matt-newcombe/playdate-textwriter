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
btnContinue:setVisible(false)

-- Expect a nine slicable texture for the background dialogue box
dialogueNineSlice = gfx.nineSlice.new("images/text_box_nine", 5, 5, 5, 3)
assert(dialogueNineSlice)

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

local function DrawText(pages, bookmark)

	local page = pages[bookmark.page]
	local ySpacing = GetPixelHeight()

	for lineIdx = 1, bookmark.line do
		local xPos = dialogueBoxX - (dialogueBoxW/2) + textPadding
		local yPos = dialogueBoxY - (dialogueBoxH/2) + textPadding + (ySpacing * (lineIdx-1))

		if (lineIdx < bookmark.line) then
			-- it's not the last line so we're rendering the whole line
			gfx.imageWithText(page[lineIdx], dialogueBoxW, dialogueBoxH):draw(xPos, yPos)
		else
			-- it's the last line, sub string up to the boookmark character
			gfx.imageWithText(page[lineIdx]:sub(1, bookmark.char), dialogueBoxW, dialogueBoxH):draw(xPos, yPos)
		end
	end
end

local function HideContinueButton()
	btnContinue:setVisible(false)
end

local function ShowContinueButton()
	btnContinue:setVisible(true)
end

local function HideDialogueBackground()
	textBoxSprite:setVisible(false)
end

local function ShowDialogueBackground()
	textBoxSprite:setVisible(true)
end

function TextWriter.SetGraphicsState(state)
	if (state == kStateWriting) then
		ShowDialogueBackground()
		HideContinueButton()
	elseif (state == kStatePagePause) then
		ShowContinueButton()
	elseif (state == kStateIdle) then
		HideContinueButton()
		HideDialogueBackground()
	end
end

function TextWriter.UpdateGraphics(deltaTime, pages, bookmark, state)
	MoveButtonPromptToBoxPos()

	if (TextWriter.State == kStateIdle) then
		return
	end

	if (TextWriter.State == kStatePagePause) then
		AnimateButton(deltaTime)
	end
		
    DrawDialogueBackground()
    DrawText(pages, bookmark)
end