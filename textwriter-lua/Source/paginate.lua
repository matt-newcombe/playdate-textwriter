local substr <const> = string.sub
local string_byte <const> = string.byte

function GetPixelWidth(text)
    myFont = playdate.graphics.getFont(playdate.graphics.font.kVariantNormal)
    pixelWidth = myFont:getTextWidth(text)
    return pixelWidth
end

function GetPixelHeight()
    return playdate.graphics.getFont(playdate.graphics.font.kVariantNormal):getHeight()
end

function SplitTextIntoWords(text)
    words = {}
    for word in text:gmatch("%S+") do table.insert(words, word) end
    return words
end

function GetMaxLines(h)
    pixelHeight = GetPixelHeight()
    maxLines = math.floor(h/pixelHeight)

    D("fontHeight", GetPixelHeight())
    D("boxHeight", h)
    D("maxLine", maxLines)
    
    return maxLines
end

-- this function will process the next line to output, and split into pages if needed
-- calls recursively
-- note this won't work with special bytes
function Paginate(text, w, h)
    local words = SplitTextIntoWords(text)

    local pages = {}
    local current_page = {}
    local current_line = ""
    local line_count = 0

    local wordIdx = 1

    while wordIdx <= #words do
        local currWord = words[wordIdx]
        local appended_line = current_line .. (current_line == "" and "" or " ") .. currWord

        -- Check width of line
        if (GetPixelWidth(appended_line) <= w) then
            current_line = appended_line -- we're okay, append to the current line and carry on
            wordIdx += 1

            -- if we've reached the end of the words then insert into the line and page
            if (wordIdx > #words) then
                table.insert(current_page, current_line)
                table.insert(pages, current_page)
            end
        else
            -- handle case where supplied width is not wide enough
            if (current_line == "") then
                print("Error textbox width is not wide enough for word: ".. currWord)
                return pages
            end

            -- We would break our width limit, break a new line and repeat the while loop with the same idx
            table.insert(current_page, current_line)
            line_count += 1
            current_line = ""

            -- The next line would break the heiught limit, break a new page
            if line_count >= GetMaxLines(h) then
                table.insert(pages, current_page)
                current_page = {}
                line_count = 0
            end
        end
    end

    return pages
end