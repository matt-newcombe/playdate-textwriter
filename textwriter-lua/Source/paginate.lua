local substr <const> = string.sub
local string_byte <const> = string.byte

-- Matt TODO: This code doesn't consider per character pixel sizes and as such is likely to be inaccurate
-- probably need to re-write this entirely at some stage, but is great as a first pass
-- https://github.com/nstbayless/pulp-to-lua/blob/329d4bb064cbd0a6baf30334925aceb931e37dd9/pulp.lua#L188
function PaginateText(text, w, h)
    local x = 0
    local y = 0
    local startidx = 1
    local wordidx = 1
    local pages = {""}
    local in_embed = 0
    for i = 1,#text+1 do
        if i == #text+1 then
            pages[#pages] = pages[#pages] .. substr(text,startidx, #text)
        else
            local char = substr(text, i, i)
            local chbyte = string_byte(text, i, i)
            if chbyte < 0x80 then
                in_embed = 0
            end
            if char == "\n" or char == "\f" then
                pages[#pages] = pages[#pages] .. substr(text, startidx, i)
                startidx = i + 1
                wordidx = i + 1
                y += 1
                x = 0
                if char == "\f" then
                    pages[#pages + 1] = ""
                    y = 0
                end
            elseif char == " " or char == "\t" then
                x += 1
                wordidx = i + 1
            elseif chbyte >= 0x80 then
                if in_embed <= 0 then
                    x += 1
                    in_embed = chbyte - 0x80 -- embed header is number of bytes encoding embed
                else
                    in_embed -= 1 
                end
            else
                x += 1
            end
            
            if x >= w then
                if startidx < wordidx then
                    pages[#pages] = pages[#pages] .. substr(text,startidx, wordidx - 1) .. "\n"
                    pages[#pages] = pages[#pages] .. substr(text, wordidx, i - 1)
                    wordidx = 0
                else
                    pages[#pages] = pages[#pages] .. substr(text,startidx, i - 1) .. "\n"
                    wordidx = i
                end
                x = 0
                y += 1
                startidx = i
            end
            if y >= h then
                y = 0
                pages[#pages + 1] = ""
            end
        end
    end
    
    if pages[#pages] == "" then
        pages[#pages] = nil
    end
    
    -- strip lines on each page after the fact
    -- FIXME: should strip above for correct behaviour
    for i = 1,#pages do
        pages[i] = string.gsub(pages[i], " *\n *", "\n")
    end
    
    return pages
end