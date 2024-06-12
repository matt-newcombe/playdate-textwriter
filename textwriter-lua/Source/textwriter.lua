local currentPage = -1
local currentLine = -1
local currentCharacter = -1

local characterTimeWaits = {}

local writingTime = 0.0

PrintDelaySetting = 0.15
PunctuationMultiplier = 8

SpecialCharacters =
{
    '.',
    ',',
    '?'
}

TextWriter = {}

local pages = {}

kStateIdle = 0
kStateWriting = 1
kStatePagePause = 2

TextWriter.State = kStateIdle

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
                currentLine -= 1
                currentCharacter = #line
                TextWriter.SetState(kStatePagePause)
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

function TextWriter.OnContinue()
    if (currentPage == #pages) then
        TextWriter.SetState(kStateIdle)
    else
        currentPage += 1
        currentLine = 1
        currentCharacter = 1

        TextWriter.SetState(kStateWriting)
    end
end

function TextWriter.SkipToEndOfPage()
    currentLine = #pages[currentPage]
    currentCharacter = #pages[currentPage][currentLine]
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
    TextWriter.SetState(kStateWriting)

    TextWriter.SetupWritingWaits()
end

local function isempty(s)
    return s == nil or s == ''
end

function TextWriter.GetDisplayingText()
    return displayText
end

function TextWriter.SetState(state)
    TextWriter.State = state
    TextWriter.SetGraphicsState(state)
end

-- DeltaTime is number in seconds
-- Text is string
function TextWriter.Update(deltaTime)
    if TextWriter.State == kStateWriting then
        if (playdate.buttonJustPressed(playdate.kButtonA)) then
            TextWriter.SkipToEndOfPage()
        end

        TextWriter.bookmark = TextWriter.AdvanceInPage(deltaTime)
        TextWriter.UpdateGraphics(deltaTime, pages, TextWriter.bookmark, TextWriter.State)
    elseif TextWriter.State == kStatePagePause then

        if (playdate.buttonJustPressed(playdate.kButtonA)) then
            TextWriter.OnContinue()
        end
        TextWriter.UpdateGraphics(deltaTime, pages, TextWriter.bookmark, TextWriter.State)
    elseif TextWriter.State == kStateIdle then
    end
end