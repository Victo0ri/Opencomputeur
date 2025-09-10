local component = require("component")
local sides = require("sides")
local colors = require("colors")
local term = require("term")
local keyboard = require("keyboard")
local rs = component.redstone

function Exit()
    term.clear()
    os.exit()
end

local function inputB(sides, colors) -- Get the input from the bundle
    local result = rs.getBundledInput(sides, colors)
    return result
end

local function SetBig(sides, value) -- Activate the alarm (Emergency)
    rs.setOutput(sides, value)
end

local function SetSmall(sides, value) -- Activate the alarm (Warning)
    rs.setOutput(sides, value)
end

while true do
------------------------Set the colors-------------------------------------------------------------
local white = inputB(sides.south, colors.white)
local black = inputB(sides.south, colors.black)
local lime = inputB(sides.south, colors.lime)
local yellow = inputB(sides.south, colors.yellow)
---------------------------------------------------------------------------------------------------

    term.clear()
    
    if white > 1 then
        print("\n/!\\ Emergency /!\\\nAlarme from Cleanroom !")
    end

    if lime > 1 then
        print("\n/!\\ Emergency /!\\\nAlarme from intenssive production !")
    end

    if black > 1 then
        print("\n! Warning !\nAlarme from Benzene production !")
    end

    if yellow > 1 then
        print("\n! Warning !\nAlarme from passive production !")
    end

    if white > 1 or lime > 1 then
        SetBig(sides.north, 15)
    elseif black > 1 or yellow > 1 then
        SetSmall(sides.east, 15)
    end

    os.sleep(2)

    if keyboard.isShiftDown() and keyboard.isControlDown() then
        break
    end

end

Exit()