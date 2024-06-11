local currentIndex = -1
local characterCount = -1
local writeText = ""
local currentText = ""

local characterTimeWaits = {}
local writing = false

local writingTime = 0.0


PrintDelaySetting = 0.15
PunctuationMultiplier = 8

SpecialCharacters =
{
    '.',
    ',',
}

TextWriter = {}

-- This function given a time delta will return the new updated index in the text we have written up to
function TextWriter.SeekCharacters(timePassed)
    D("CurrIdx",currentIndex)

    writingTime = writingTime + timePassed

    while currentIndex < characterCount-1 and writingTime > characterTimeWaits[currentIndex] do
        writingTime -= characterTimeWaits[currentIndex]
        currentIndex = currentIndex+1
    end

    return currentIndex
end

function TextWriter.ParseText()
    for i = 0, characterCount-1, 1 do
        local character = writeText:sub(i,i)

        if (SpecialCharacters[character] ~= nil) then
            characterTimeWaits[i-1] = Config.PrintDelay * Config.PunctuationMultiplier
        else
            characterTimeWaits[i-1] = Config.PrintDelay
        end
    end
end

function TextWriter.Write(toWrite)
    pages = PaginateText(toWrite, 100, 50)
    characterCount = string.len(pages[1])
    currentIndex = 0
    writeText = pages[1]
    writing = true

    TextWriter.ParseText()
end

local function isempty(s)
    return s == nil or s == ''
end

function TextWriter.GetDisplayingText()
    return displayText
end

-- DeltaTime is number in seconds
-- Text is string
function TextWriter.Update(deltaTime)
    if writing then
        TextWriter.SeekCharacters(deltaTime)
        displayText = writeText:sub(0,currentIndex)
        if isempty(displayText) then displayText = "." end
    else
        displayText = "."
    end


    TextWriter.UpdateGraphics(deltaTime, displayText)
    return displayText
end