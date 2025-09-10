local component = require("component")
local sides = require("sides")
local colors = require("colors")
local rs = component.redstone

local function inputB(sides, colors) -- Get the input from the bundle
    local result = rs.getBundledInput(sides, colors)
    return result
end

local function SetBig(sides, value) -- Set the big alarm (Emergency)
    local result = rs.setOutput(sides, value)
    return result
end

local function SetSmall(sides, value) -- Set the small alarm (Warning)
    local result = rs.setOutput(sides, value)
    return result
end

while true do

    term.clear()

    local red = inputB(sides.top, colors.red)  -- 0 = alarm : off | 15 = alarm : on
    local white = inputB(sides.top, colors.white) -- 0 = alarm : off | 15 = alarm : on
    local lime = inputB(sides.top, colors.lime) -- 0 = alarm : off | 15 = alarm : on
    local black = inputB(sides.top, colors.black) -- 0 = alarm : off | 15 = alarm : on

    if red > 1 then
        big(sides.north, 15)

    else

    end

end
