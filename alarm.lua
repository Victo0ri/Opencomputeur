local component = require("component")
local sides = require("sides")
local colors = require("colors")
local term = require("term")
local keyboard = require("keyboard")
local event = require("event")
local rs = component.redstone

local function Exit() -- Exit the program
    term.clear()
    os.exit()
end

------------------------Clignottement lamp---------------------------------------------------------
local blinkTimer = nil
local state = false

local function startBlink()
    if not blinkTimer then
        blinkTimer = event.timer(0.5, function()
            state = not state
            rs.setOutput(sides.top, state and 15 or 0)
        end, math.huge)
    end
end

local function stopBlink()
    if blinkTimer then
        event.cancel(blinkTimer)
        blinkTimer = nil
        rs.setOutput(sides.top, 0)
    end
end
---------------------------------------------------------------------------------------------------

local function inputB(sides, colors) -- Get the input from the bundle
    local result = rs.getBundledInput(sides, colors)
    return result
end

local function SetBig(sides, value) -- Activate the alarm (Emergency)
    rs.setOutput(sides, value)
    startBlink()
end

local function SetSmall(sides, value) -- Activate the alarm (Warning)
    rs.setOutput(sides, value)
end

while true do
    ------------------------Set the colors-----------------------------------------------------
    local white = inputB(sides.south, colors.white)
    local black = inputB(sides.south, colors.black)
    local lime = inputB(sides.south, colors.lime)
    local yellow = inputB(sides.south, colors.yellow)
    -------------------------------------------------------------------------------------------

    term.clear()
    
    if white > 1 then -- Bundel from Cleanroom
        print("\n/!\\ Emergency /!\\\nAlarme from Cleanroom !")
    end

    if lime > 1 then -- Bundel from intensive process
        print("\n/!\\ Emergency /!\\\nAlarme from intensive production !")
    end

    if black > 1 then -- Bundel from Benzene production
        print("\n! Warning !\nAlarme from Benzene production !")
    end

    if yellow > 1 then -- Bundel from passive process
        print("\n! Warning !\nAlarme from passive production !")
    end

    if white > 1 or lime > 1 then -- Turn ON the big alarm
        SetBig(sides.north, 15)
        SetSmall(sides.east, 0)
    elseif black > 1 or yellow > 1 then -- Turn ON the small alarm
        stopBlink()
        SetSmall(sides.east, 15)
        rs.setOutput(sides.top, 15)
        rs.setOutput(sides.north, 0)
    else -- Turn OFF all alarm
        SetBig(sides.north, 0)
        SetSmall(sides.east, 0)
        rs.setOutput(sides.top, 0)
        stopBlink()
    end

    os.sleep(2)

    if keyboard.isShiftDown() and keyboard.isControlDown() then
        break
    end
end

Exit()