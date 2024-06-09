local debugLineYPos = 5
local screenHeight = 220
local debugLineYJump = 20

local KeyToString = {}

function DClear()
    dKeyToString = {}
end

function D(key, str)
  KeyToString[key] = str
end

function DDraw()
  local yPos = debugLineYPos
  for k, v in pairs(KeyToString) do
    playdate.graphics.drawText(k .. ": " .. v, 5, screenHeight - yPos)
    yPos += debugLineYJump
  end
end
