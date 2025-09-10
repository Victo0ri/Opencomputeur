local component = require("component")
local sides = require("sides")
local colors = require("colors")
local rs = component.redstone

local function inputB(sides) -- Get the input from the bundle
    local result = rs.getBundledInput(sides)
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

local function GetBig --Get the information alarm (Emergency)
    if inputB(sides.north, colors.0) > 1 . inputB(sides.north, color.5)
        SetBig
    else
        
end

local function GetSmall(sides, value) -- Get the information alarm (Warning)
    if inputB(sides.north, colors.15) > 1 . inputB(sides.north, colors.4)

while true do

    term.clear()


end
