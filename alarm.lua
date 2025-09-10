local component = require("component")
local sides = require("sides")
local colors = require("colors")
local rs = component.redstone

local function inputB(sides, colors) -- Get the input from the bundle
    local result = rs.getBundledInput(sides, colors)
    return result
end

local function SetBig(sides, value) -- Activate the alarm (Emergency)
    local result = rs.setOutput(sides, value)
    return result
end

local function SetSmall(sides, value) -- Activate the alarm (Warning)
    local result = rs.setOutput(sides, value)
    return result
end

local function GetBig() --Get the information alarm (Emergency)
    if inputB(sides.north, 0) > 1 or inputB(sides.north, 5) > 1 then
        SetBig()
    else
        
    end
end

local function GetSmall(sides, value) -- Get the information alarm (Warning)
    if inputB(sides.north, 15) > 1 or inputB(sides.north, 4) > 1 then
        SetSmall()
    else
        
    end
end

while true do

    term.clear()

end
