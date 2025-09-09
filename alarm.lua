local component = require("component")
local sides = require("sides")
local colors = require("colors")
local rs = component.redstone

local function inputB(sides, colors)
    local result = rs.getBundledInput(sides, colors)
    return result
end

local function big(sides, value)
    local result = rs.setOutput(sides, value)
    return result
end

local function small(sides, value)
    local result = rs.setOutput(sides, value)
    return result
end

while true do

    term.clear()

    local red = inputB(sides.top, colors.red)  -- 0 =           | 15 = 
    local white = inputB(sides.top, colors.white) -- 0 =            | 15 = 
    local lime = inputB(sides.top, colors.lime) -- 0 =          | 15 = 
    local black = inputB(sides.top, colors.black) -- 0 =            | 15 = 

    if red > 1 then
        big(sides.north, 15)

    else

    end

end
