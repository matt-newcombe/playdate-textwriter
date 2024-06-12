local currentPage = -1
local currentLine = -1
local currentCharacter = -1

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

local pages = {}

-- This function given a time delta will return the new updated index in the text we have written up to
function TextWriter.AdvanceInPage(timePassed)
    writingTime = writingTime + timePassed

    line = pages[currentPage][currentLine]

    while currentCharacter <= #line and writingTime > characterTimeWaits[currentPage][currentLine][currentCharacter] do
        writingTime -= characterTimeWaits[currentPage][currentLine][currentCharacter]
        currentCharacter += 1

        if (currentCharacter > #line) then
            currentLine += 1
            currentCharacter = 1

            if (currentLine > #pages[currentPage]) then
                currentPage += 1
                currentLine = 1
                currentCharacter = 1
            end
        end
    end

    return 
    {
        page = currentPage, 
        line = currentLine, 
        char = currentCharacter,
    }
end

function TextWriter.SetupWritingWaits()
    -- process as per page per line
    for pageIdx = 1, #pages do
        page = pages[pageIdx]
        table.insert(characterTimeWaits, {})

        for lineIdx = 1, #page do
            table.insert(characterTimeWaits[pageIdx], {})

            line = page[lineIdx]
            for i = 1, #line do
                local character = line:sub(i,i)
        
                if (SpecialCharacters[character] ~= nil) then
                    characterTimeWaits[pageIdx][lineIdx][i] = Config.PrintDelay * Config.PunctuationMultiplier
                else
                    characterTimeWaits[pageIdx][lineIdx][i] = Config.PrintDelay
                end
            end
        end
    end
end

function TextWriter.Write(toWrite)
    pages = Paginate(toWrite, 200, 50)
    currentPage = 1
    currentLine = 1
    currentCharacter = 1
    writing = true

    TextWriter.SetupWritingWaits()
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
        bookmark = TextWriter.AdvanceInPage(deltaTime)
        displayText = pages[bookmark.page][bookmark.line]:sub(1, bookmark.char)
        if isempty(displayText) then displayText = "." end
    else
        displayText = "."
    end


    TextWriter.UpdateGraphics(deltaTime, pages, bookmark)
    return displayText
end